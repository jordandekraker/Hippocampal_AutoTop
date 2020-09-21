i = load_untouch_nii('HarvardOxford-combined-maxprob-thr50-1mm_CoronalOblique.nii.gz');
l = single(i.img==7);
r = single(i.img==15);
i.img = l;
save_untouch_nii(i,'Mask_hemi-L.nii.gz');
i.img = r;
save_untouch_nii(i,'Mask_hemi-R.nii.gz');

bash

flirt -in t1_CoronalOblique.nii.gz -ref t1_CoronalOblique.nii.gz -applyisoxfm 0.3 -out t1_300umCoronalOblique.nii.gz
flirt -in Mask_hemi-L.nii.gz -ref Mask_hemi-L.nii.gz -interp nearestneighbour -applyisoxfm 0.3 -out Mask_hemi-L_300umCoronalOblique.nii.gz
flirt -in Mask_hemi-R.nii.gz -ref Mask_hemi-R.nii.gz -interp nearestneighbour -applyisoxfm 0.3 -out Mask_hemi-R_300umCoronalOblique.nii.gz


matlab -r 

i = load_untouch_nii('Mask_hemi-L_300umCoronalOblique.nii.gz');
[x,y,z] = ind2sub(size(i.img),find(i.img>0.5));
c = round([mean(x)-64 128 mean(y)-128 256 mean(z)-64 128]);
system(['fslroi Mask_hemi-L_300umCoronalOblique.nii.gz Mask_hemi-L_300umCoronalOblique.nii.gz ' num2str(c)]);
system(['fslroi t1_300umCoronalOblique.nii.gz t1_300umCoronalOblique_hemi-L.nii.gz ' num2str(c)]);

i = load_untouch_nii('Mask_hemi-R_300umCoronalOblique.nii.gz');
[x,y,z] = ind2sub(size(i.img),find(i.img>0.5));
c = round([mean(x)-64 128 mean(y)-128 256 mean(z)-64 128]);
system(['fslroi Mask_hemi-R_300umCoronalOblique.nii.gz Mask_hemi-R_300umCoronalOblique.nii.gz ' num2str(c)]);
system(['fslroi t1_300umCoronalOblique.nii.gz t1_300umCoronalOblique_hemi-R.nii.gz ' num2str(c)]);
