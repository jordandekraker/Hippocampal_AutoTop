function AutoTops_TransformAndRollOut(inimg,outdir,modality,manual_lbl)
% Segments and unfolds a 3D hippocampal image that has already been resampled to cropped coronal oblique. 
% 
% Inputs:
% inimg: input single .nii.gz file. Must be in space-MNI152.
% outdir: output directory.
% modality: ['HCP1200-T2', 'HCP1200-T1', or 'HCP1200-b1000']. 
% manual_lbl (optional): specify manual segmentation (see misc/dseg.tsv). 
% make a local copy

%% ensure environment is set up

autotop_dir = getenv('AUTOTOP_DIR');
if isempty(autotop_dir)
    error('you must set the AUTOTOP_DIR environment variable before running');
end
if ~exist('modality','var')
    modality = 'HCP1200-T2';
end


%make sure outdir is suffixed with /  (as some filepaths assume it)
if outdir(end) ~= '/'
    outdir=[outdir '/'];
end

% make local copy of inimg (later steps depend on this)
mkdir(outdir);
system(['cp ' inimg ' ' outdir 'img.nii.gz']);
inimg = [outdir 'img.nii.gz'];



%% Unfolding pipeline

if ~exist('manual_lbl','var') || isempty(manual_lbl)
    run_NiftyNet(inimg,outdir,modality); % automatically segment
    inlbl = [outdir '/niftynet_lbl.nii.gz'];
else
    system(['cp ' manual_lbl ' ' outdir '/manual_lbl.nii.gz']);
    inlbl = manual_lbl;
end

% post-process using label-label fluid registration to UPenn atlas
postprocess_labelmap(inlbl,outdir);

% apply/refine Laplacian coordinate framework
labelmap_LaplaceCoords(outdir);

% extract hippocampal midsurface and features
coords_SurfMap(outdir);

%create warps and giftis
create_warps_giftis(outdir,outdir);

% plot for Quality Assurance
%plot_manualQA(outdir);

% apply subfield boundaries
apply_subfieldBoundaries(outdir);

