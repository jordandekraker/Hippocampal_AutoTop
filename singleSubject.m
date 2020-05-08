function singleSubject(inimg,outdir,inlbl,space)

addpath(genpath('tools'));

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
        AutoTops_TransformAndRollOut(inimgLR,outdirLR,inlblLR);
    end
    AutoTops_TransformAndRollOut(inimgLR,outdirLR);
    Resample_Native(outdirLR,outdir,{'subfields','coords-AP'});
end