function singleSubject(inimg,outdir,inlbl,space)

addpath(genpath('tools'));
mkdir(outdir);
outdir = [outdir '/']; % make sure this is a directory

if ~exist('inlbl','var')
    inlbl = [];
end
if ~exist('space','var')
    space = 'native';
end

Resample_CoronalOblique(inimg,outdir,space,inlbl);
for LR = 'LR'
    inimgLR = [outdir '/hemi-' LR '_img.nii.gz'];
    outdirLR = [outdir '/hemi-' LR '/'];
    if ~isempty(inlbl)
        inlblLR = [outdir '/hemi-' LR '_lbl.nii.gz'];
        if exist(inlblLR,'file')
            AutoTops_TransformAndRollOut(inimgLR,outdirLR,inlblLR);
        else
            warning([inlblLR ' not found, proceeding with Automated segmentation']);
            AutoTops_TransformAndRollOut(inimgLR,outdirLR);
        end
    end
    Resample_Native(outdirLR,outdir);
end
