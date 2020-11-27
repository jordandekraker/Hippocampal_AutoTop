function singleSubject(inimg,outdir,modality,manual_lbl)
% Resamples input image to cropped coronal oblique (left and right
% separately), and then runs them through AutoTops_TransformAndRollOut. 
%
% Inputs:
% inimg: input single .nii.gz file. Must be in space-MNI152.
% outdir: output directory.
% modality: ['HCP1200-T2', 'HCP1200-T1', or 'HCP1200-b1000']. 
% manual_lbl (optional): specify manual segmentation (see misc/dseg.tsv). 
% 
% Example:
% singleSubject('example/HCP_100206/sub-100206_acq-procHCP_T2w.nii.gz','test/HCP_100206/', 'HCP1200-T2');
%% ensure environment is set up

autotop_dir = getenv('AUTOTOP_DIR');
if isempty(autotop_dir)
    error('you must set the AUTOTOP_DIR environment variable before running');
end
if ~exists('modality','var')
    modality = 'HCP1200-T2';
end
addpath(genpath([autotop_dir '/tools']));

%% Transform to 0.3mm Coronal Oblique (from MNI152 ONLY)

% hemi-L
mkdir([outdir '/hemi-L/']);
system(['antsApplyTransforms -d 3 --interpolation Linear '...
    '-i ' inimg ' '...
    '-o ' outdir '/hemi-L/img.nii.gz '...
    '-r ' autotop_dir '/atlases/MNI152/img_300umCoronalOblique_hemi-L.nii.gz '...
    '-t ' autotop_dir '/atlases/MNI152/CoronalOblique_rigid.txt']);
% flip left
i = load_untouch_nii([outdir '/hemi-L/img.nii.gz']);
i.img = flip(i.img,1); % flip (only if left)
save_untouch_nii(i,[outdir '/hemi-L/img.nii.gz']);

% hemi-R
mkdir([outdir '/hemi-R/']);
system(['antsApplyTransforms -d 3 --interpolation Linear '...
    '-i ' inimg ' '...
    '-o ' outdir '/hemi-R/img.nii.gz '...
    '-r ' autotop_dir '/atlases/MNI152/img_300umCoronalOblique_hemi-R.nii.gz '...
    '-t ' autotop_dir '/atlases/MNI152/CoronalOblique_rigid.txt']);

% apply to manual_lbl if it exists
if exist('manual_lbl','var')
    
    % hemi-L
    system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
        '-i ' manual_lbl ' '...
        '-o ' outdir '/hemi-L/manual_lbl.nii.gz '...
        '-r ' autotop_dir '/atlases/MNI152/img_300umCoronalOblique_hemi-L.nii.gz '...
        '-t ' autotop_dir '/atlases/MNI152/CoronalOblique_rigid.txt']);
    % flip left
    i = load_untouch_nii([outdir '/hemi-L/manual_lbl.nii.gz']);
    i.img = flip(i.img,1); % flip (only if left)
    save_untouch_nii(i,[outdir '/hemi-L/manual_lbl.nii.gz']);

    % hemi-R
    mkdir([outdir '/hemi-R/']);
    system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
        '-i ' manual_lbl ' '...
        '-o ' outdir '/hemi-R/manual_lbl.nii.gz '...
        '-r ' autotop_dir '/atlases/MNI152/img_300umCoronalOblique_hemi-R.nii.gz '...
        '-t ' autotop_dir '/atlases/MNI152/CoronalOblique_rigid.txt']);
end

%% now unfold!

for LR = 'LR'
    inimgLR = [outdir '/hemi-' LR '/img.nii.gz'];
    outdirLR = [outdir '/hemi-' LR '/'];
    if ~exist('manual_lbl','var')
        AutoTops_TransformAndRollOut(inimgLR,outdirLR,[],modality)
    else
        AutoTops_TransformAndRollOut(inimgLR,outdirLR,...
            [outdir '/hemi-R/manual_lbl.nii.gz'],modality)
    end
end
