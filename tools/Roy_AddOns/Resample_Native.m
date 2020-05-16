function Resample_Native(hippDir,outdir,imgList)
addpath(genpath('/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/freesurfer/5.3.0/matlab'));

% Reverts resampling applied by Resample_CoronalOblique. Assumes hippDir is
% a subdirectory containing all unfolding files from one subject's left OR
% right hippocampus, with that subject's whole brain data up one directory.
% Can be applied to a list of files in call array imgList

imgList={'coords-AP','coords-IO','coords-PD', ...
    'labelmap-postProcess','subfields-BigBrain'}';
subs = strsplit(ls('unfolding_autotop/'))';
subs(end) = [];

for s = 2:length(subs)
    hippDir = ['unfolding_autotop/' subs{s}];
    aff = [hippDir '/0GenericAffine.mat']; % this is expected to be up one directory
    origimg = [hippDir '/original.nii.gz'];
    
%     for f = 1:length(imgList)
%         img = strsplit(ls([hippDir '/hemi-*/' imgList{f} '*.nii.gz']))';
%         img(end) = [];
%         
%         for ff = 1:length(img)
%             input = img{ff};
%             if contains(input,'hemi-L')
%                 i = load_untouch_nii(input);
%                 i.img = flip(i.img,1); % flip (only if left)
%                 mkdir([hippDir '/tmp']); % just to ensure this exists
%                 save_untouch_nii(i,[hippDir '/tmp/flipping.nii.gz']);
%                 input = [hippDir '/tmp/flipping.nii.gz'];
%                 LR = 'L';
%             else
%                 LR = 'R';
%             end
%             output = [hippDir '/hemi-' LR '/' imgList{f} '_space-native_hemi-' LR '.nii.gz'];
%             if ~exist(output)
%                 system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
%                     '-i ' input ' '...
%                     '-o ' output ' '...
%                     '-r ' origimg ' '...
%                     '-t [' aff ',1]']); % reverse the affine
%             end
%         end
%     end

    for LR = 'LR'
        load([hippDir '/hemi-' LR '/surf.mat']);
        load([hippDir '/0GenericAffine.mat']);
        
        img = load_nifti([hippDir '/img.nii.gz']);        

        % Inverse affine transformation
        itransf = [1,-1,1,-1; -1,1,1,-1; 1,1,1,1; 0,0,0,1];
        transf = reshape(AffineTransform_double_3_3,[3,4]);
        transf(4,1:4) = [0,0,0,1];
        transf = itransf.*transf;

        % Bring vertex coordinates in native space
        v = reshape(Vmid,[256*128,3]);
        v(:,2) = (v(:,2)-1);
        v(:,3) = (v(:,3)-1);

        if LR == 'L'
            v(:,1) = size(img.vol,1)-v(:,1);
        else
            v(:,1) = (v(:,1)-1);
        end
        
        v = img.vox2ras*[v'; ones(1,length(v))];
        v = transf*v;
        Vnative = v';
        
        % Write file
        out = [hippDir '/hemi-' LR '/midSurf_space-native_hemi-' LR '.vtk'];
        vtkwrite(out,'polydata','triangle',Vnative(:,1),Vnative(:,2),Vnative(:,3),F);
        save([hippDir '/hemi-' LR '/surf.mat'],'Vnative','-append');
    end
end
