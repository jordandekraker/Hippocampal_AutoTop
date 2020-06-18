function postprocess_labelmap(lblname,outprefix)
% postprocess manual or automatically generated labelmap, and adds
% additional labels (DG granule cell layer and dummy label of SRLM extended
% over subiculum and vert. uncus). This is done via removal of 'island'
% labels and then a highly fluid labelmap-labelmap registration to UPenn
% atlas.

% testing:
% lblname = 'example/ManualGroundTruth/sub-073_hemi-R_lbl.nii.gz';
% imgname = 'example/ManualGroundTruth/sub-073_hemi-R_img.nii.gz';
% outprefix = 'example/test/sub-073_hemi-R_HippUnfold/';

minHippSize = 1000;
cropbuffer = 10; % in voxels
tmpdir = [outprefix '/tmp/'];
mkdir(tmpdir);

labelmap = load_untouch_nii(lblname);
sz = size(labelmap.img);

% don't re-run if this exists
if ~exist([outprefix '/labelmap-postProcess.nii.gz'],'file')

%% Island Removal
% ensures output labels are all connected (keeps only largest island), and
% ensures the result is above a minimum size (in voxels).

% conncom = bwconncomp(labelmap.img>0);
% if length(conncom.PixelIdxList)>1
%     sizes = cellfun(@numel,conncom.PixelIdxList);
%     [~,i] = sort(sizes,'descend');
%     conncom.PixelIdxList(i(1)) = [];
%     for i = 1:length(conncom.PixelIdxList)
%         labelmap.img(conncom.PixelIdxList{i}) = 0;
%     end
% end

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
system(['tools/ANTsTools/runAntsLabelMaps_AffOnly.sh '...
    tmpdir '/labelmap-midProcess.nii.gz '...
    'atlases/UPenn_ExVivo/Avg_lbl_JDedit.nii.gz '... % no DG yet
    tmpdir '/labelmap-midProcess_UPennAtlasReg-Aff']);
initAff = [tmpdir '/labelmap-midProcess_UPennAtlasReg-Aff/ants_0GenericAffine.mat'];

% first register only grey matter
system(['tools/ANTsTools/runAntsLabelMaps_SynOnly.sh '...
    tmpdir '/labelmap-midProcess.nii.gz '...
    'atlases/UPenn_ExVivo/Avg_lbl_JDedit.nii.gz '... % no DG yet
    initAff ' '... % supply affine from first registration
    tmpdir '/labelmap-midProcess_UPennAtlasReg-SynGM '...
    '-L "1 2" -W "3 1"']);

warpGM = [tmpdir '/labelmap-midProcess_UPennAtlasReg-SynGM/ants_1Warp.nii.gz'];

system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
    '-i atlases/UPenn_ExVivo/Avg_lbl_JDedit_withDG_withDummy.nii.gz '... % now apply to labelmap with DG
    '-o ' tmpdir '/labelmap-midProcess_UPennAtlasReg-SynGM.nii.gz '...
    '-r ' tmpdir '/labelmap-midProcess.nii.gz '...
    '-t ' warpGM ' '...
    '-t ' initAff]);

% now register primarily based on SRLM
system(['tools/ANTsTools/runAntsLabelMaps_SynOnly.sh '...
    tmpdir '/labelmap-midProcess.nii.gz '...
    'atlases/UPenn_ExVivo/Avg_lbl_JDedit.nii.gz '... % no DG yet
    initAff ' '... % supply affine from first registration
    tmpdir '/labelmap-midProcess_UPennAtlasReg-SynSRLM '...
    '-L "1 2" -W "1 3"']);

warpSRLM = [tmpdir '/labelmap-midProcess_UPennAtlasReg-SynSRLM/ants_1Warp.nii.gz'];

system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
    '-i atlases/UPenn_ExVivo/Avg_lbl_JDedit.nii.gz '...
    '-o ' tmpdir '/labelmap-midProcess_UPennAtlasReg-SynSRLM.nii.gz '...
    '-r ' tmpdir '/labelmap-midProcess.nii.gz '...
    '-t ' warpSRLM ' '...
    '-t ' initAff]);

%% ensure both registrations succeeded

lbl1 = load_untouch_nii([tmpdir '/labelmap-midProcess_UPennAtlasReg-SynGM.nii.gz']);
lbl2 = load_untouch_nii([tmpdir '/labelmap-midProcess_UPennAtlasReg-SynSRLM.nii.gz']);
bound = find(imdilate(midProcess==1,strel('sphere',10)));
GM = find(lbl1.img==1);
SRLM = find(lbl2.img==2);
check1 = setdiff(GM,bound);
check2 = setdiff(SRLM,bound);
if isempty(GM) || isempty(SRLM) || ~isempty(check1) || ~isempty(check2)
    error('Error: one or both registrations to UPenn atlas failed');
end

%% combine warps and use them to generate final labelmap and initialize Laplace solutions

% average previous warps using weighted averaging
warpBoth = [tmpdir 'UPennAtlasReg_GMandSRLM_ants1Warp.nii.gz'];
averaging_weights = zeros(size(midProcess));
averaging_weights(midProcess==2) = 1;
averaging_weights = smooth3(averaging_weights);

warpGM_img = load_untouch_nii(warpGM);
warpSRLM_img = load_untouch_nii(warpSRLM);
warpBoth_img = warpGM_img;
warpBoth_img.img = warpSRLM_img.img.*averaging_weights + ...
    warpGM_img.img.*(-averaging_weights +1);
save_untouch_nii(warpBoth_img,warpBoth);





