function Resample_CoronalOblique(inimg,outdir,addimgs)

% Resamples the input image to 0.3mm cropped CoronalOblique by registering
% it to CITI atlas.
% INPUTS:
% inimg: input image (T2-like)
% outname: prefix for output
% addimgs (optional): (cell array) apply the same transform to additional images
% (NearestNeighbour interpolation by default - for labelmaps)
% DOESN'T OVERWRITE EXISTING TRANSFORMS OR OUTPUTS

% headers containing affine rotations are not recognized by ants, so apply
% reslicing first
% reslice_nii(inimg,[outname '.nii.gz'],[],0); 
% inimg = [outname '.nii.gz'];
% system(['fslreorient2std ' inimg ' ' inimg]);

mkdir(outdir);
system(['cp ' inimg ' ' outdir '/original.nii.gz']);

% run affine registration
aff = [outdir '/0GenericAffine.mat'];
if ~exist(aff)
    system(['bash tools/ANTsTools/runAntsImgs_Aff.sh '...
        'atlases/CITI/CIT168_T2w_head_700um_coronalOblique.nii.gz '...
        inimg ' ' outdir]);
end

% apply to imgs
out = [outdir '/hemi-L_img.nii.gz'];
if ~exist(out)
    system(['antsApplyTransforms -d 3 --interpolation Linear '...
        '-i ' inimg ' '...
        '-o ' out ' '...
        '-r atlases/CITI/T2w_300umCoronalOblique_hemi-L.nii.gz '...
        '-t ' aff]);

    i = load_untouch_nii(out);
    i.img = flip(i.img,1); % flip (only if left)
    save_untouch_nii(i,out);
end
out = [outdir '/hemi-R_img.nii.gz'];
if ~exist(out)
    system(['antsApplyTransforms -d 3 --interpolation Linear '...
        '-i ' inimg ' '...
        '-o ' out ' '...
        '-r atlases/CITI/T2w_300umCoronalOblique_hemi-R.nii.gz '...
        '-t ' aff]);
end

%% (optional) apply to additional images (usually masks)

if exist('addimgs','var')
    for s = 1:length(addimgs)
        
        inlbl = addimgs{s};
%         reslice_nii(inimg,[outdir '_lbl.nii.gz']); % handles headers with rotations not seen by ants
%         inlbl = [outdir '_lbl.nii.gz'];
%         system(['fslreorient2std ' inlbl ' ' inlbl]);
        
        out = [outdir '/hemi-L_lbl.nii.gz'];
        if ~exist(out)
            system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
                '-i ' inlbl ' '...
                '-o ' out ' '...
                '-r atlases/CITI/T2w_300umCoronalOblique_hemi-L.nii.gz '...
                '-t ' aff]);
            i = load_untouch_nii(out);
            i.img = flip(i.img,1); % flip (only if left)
            save_untouch_nii(i,out);
        end
        out = [outdir '/hemi-R_lbl.nii.gz'];
        if ~exist(out)
            system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
                '-i ' inlbl ' '...
                '-o ' out ' '...
                '-r atlases/CITI/T2w_300umCoronalOblique_hemi-R.nii.gz '...
                '-t ' aff]);
        end
    end
end
