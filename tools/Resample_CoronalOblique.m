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
    aff1 = [getenv('AUTOTOP_DIR') '/misc/identity_affine.txt']; % dont rerun if already in one of these spaces
else
    %aff1 = [outdir '/0GenericAffine.mat'];
    aff1 = [outdir '/itk_affine.mat'];
    if ~exist(aff1,'file') && ~exist([outdir '/sub2atlas.mat'],'file')
        %system(['bash tools/ANTsTools/runAntsImgs_Aff.sh ' getenv('AUTOTOP_DIR') '/atlases/' atlas '/orig_T2w.nii.gz ' inimg ' ' outdir]);
        s1 = system(['flirt -ref ' getenv('AUTOTOP_DIR') '/atlases/' atlas '/orig_T2w.nii.gz -in ' inimg ' -omat ' outdir '/flirt_affine.mat']);
        if s1 ~= 0 
            error('FLIRT registration to atlas failed');
        end
        s2 = system(['c3d_affine_tool ' outdir '/flirt_affine.mat '...
            '-src  ' inimg ' '...
            '-ref  ' getenv('AUTOTOP_DIR') '/atlases/' atlas '/orig_T2w.nii.gz '...
            '-fsl2ras -oitk ' outdir 'itk_affine.mat']);
        if s2 ~= 0 
            error('c3d_affine_tool failed');
        end
    end
end
% aff1 = [getenv('AUTOTOP_DIR') '/misc/identity_affine.txt']; % dont rerun if already in one of these spaces
aff2 = [getenv('AUTOTOP_DIR') '/atlases/' atlas '/CoronalOblique_rigid.txt'];

%% keep a copy of each affine

i = strfind(aff1,'.');
suffix = aff1(i(end):end);
if exist([outdir '/sub2atlas' suffix])
    warning([outdir '/sub2atlas' suffix ' already exists, NOT overwriting']);
else
    system(['cp ' aff1 ' ' outdir '/sub2atlas' suffix]);
end
aff1 = [outdir '/sub2atlas' suffix];

i = strfind(aff2,'.');
suffix = aff2(i(end):end);
if exist([outdir '/atlas2coronalOblique' suffix])
    warning([outdir '/atlas2coronalOblique' suffix ' already exists, NOT overwriting']);
else
    system(['cp ' aff2 ' ' outdir '/atlas2coronalOblique' suffix]);
end
aff2 = [outdir '/atlas2coronalOblique' suffix];

% remove duplicate to avoid confusion
% try
%     system(['rm ' outdir '/0GenericAffine.mat']);
% end

%% create combined transformation - use txt file for easier inspection..
combined = [outdir '/sub2coronalOblique.txt']

system(['antsApplyTransforms -d 3 '...
        '-i ' inimg ' '...
        '-o Linear[' combined '] '...
        '-r ' getenv('AUTOTOP_DIR') '/atlases/' atlas '/img_300umCoronalOblique_hemi-L.nii.gz '... #the transform is the same regardless of whether Lcrop and Rcrop
        '-t ' aff2 ' '...
        '-t ' aff1]);



%% apply to imgs
mkdir([outdir '/hemi-L/']);
out = [outdir '/hemi-L/img.nii.gz'];
% if ~exist(out)
    system(['antsApplyTransforms -d 3 --interpolation Linear '...
        '-i ' inimg ' '...
        '-o ' out ' '...
        '-r ' getenv('AUTOTOP_DIR') '/atlases/' atlas '/img_300umCoronalOblique_hemi-L.nii.gz '...
        '-t ' combined]);
    [~,z] = system(['fslstats ' out ' -s']);
    if str2num(z)==0
        warning('Hemi-L not found in cropped image');
        try
        system(['rm ' out]); % remove if failed
        end
    else
        i = load_untouch_nii(out);
        i.img = flip(i.img,1); % flip (only if left)
        save_untouch_nii(i,out);
    end
% end

mkdir([outdir '/hemi-Lnoflip/']);
out = [outdir '/hemi-Lnoflip/img.nii.gz'];
% if ~exist(out)
    system(['antsApplyTransforms -d 3 --interpolation Linear '...
        '-i ' inimg ' '...
        '-o ' out ' '...
        '-r ' getenv('AUTOTOP_DIR') '/atlases/' atlas '/img_300umCoronalOblique_hemi-L.nii.gz '...
        '-t ' combined]);
    [~,z] = system(['fslstats ' out ' -s']);
    if str2num(z)==0
        warning('Hemi-Lnoflip not found in cropped image');
        try
        system(['rm ' out]); % remove if failed
        end
    end
% end


mkdir([outdir '/hemi-R/']);
out = [outdir '/hemi-R/img.nii.gz'];
% if ~exist(out)
    system(['antsApplyTransforms -d 3 --interpolation Linear '...
        '-i ' inimg ' '...
        '-o ' out ' '...
        '-r ' getenv('AUTOTOP_DIR') '/atlases/' atlas '/img_300umCoronalOblique_hemi-R.nii.gz '...
        '-t ' combined]);
    [~,z] = system(['fslstats ' out ' -s']);
    if str2num(z)==0
        warning('Hemi-R not found in cropped image');
        try
        system(['rm ' out]); % remove if failed
        end
    end
% end

%% (optional) apply to additional images (usually masks)

if ~exist('addimgs','var') || isempty(addimgs)
return
end

if ~iscell(addimgs)
    addimgs = {addimgs};
end
    for s = 1:length(addimgs)
        
        inlbl = addimgs{s};
%         reslice_nii(inimg,[outdir '_lbl.nii.gz']); % handles headers with rotations not seen by ants
%         inlbl = [outdir '_lbl.nii.gz'];
%         system(['fslreorient2std ' inlbl ' ' inlbl]);
        
        out = [outdir '/hemi-L/lbl.nii.gz'];
%         if ~exist(out)
            system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
                '-i ' inlbl ' '...
                '-o ' out ' '...
                '-r ' getenv('AUTOTOP_DIR') '/atlases/' atlas '/img_300umCoronalOblique_hemi-L.nii.gz '...
                '-t ' combined]);
            [~,z] = system(['fslstats ' out ' -s']);
            if str2num(z)==0
                warning('Hemi-L not found in cropped image');
                try
                system(['rm ' out]); % remove if failed
                end
            else
                i = load_untouch_nii(out);
                i.img = flip(i.img,1); % flip (only if left)
                save_untouch_nii(i,out);
            end
%         end

        out = [outdir '/hemi-Lnoflip/lbl.nii.gz'];
%         if ~exist(out)
            system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
                '-i ' inlbl ' '...
                '-o ' out ' '...
                '-r ' getenv('AUTOTOP_DIR') '/atlases/' atlas '/img_300umCoronalOblique_hemi-L.nii.gz '...
                '-t ' combined]);
            [~,z] = system(['fslstats ' out ' -s']);
            if str2num(z)==0
                warning('Hemi-Lnoflip not found in cropped image');
                try
                system(['rm ' out]);
                end
            end
%         end

        out = [outdir '/hemi-R/lbl.nii.gz'];
%         if ~exist(out)
            system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
                '-i ' inlbl ' '...
                '-o ' out ' '...
                '-r ' getenv('AUTOTOP_DIR') '/atlases/' atlas '/img_300umCoronalOblique_hemi-R.nii.gz '...
                '-t ' combined]);
            [~,z] = system(['fslstats ' out ' -s']);
            if str2num(z)==0
                warning('Hemi-R not found in cropped image');
                try
                system(['rm ' out]);
                end
            end
%         end
    end

