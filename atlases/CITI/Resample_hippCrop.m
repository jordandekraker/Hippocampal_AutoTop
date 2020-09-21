
bash

flirt -in CIT168_T2w_head_700um_coronalOblique.nii.gz -ref CIT168_T2w_head_700um_coronalOblique.nii.gz -applyisoxfm 0.3 -out T2w_300umCoronalOblique.nii.gz
flirt -in Mask_hemi-L.nii.gz -ref Mask_hemi-L.nii.gz -interp nearestneighbour -applyisoxfm 0.3 -out Mask_hemi-L_300umCoronalOblique.nii.gz
flirt -in Mask_hemi-R.nii.gz -ref Mask_hemi-R.nii.gz -interp nearestneighbour -applyisoxfm 0.3 -out Mask_hemi-R_300umCoronalOblique.nii.gz


matlab -r 

i = load_untouch_nii('CIT168_T2w_head_700um_coronalOblique.nii.gz');
i.img(i.img==mode(i.img(:))) = 0;
save_untouch_nii(i,'CIT168_T2w_head_700um_coronalOblique.nii.gz');

i = load_untouch_nii('Mask_hemi-L_300umCoronalOblique.nii.gz');
[x,y,z] = ind2sub(size(i.img),find(i.img>0.5));
c = round([mean(x)-64 128 mean(y)-128 256 mean(z)-64 128]);
system(['fslroi Mask_hemi-L_300umCoronalOblique.nii.gz Mask_hemi-L_300umCoronalOblique.nii.gz ' num2str(c)]);
system(['fslroi T2w_300umCoronalOblique.nii.gz T2w_300umCoronalOblique_hemi-L.nii.gz ' num2str(c)]);

i = load_untouch_nii('Mask_hemi-R_300umCoronalOblique.nii.gz');
[x,y,z] = ind2sub(size(i.img),find(i.img>0.5));
c = round([mean(x)-64 128 mean(y)-128 256 mean(z)-64 128]);
system(['fslroi Mask_hemi-R_300umCoronalOblique.nii.gz Mask_hemi-R_300umCoronalOblique.nii.gz ' num2str(c)]);
system(['fslroi T2w_300umCoronalOblique.nii.gz T2w_300umCoronalOblique_hemi-R.nii.gz ' num2str(c)]);
