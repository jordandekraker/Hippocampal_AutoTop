function postprocess_labelmap(lblname,outprefix)
% postprocess manual or automatically generated labelmap via template shape
% injection. This entails highly fluid, multicontrast, label-label
% registration with a 0.2mm isotropic averaged reference atlases including
% all required labels. 


minHippSize = 1000;
cropbuffer = 10; % in voxels
tmpdir = [outprefix '/tmp/'];
mkdir(tmpdir);
atlasref = [getenv('AUTOTOP_DIR') '/atlases/UPenn_ExVivo/Avg_lbl_JDedit_withDG_withDummy.nii.gz'];

labelmap = load_untouch_nii(lblname);
sz = size(labelmap.img);

% don't re-run if this exists
if ~exist([outprefix '/labelmap-postProcess.nii.gz'],'file')

sizeGM = length(find(labelmap.img==1)) * labelmap.hdr.dime.pixdim(2);
if sizeGM<minHippSize
    error('NiftyNet labels too small, stopping before label-label registration');
end

%% Remove cyst labels, header, and crop
% Atlas has no cysts, so we must match that. Removing header and cropping
% help with affine registration in cases where world coordinates are off
% (eg. exvivo samples) (also makes registration faster).

% make cyst part of dark band
midProcess = labelmap.img;
midProcess(midProcess==7) = 2;

[x,y,z] = ind2sub(size(midProcess),find(midProcess==1));
crop = [min(x)-cropbuffer, max(x)+cropbuffer;...
        min(y)-cropbuffer, max(y)+cropbuffer;...
        min(z)-cropbuffer, max(z)+cropbuffer]';
% ensure we don't exceed the image
crop(crop<1)=1;
if crop(2,1)>sz(1); crop(2,1) = sz(1); end
if crop(2,2)>sz(2); crop(2,2) = sz(2); end
if crop(2,3)>sz(3); crop(2,3) = sz(3); end

midProcess = midProcess(crop(1):crop(2),crop(3):crop(4),crop(5):crop(6));

% remove headers (since atlas is headless)
if labelmap.hdr.dime.pixdim(1) == -1 % prevent unintended file flips
    midProcess = flip(midProcess,1);
end
save_nii(make_nii(double(midProcess),labelmap.hdr.dime.pixdim(2:4)),...
    [tmpdir '/labelmap-midProcess.nii.gz']);

%% label-label fluid-like registration to ex-vivo atlas labelmap

% start with affine registration, otherwise this often fails
system(['flirt -ref ' tmpdir '/labelmap-midProcess.nii.gz '...
    '-in ' atlasref ' '...
    ' -omat ' tmpdir '/labelmap-midProcess_UPennAtlasReg-Aff-itk.mat']);
system(['c3d_affine_tool ' tmpdir '/labelmap-midProcess_UPennAtlasReg-Aff-itk.mat '...
    '-src  ' atlasref ' '...
    '-ref  ' tmpdir '/labelmap-midProcess.nii.gz '...
    '-fsl2ras -oitk ' tmpdir '/labelmap-midProcess_UPennAtlasReg-Aff.mat']);
initAff = [tmpdir '/labelmap-midProcess_UPennAtlasReg-Aff.mat'];

% now deformable registration
system([getenv('AUTOTOP_DIR') '/tools/ANTsTools/runAntsLabelMaps_SynOnly.sh '...
    tmpdir '/labelmap-midProcess.nii.gz '...
    atlasref ' '... % no DG yet
    initAff ' '... % supply affine from first registration
    tmpdir '/labelmap-midProcess_UPennAtlasReg-Syn '...
    '-L "1 2 3 4 5 6 8" '... % label 7 is cysts
    '-W "1 1 1 1 1 1 1"']); 

warpSyN = [tmpdir '/labelmap-midProcess_UPennAtlasReg-Syn/ants_1Warp.nii.gz'];

% % ensure registrations succeeded
% lbl1 = load_untouch_nii([tmpdir '/labelmap-midProcess_UPennAtlasReg-Syn.nii.gz']);
% bound = find(imdilate(midProcess==1,strel('sphere',10)));
% GM = find(lbl1.img==1);
% check1 = setdiff(GM,bound);
% if isempty(GM)
%     error('Error: registration to UPenn atlas failed');
% end

% apply transforms
system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
    '-i ' getenv('AUTOTOP_DIR') '/atlases/UPenn_ExVivo/Avg_lbl_JDedit_withDG_withDummy.nii.gz '...
    '-o ' tmpdir '/UPenn_warped_lbl.nii.gz '...
    '-r ' tmpdir '/labelmap-midProcess.nii.gz '...
    '-t ' warpSyN ' '...
    '-t ' initAff]);

% get header to use for all outputs
origheader = labelmap;
origheader.img = zeros(size(origheader.img));
i = load_untouch_nii([tmpdir '/UPenn_warped_lbl.nii.gz']);
if labelmap.hdr.dime.pixdim(1) == -1 % flip back if unintended flip
    i.img = flip(i.img,1);
end
% un-crop
origheader.img(crop(1):crop(2),crop(3):crop(4),crop(5):crop(6)) = i.img;
% add cyst labels back in
origheader.img(labelmap.img==7) = 7; 
save_untouch_nii(origheader,[outprefix '/labelmap-postProcess.nii.gz']);
end