% %% EXPERIMENTAL
% if refineWithImg
%     system(['antsApplyTransforms -d 3 --interpolation Linear '...
%         '-i atlases/UPenn_ExVivo/Avg_img.nii.gz '...
%         '-o ' tmpdir '/UPenn_warped_img.nii.gz '...
%         '-r ' tmpdir '/labelmap-postProcess_noCyst_noHeader.nii.gz '...
%         '-t ' warpBoth ' '...
%         '-t ' initAff]);
%     % mask out cysts and CSF; remove header
%     img = load_untouch_nii([outprefix '/img.nii.gz']);
%     se = strel('sphere',1);
%     WMint = min(img.img(labelmap.img==2));
%     GMint = mean(img.img(labelmap.img==1));
%     csf = img.img>mean(img.img(labelmap.img==7)) | labelmap.img==7;
%     csf = 1-smooth3(csf); 
%     
%     img.img = img.img.*csf;
%     save_nii(make_nii(img.img,img.hdr.dime.pixdim(2:4)),...
%         [tmpdir '/img_noCyst_noHeader.nii.gz']);    
%     
%     % now refine using this image
%     system(['tools/ANTsTools/runAntsImgs_SynOnly.sh '...
%         tmpdir '/img_noCyst_noHeader.nii.gz '...
%         tmpdir '/UPenn_warped_img.nii.gz '... 
%         initAff ' '... % supply affine from first registration
%         tmpdir '/labelmap-postProcess_UPennAtlasReg-SynRefine']);
%     warpRefine = [tmpdir '/labelmap-postProcess_UPennAtlasReg-SynRefine/ants_1Warp.nii.gz'];
%     
%     %% apply transforms...
%     system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
%         '-i atlases/UPenn_ExVivo/Avg_lbl_JDedit_withDG_withDummy.nii.gz '...
%         '-o ' tmpdir '/UPenn_warped_lbl_refined.nii.gz '...
%         '-r ' tmpdir '/labelmap-postProcess_noCyst_noHeader.nii.gz '...
%         '-t ' warpRefine ' '...
%         '-t ' warpBoth ' '...
%         '-t ' initAff]);
% else

    
    

%% apply transforms

% get header to use for all outputs
if exist([outprefix '/img.nii.gz'],'file')
    origheader = load_untouch_nii([outprefix '/img.nii.gz']);
    origheader.img = zeros(size(origheader.img));
else
    origheader = labelmap;
    origheader.img = zeros(size(origheader.img));
end

system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
    '-i atlases/UPenn_ExVivo/Avg_lbl_JDedit_withDG_withDummy.nii.gz '...
    '-o ' tmpdir '/UPenn_warped_lbl.nii.gz '...
    '-r ' tmpdir '/labelmap-midProcess.nii.gz '...
    '-t ' warpBoth ' '...
    '-t ' initAff]);

i = load_untouch_nii([tmpdir '/UPenn_warped_lbl.nii.gz']);
if labelmap.hdr.dime.pixdim(1) == -1 % flip back if unintended flip
    i.img = flip(i.img,1);
end
origheader.img(crop(1):crop(2),crop(3):crop(4),crop(5):crop(6)) = i.img; % un-crop
origheader.img(labelmap.img==7) = 7; % add cyst labels back in
save_nii(make_nii(double(midProcess),labelmap.hdr.dime.pixdim(2:4)),...
    [tmpdir '/labelmap-midProcess.nii.gz']);
save_untouch_nii(origheader,[outprefix '/labelmap-postProcess.nii.gz']);

system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
    '-i atlases/UPenn_ExVivo/coords-AP.nii.gz '...
    '-o ' tmpdir '/coords-AP.nii.gz '...
    '-r ' tmpdir '/labelmap-midProcess.nii.gz '...
    '-t ' warpBoth ' '...
    '-t ' initAff]);
i = load_untouch_nii([tmpdir '/coords-AP.nii.gz']);
if labelmap.hdr.dime.pixdim(1) == -1 % flip back if unintended flip
    i.img = flip(i.img,1);
end
origheader.img(crop(1):crop(2),crop(3):crop(4),crop(5):crop(6)) = i.img; % un-crop
save_untouch_nii(origheader,[tmpdir '/coords-AP.nii.gz']);

system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
    '-i atlases/UPenn_ExVivo/coords-PD.nii.gz '...
    '-o ' tmpdir '/coords-PD.nii.gz '...
    '-r ' tmpdir '/labelmap-midProcess.nii.gz '...
    '-t ' warpBoth ' '...
    '-t ' initAff]);
i = load_untouch_nii([tmpdir '/coords-PD.nii.gz']);
if labelmap.hdr.dime.pixdim(1) == -1 % flip back if unintended flip
    i.img = flip(i.img,1);
end
origheader.img(crop(1):crop(2),crop(3):crop(4),crop(5):crop(6)) = i.img; % un-crop
save_untouch_nii(origheader,[tmpdir '/coords-PD.nii.gz']);

system(['antsApplyTransforms -d 3 --interpolation NearestNeighbor '...
    '-i atlases/UPenn_ExVivo/coords-IO.nii.gz '...
    '-o ' tmpdir '/coords-IO.nii.gz '...
    '-r ' tmpdir '/labelmap-midProcess.nii.gz '...
    '-t ' warpBoth ' '...
    '-t ' initAff]);
i = load_untouch_nii([tmpdir '/coords-IO.nii.gz']);
if labelmap.hdr.dime.pixdim(1) == -1 % flip back if unintended flip
    i.img = flip(i.img,1);
end
origheader.img(crop(1):crop(2),crop(3):crop(4),crop(5):crop(6)) = i.img; % un-crop
save_untouch_nii(origheader,[tmpdir '/coords-IO.nii.gz']);

end
end