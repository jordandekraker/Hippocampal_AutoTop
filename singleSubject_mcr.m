function singleSubject(inimg,outdir,inlbl,space)

%remove addpath (cannot have this for mcr - compiler takes care of it by addpath before compiling)
%addpath(genpath('tools'));

%TODO: insert more verbose usage here.
if isempty(inimg) || isempty(outdir)
   disp('Required arguments: INPUT_NIFTI OUTPUT_DIRECTORY not provided');
   quit(1);
end

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
