function plot_foldunfold_nii(imgName,hippSpaceDir)

% resamples an image to CoronalOblique and then plots its intensities on a
% folded and unfolded midsurface. If the image is 4D, then it splits the
% input first.

%% load data

load([hippSpaceDir '/surf.mat']);
i = strfind(imgName,'/');
ii = strfind(imgName,'.nii.gz');
if i>0
    resamp = [hippSpaceDir '/tmp/resampled/' imgName(i(end)+1:ii-1)];
else
    resamp = [hippSpaceDir '/tmp/resampled/' imgName(1:ii-1)];
end
mkdir([hippSpaceDir '/tmp/resampled']);
system(['fslsplit ' imgName ' ' resamp '_split_ -t']);

vols = ls([resamp '_split_*.nii.gz']);
vols = strsplit(vols)';
vols(end) = [];

% loop through all volumes
for v = 1:length(vols)
system(['antsApplyTransforms -d 3 --interpolation Linear '...
    '-i ' vols{v} ' '...
    '-o ' resamp '_' num2str(v,'%04d') '.nii.gz '...
    '-r ' hippSpaceDir '/img.nii.gz '...
    '-t ' hippSpaceDir '/../sub2coronalOblique.txt']);
img = load_untouch_nii([resamp '_' num2str(v,'%04d') '.nii.gz']);

if contains(hippSpaceDir,'hemi-L')
    img.img = flip(img.img,1); % flip (only if left)
end

%% plot
FV.faces = F;
FV.vertices = reshape(Vmid,[APres*PDres,3]);
v = round(FV.vertices);
for p = 1:APres*PDres
    flatmap(p) = img.img(v(p,1),v(p,2),v(p,3));
end
flatmap = reshape(flatmap,[APres,PDres]);

plot_foldunfold(flatmap,FV)

end