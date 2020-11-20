% To be run from the Hippocampal_AutoTop directory

setenv('AUTOTOP_DIR',pwd);
singleSubject('example/HCP_100206/sub-100206_acq-procHCP_T2w.nii.gz',...
    'example/test');
