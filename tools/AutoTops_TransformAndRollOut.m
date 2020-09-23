function AutoTops_TransformAndRollOut(inimg,outdir,inlbl,CNNmodel)
% 
% Segments and unfolds a 3D hippocampal image. Should always be run from
% Hippocampal_AutoTop directory, and input image should be a cropped
% hippocampal block (see Resample_CoronalOblique and Resample_Native).
% inlbl (optional) can be used to specify a manually segmented hippocampus
% Please manually inspect the output html report!
% 
% simple example:
% addpath(genpath('tools'));
% inimg = 'example/ManualGroundTruth/sub-073_hemi-R_img.nii.gz';
% outdir = 'example/test';
% inlbl = 'example/ManualGroundTruth/sub-073_hemi-R_lbl.nii.gz'; %(optional)

% make a local copy
outdir = [outdir '/']; % ensure this is always considered a directory
mkdir(outdir);
system(['cp ' inimg ' ' outdir '/img.nii.gz']);
inimg = ls([outdir '/img.nii.gz']); inimg(end) = [];

%%
% check if labelmap exists and if not, apply highres3dnet (via NiftyNet)
if ~exist('CNNmodel','var')
    CNNmodel = 'highres3dnet_large_v0.4';
end
if ~exist('inlbl','var')
    inlbl = [];
end

if ~isempty(inlbl)
    system(['cp ' inlbl ' ' outdir '/manual_lbl.nii.gz']);
    inlbl = [outdir '/manual_lbl.nii.gz'];
else
    run_NiftyNet(inimg,outdir,CNNmodel); % automatically segment
    inlbl = [outdir '/niftynet_lbl.nii.gz'];
end

% post-process using label-label fluid registration to UPenn atlas
postprocess_labelmap(inlbl,outdir);

% apply/refine Laplacian coordinate framework
labelmap_LaplaceCoords(outdir)

% extract hippocampal midsurface and features
coords_SurfMap(outdir);

% plot for Quality Assurance
%plot_manualQA(outdir);

% apply subfield boundaries
apply_subfieldBoundaries(outdir);

