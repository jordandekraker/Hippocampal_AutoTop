function singleSubject(inimg,outdir,space,CNNmodel,inlbl)

autotop_dir = getenv('AUTOTOP_DIR');
if isempty(autotop_dir)
    error('you must set the AUTOTOP_DIR environment variable before running');
end
try addpath(genpath([autotop_dir '/tools'])); endif isempty(autotop_dir)
    error('you must set the AUTOTOP_DIR environment variable before running');
end
try addpath(genpath([autotop_dir '/tools'])); end

mkdir(outdir);
outdir = [outdir '/']; % make sure this is a directory

if ~exist('CNNmodel','var')
    CNNmodel = 'highres3dnet_large_v0.4';
end
if ~exist('space','var')
    space = 'native';
end
if ~exist('inlbl','var')
    inlbl = [];
end

Resample_CoronalOblique(inimg,outdir,space,inlbl); % Temporarily removed inlbl for Kayla's data
for LR = 'LR'
    inimgLR = [outdir '/hemi-' LR '/img.nii.gz'];
    outdirLR = [outdir '/hemi-' LR '/'];
    if ~isempty(inlbl)
        inlblLR = [outdir '/hemi-' LR '/manual_lbl.nii.gz'];
        if exist(inlblLR,'file')
            AutoTops_TransformAndRollOut(inimgLR,outdirLR,inlblLR,CNNmodel);
        else
            warning([inlblLR ' not found, proceeding with Automated segmentation']);
        end
    end
    if exist(inimgLR,'file')
        AutoTops_TransformAndRollOut(inimgLR,outdirLR,[],CNNmodel);
    end
    Resample_Native(outdirLR,outdir);
end
