function Resample_CoronalOblique(inimg,outdir,space,addimgs)

% Resamples the input image to 0.3mm cropped CoronalOblique by registering
% it to agile12 atlas.
% INPUTS:
% inimg: input image (T2-like)
% outname: prefix for output
% space (optional): default 'native' will register to CITI or else specify a
% custom atlas directory. If 'MNI152', a fixed registration will be used to
% crop and make inputs coronal oblique.
% addimgs (optional): (cell array) apply the same transform to additional images
% (NearestNeighbour interpolation by default - for labelmaps)
% DOESN'T OVERWRITE EXISTING TRANSFORMS OR OUTPUTS

% headers containing affine rotations are not recognized by ants, so apply
% reslicing first
% reslice_nii(inimg,[outname '.nii.gz'],[],0); 
% inimg = [outname '.nii.gz'];
% system(['fslreorient2std ' inimg ' ' inimg]);

mkdir(outdir);
outdir = [outdir '/']; % make sure this is a directory
system(['cp ' inimg ' ' outdir '/original.nii.gz']);

if ~exist('space','var') || strcmp(space,'native') || isempty(space)
    space = 'native';
    atlas = 'CITI';
else
    atlas = space;
end
% run affine registration

if strcmp(space,'MNI152') || strcmp(space,'agile12') 
    aff1 = 'misc/identity_affine.txt'; % dont rerun if already in one of these spaces
else
    aff1 = [outdir '/0GenericAffine.mat'];
    if ~exist(aff1,'file') && ~exist([outdir '/sub2atlas.mat'],'file')
        system(['bash tools/ANTsTools/runAntsImgs_Aff.sh atlases/' atlas '/orig_T2w.nii.gz ' inimg ' ' outdir]);
    end
end
aff2 = ['atlases/' atlas '/CoronalOblique_rigid.txt'];

%% keep a copy of each affine

i = strfind(aff1,'.');
suffix = aff1(i:end);
system(['cp ' aff1 ' ' outdir '/sub2atlas' suffix]);
aff1 = [outdir '/sub2atlas' suffix];

i = strfind(aff2,'.');
suffix = aff2(i:end);
system(['cp ' aff2 ' ' outdir '/atlas2coronalOblique' suffix]);
aff2 = [outdir '/atlas2coronalOblique' suffix];

% remove duplicate to avoid confusion
try
    system(['rm ' outdir '/0GenericAffine.mat']); 
end

%% apply to imgs
out = [outdir '/hemi-L_img.nii.gz'];
if ~exist(out)
    system(['antsApplyTransforms -d 3 --interpolation Linear '...
        '-i ' inimg ' '...
        '-o ' out ' '...
        '-r atlases/' atlas '/img_300umCoronalOblique_hemi-L.nii.gz '...
        '-t ' aff1 ' '...
        '-t ' aff2]);
    [~,z] = system(['fslstats ' out ' -s']);
    if str2num(z)==0
        system(['rm ' out]); % remove if failed
    else
        i = load_untouch_nii(out);
        i.img = flip(i.img,1); % flip (only if left)
        save_untouch_nii(i,out);
    end
end
out = [outdir '/hemi-R_img.nii.gz'];
if ~exist(out)
    system(['antsApplyTransforms -d 3 --interpolation Linear '...
        '-i ' inimg ' '...
        '-o ' out ' '...
        '-r atlases/' atlas '/img_300umCoronalOblique_hemi-R.nii.gz '...
        '-t ' aff1 ' '...
        '-t ' aff2]);
    [~,z] = system(['fslstats ' out ' -s']);
    if str2num(z)==0
        system(['rm ' out]); % remove if failed
    end
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
                '-r atlases/' atlas '/img_300umCoronalOblique_hemi-L.nii.gz '...
                '-t ' aff1 ' '...
                '-t ' aff2]);
            [~,z] = system(['fslstats ' out ' -s']);
            if str2num(z)==0
                system(['rm ' out]); % remove if failed
            else
                i = load_untouch_nii(out);
                i.img = flip(i.img,1); % flip (only if left)
                save_untouch_nii(i,out);
            end
        end
        out = [outdir '/hemi-R_lbl.nii.gz'];
        if ~exist(out)
            system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
                '-i ' inlbl ' '...
                '-o ' out ' '...
                '-r atlases/' atlas '/img_300umCoronalOblique_hemi-R.nii.gz '...
                '-t ' aff1 ' '...
                '-t ' aff2]);
            [~,z] = system(['fslstats ' out ' -s']);
            if str2num(z)==0
                system(['rm ' out]);
            end
        end
    end
end