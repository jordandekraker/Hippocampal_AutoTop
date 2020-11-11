function Resample_Native(hippDir,outdir)
% Reverts resampling applied by Resample_CoronalOblique. Assumes hippDir is
% a subdirectory containing all unfolding files from one subject's left OR
% right hippocampus, with that subject's whole brain data up one directory.

%% load relevant data

load([hippDir '/unfold.mat'])
combined = ls([hippDir '/../sub2coronalOblique.txt']); % this is expected to be up one directory
combined(end) = [];

origimg = [hippDir '/../original.nii.gz'];

if contains(hippDir,'hemi-R')
    LR = 'R';
elseif contains(hippDir,'hemi-Lnoflip')
    LR = 'Lnoflip';
elseif contains(hippDir,'hemi-L')
    LR = 'L';
else
    warning('Could not determine left/right hemisphere; output may be flipped')
    LR = [];
end

%% apply to images
imgList = {'coords-AP','coords-PD','coords-IO',...
    'labelmap-postProcess','subfields-BigBrain'};

for f = 1:length(imgList)
    % TODO: add exception for transforming .vtk back to native (i.e.
    % flipping left image)
    img = ls([hippDir '/' imgList{f} '*.nii.gz']);
    img(end) = [];
    
    if LR == 'L'
        unflip_dir = [hippDir '/../hemi-Lnoflip']
        i = load_untouch_nii(img);
        i.img = flip(i.img,1); % flip (only if right)
        mkdir(unflip_dir); % just to ensure this exists
        img = [unflip_dir '/' imgList{f} '.nii.gz'];
        save_untouch_nii(i,img);
    end
    
    system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
        '-i ' img ' '...
        '-o ' outdir '/' imgList{f} '_hemi-' LR '.nii.gz '...
        '-r ' origimg ' '...
        '-t [' combined ',1]']); % inverse of sub2coronalOblique 
end

%% apply to surfaces

load([hippDir '/unfold.mat']);
load([hippDir '/surf.mat']);
v = reshape(Vmid,[256*128,3]);
itransf = [1,-1,1,-1; -1,1,1,-1; 1,1,1,1; 0,0,0,1];

% Bring vertex coordinates in native space
% TODO: confirm these transforms. off by 1, or off by 0.5?
v(:,2) = (v(:,2));
v(:,3) = (v(:,3));
if LR == 'L'
    v(:,1) = sz(1)-v(:,1);
else
    v(:,1) = (v(:,1));
end
% if origheader.hdr.dime.pixdim(1) == -1 % prevent unintended file flips
%     v(:,1) = sz(1)-v(:,1);
% end


% apply qform or sform
if origheader.hdr.hist.sform_code>0
    sform = [origheader.hdr.hist.srow_x;...
        origheader.hdr.hist.srow_y;...
        origheader.hdr.hist.srow_z;...
        0 0 0 1];
    v = sform*[v'; ones(1,length(v))];
elseif origheader.hdr.hist.qform_code>0
    qform = [origheader.hdr.dime.pixdim(2) 0 0 origheader.hdr.hist.qoffset_x;...
            0 origheader.hdr.dime.pixdim(3) 0 origheader.hdr.hist.qoffset_y;...
            0 0 origheader.hdr.dime.pixdim(4)  origheader.hdr.hist.qoffset_z;...
            0 0 0 1];
    v = qform*[v'; ones(1,length(v))];
else
    warning('could not read nifti qform or sform for transforming .vtk midsurface');
end

% load transforms as matrices
combinedmat = import_txtAffine(combined);

% invert transforms
combinedmat = itransf.*combinedmat;
% apply transforms
v = combinedmat*v;
Vnative = v';

% Write file
out = [outdir '/midSurf_hemi-' LR '.vtk'];
vtkwrite(out,'polydata','triangle',Vnative(:,1),Vnative(:,2),Vnative(:,3),F);
