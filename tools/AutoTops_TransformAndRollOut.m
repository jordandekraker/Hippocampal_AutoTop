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


%% Unfolding pipeline

if ~exist('manual_lbl','var') || isempty(manual_lbl)
    run_NiftyNet(inimg,outdir,modality); % automatically segment
    system(['cp ' manual_lbl ' ' outdir '/manual_lbl.nii.gz']);
    inlbl = [outdir '/niftynet_lbl.nii.gz'];
else
    inlbl = manual_lbl;
end

% post-process using label-label fluid registration to UPenn atlas
postprocess_labelmap(inlbl,outdir);

% apply/refine Laplacian coordinate framework
labelmap_LaplaceCoords(outdir);

% extract hippocampal midsurface and features
coords_SurfMap(outdir);

%generate warps, and template unfolded surfaces
create_warps(outdir,outdir); %args are in_dir, out_dir

% Note: these giftis are in the template space (ie are not specifically associated with this subject, 
% but just generated here for convenience)
create_template_unfold_gifti(outdir); 

%this extrapolates the (surf) unfold2native warp to nearest native coord, 
% to effectively collapse any vertices outside the hippocampus in the
% unfolded space to the nearest vertex.. 
extrapolate_warp_unfold2native(outdir,outdir);

%this performs ants registration from the unfolded coords-AP to a full grid
%coords-AP. This is done with smoothed inner and outer labels to ensure the
%midthickness as accurately mapped
system(sprintf('%s/tools/warps_gifti/mapUnfoldToFullGrid.sh %s %s', ... 
                getenv('AUTOTOP_DIR'), ...
                outdir, ...
                outdir));


% plot for Quality Assurance
%plot_manualQA(outdir);

% apply subfield boundaries
apply_subfieldBoundaries(outdir);

