function Resample_Native(hippDir,outdir,imgList)
% Reverts resampling applied by Resample_CoronalOblique. Assumes hippDir is
% a subdirectory containing all unfolding files from one subject's left OR
% right hippocampus, with that subject's whole brain data up one directory.
% Can be applied to a list of files in call array imgList


aff = [hippDir '/../0GenericAffine.mat']; % this is expected to be up one directory
origimg = [hippDir '/../original.nii.gz'];

for f = 1:length(imgList)
    % TODO: add exception for transforming .vtk back to native (i.e.
    % flipping left image)
    img = ls([hippDir '*' imgList{f} '*.nii.gz']);
    img(end) = [];
    
    if contains(img,'hemi-L')
        i = load_untouch_nii(img);
        i.img = flip(i.img,1); % flip (only if left)
        mkdir([hippDir '/tmp']); % just to ensure this exists
        save_untouch_nii(i,[hippDir '/tmp/flipping.nii.gz']);
        img = [hippDir '/tmp/flipping.nii.gz'];
        LR = 'L';
    else
        LR = 'R';
    end
    
    system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
        '-i ' img ' '...
        '-o ' outdir '/' imgList{f} '_hemi-' LR '.nii.gz '...
        '-r ' origimg ' '...
        '-t [' aff ',1]']); % reverse the affine
end

