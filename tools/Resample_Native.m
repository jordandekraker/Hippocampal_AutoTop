function Resample_Native(hippDir,outdir)
% Reverts resampling applied by Resample_CoronalOblique. Assumes hippDir is
% a subdirectory containing all unfolding files from one subject's left OR
% right hippocampus, with that subject's whole brain data up one directory.

%% load relevant data

load([hippDir '/unfold.mat'])
aff1 = ls([hippDir '/../sub2atlas.*']); % this is expected to be up one directory
aff1(end) = [];
aff2 = ls([hippDir '/../atlas2coronalOblique.*']); % this is expected to be up one directory
aff2(end) = [];
origimg = [hippDir '/../original.nii.gz'];

if contains(hippDir,'hemi-R')
    LR = 'R';
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
        i = load_untouch_nii(img);
        i.img = flip(i.img,1); % flip (only if right)
        mkdir([hippDir '/tmp']); % just to ensure this exists
        save_untouch_nii(i,[hippDir '/tmp/flipping.nii.gz']);
        img = [hippDir '/tmp/flipping.nii.gz'];
    end
    
    system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
        '-i ' img ' '...
        '-o ' outdir '/' imgList{f} '_hemi-' LR '.nii.gz '...
        '-r ' origimg ' '...
        '-t [' aff2 ',1] '...; % reverse the affine
        '-t [' aff1 ',1]']); % reverse the affine
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
ras = [origheader.hdr.hist.srow_x;  origheader.hdr.hist.srow_y; origheader.hdr.hist.srow_z; 0 0 0 1];
v = ras*[v'; ones(1,length(v))];


% load transforms as matrices
i = strfind(aff1,'.');
suffix = aff1(i(end):end);
if strcmp(suffix,'.mat')
    affmat1 = load(aff1);
    if isfield(affmat1,'AffineTransform_double_3_3') %ANTs generated
        affmat1 = reshape(affmat1.AffineTransform_double_3_3,[3,4]);
    elseif isfield(affmat1,'MatrixOffsetTransformBase_double_3_3') %FLIRT + fsl2ras -oitk generated
        affmat1 = reshape(affmat1.MatrixOffsetTransformBase_double_3_3,[3,4]);
    else
        error(['Could not interpret ' aff1]);
    end
    affmat1(4,1:4) = [0,0,0,1];
elseif strcmp(suffix,'.txt')
    affmat1 = import_txtAffine(aff1);
else
    error('Could not load transformation to native space');
end

i = strfind(aff2,'.');
suffix = aff2(i(end):end);
if strcmp(suffix,'.mat')
    affmat2 = load(aff2);
    if isfield(affmat2,'AffineTransform_double_3_3') %ANTs generated
        affmat2 = reshape(affmat2.AffineTransform_double_3_3,[3,4]);
    elseif isfield(affmat2,'MatrixOffsetTransformBase_double_3_3') %FLIRT + fsl2ras -oitk generated
        affmat2 = reshape(affmat2.MatrixOffsetTransformBase_double_3_3,[3,4]);
    else
        error(['Could not interpret ' aff2]);
    end
    affmat2(4,1:4) = [0,0,0,1];
elseif strcmp(suffix,'.txt')
    affmat2 = import_txtAffine(aff2);
else
    error('Could not load transformation back to native space');
end

% invert transforms
affmat1 = itransf.*affmat1;
affmat2 = itransf.*affmat2;
% apply transforms
v = affmat2*v;
v = affmat1*v;
Vnative = v';

% Write file
out = [outdir '/midSurf_hemi-' LR '.vtk'];
vtkwrite(out,'polydata','triangle',Vnative(:,1),Vnative(:,2),Vnative(:,3),F);
