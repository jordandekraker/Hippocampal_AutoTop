addpath(genpath('tools')); 

% specify input image and output directory
origimg = 'example/sub-073_acq-TSE_rec-4avg_T2w.nii.gz';
outname = 'example/test_wholeBrain/sub-073/';
mkdir(outname);


Resample_CoronalOblique(origimg,outname); 
% Note: this should have made two files named hemi-L_img.nii.gz and
% hemi-R_img.nii.gz. Run both using a loop: 
for LR = 'LR'
    AutoTops_TransformAndRollOut([outname '/hemi-' LR '_img.nii.gz'],...
        [outname '/hemi-' LR '/']);
    
    % return subfield labelmap and anterior-posterior coordinates to native space
    Resample_Native([outname '/hemi-' LR '/'],outname,{'subfields','coords-AP'});
end
