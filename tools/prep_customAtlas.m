function prep_customAtlas(dir,res,sz)
% Four files must be present in the directory that the custom atlas will be
% build in: an original image (orig_*.nii.gz), which would typically be a
% study-specific template, a mask of the left and right hippocampus
% (Mask_hemi-L.nii.gz and Mask_hemi-R.nii.gz), and a trasformation to
% CoronalOblique (*CoronalOblique*, should be recognizable by ANTs). The
% transformation could be created manualy (eg. via ITK-SNAP or 3D Slicer)
% or via registration to another CoronalOblique image. Contact the author
% for help if needed.
% res: the target resolution in mm. default [0.3]
% sz: the target size in voxels, centered on the left and right
% hippocampi. default [128 256 128]

if ~exist('res','var')
    res = 0.3;
end
if ~exist('sz','var')
    sz = [128 256 128];
end

orig = ls([dir '/orig_*.nii.gz']); orig(end) = [];
transform = ls([dir '/*CoronalOblique*']); transform(end) = [];

% create highres reference
system(['flirt -in ' orig ' -ref ' orig ' -applyisoxfm ' num2str(res) ' -out ' dir '/highref.nii.gz']);
% apply transforms and upsample in same step
resample_imgs = {[dir '/Mask_hemi-L.nii.gz'] [dir '/Mask_hemi-R.nii.gz'] orig};
for r = 1:length(resample_imgs)
    out = [resample_imgs{r}(1:end-7) '_300umCoronalOblique.nii.gz'];
    system(['antsApplyTransforms -d 3 --interpolation Linear '...
        '-i ' resample_imgs{r} ' '...
        '-o ' out ' '...
        '-r ' dir '/highref.nii.gz '...
        '-t ' transform]);
end

% now crop around masks
halfsz = round(sz/2);

i = load_untouch_nii([dir '/Mask_hemi-L_300umCoronalOblique.nii.gz']);
[x,y,z] = ind2sub(size(i.img),find(i.img>0.5));
c = round([mean(x)-halfsz(1) sz(1)...
        mean(y)-halfsz(2) sz(2)...
        mean(z)-halfsz(3) sz(3)]);
system(['fslroi ' out ' ' dir '/img_300umCoronalOblique_hemi-L.nii.gz ' num2str(c)]);

i = load_untouch_nii([dir '/Mask_hemi-R_300umCoronalOblique.nii.gz']);
[x,y,z] = ind2sub(size(i.img),find(i.img>0.5));
c = round([mean(x)-64 128 mean(y)-128 256 mean(z)-64 128]);
system(['fslroi ' out ' ' dir '/img_300umCoronalOblique_hemi-R.nii.gz ' num2str(c)]);
