addpath(genpath('tools'));

% specify input and output directories to search
indir = ['../corrected_segmentations/'];
outdir = [indir '/unfolding/'];
mkdir(outdir);


% specify string to search for in subject name
subs = ls([indir '/*_lbl*.nii.gz']);
subs = strsplit(subs)';
subs(end) = [];

% loop through filenames
for s = 1:length(subs)
    lbl = subs{s};
    
    % find a unique file ID for each subject name
    i = strfind(lbl,'/');
    ii = strfind(lbl,'_lbl');
    fID = lbl(i(end)+1 : ii(end)-1);
    outdir_sub = [outdir fID '/'];
    
    % get the name of the corresponding img
    img = [subs{s}(1:ii(end)-1) '_img.nii.gz'];
	sprintf('Applying unfolding to %s',img);
    if ~exist(outdir_sub,'dir')
    try % keep going in case this fails
        mkdir(outdir_sub);
        AutoTops_TransformAndRollOut(img,outdir_sub,lbl);
    catch
        sprintf('Failed on subject %s',fID);
    end
    end
end
