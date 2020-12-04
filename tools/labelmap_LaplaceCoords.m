function out = labelmap_LaplaceCoords(outprefix)
% Solves laplace equation over the A-P, P-D and I-O dimensions of the
% hippocmapus (analogous to 'register_UnfoldingAtlas' but form the
% bottom-up rather than from an atlas). IF 'initCoords' exists, this will
% smooth that solution instead of solving de novo.

inlbl = [outprefix '/labelmap-postProcess.nii.gz'];
iters = 4; %TODO: test this for robustness with imperfect segmenations. 
% Too few and the result is not smooth, too many and the UPenn prior is 
% not strong enough (more suscpetible to topological holes).


if ~exist([outprefix 'unfold.mat'],'file')

% check if initialization for Laplace coords exists & load them
tmpdir = [outprefix '/tmp/'];
try
    initAP = load_untouch_nii([tmpdir '/coords-AP.nii.gz']);
    initPD = load_untouch_nii([tmpdir '/coords-PD.nii.gz']);
    initIO = load_untouch_nii([tmpdir '/coords-IO.nii.gz']);
    fineTune = true;
catch
    warning('No Laplace coords initialization found, solving de novo');
    fineTune = true;
end

%% get header info

origheader = load_untouch_nii(inlbl);
labelmap = double(origheader.img);
origheader.img = [];
origheader.hdr.dime.datatype = 16; % ensure this is not rounded during later saving

idxgm = find(labelmap==1);
sz = size(labelmap);

%% AP gradient:

%Define ROIs
sourceAP = find(labelmap==5);
sinkAP = find(labelmap==6);

% preprocess init
if exist('initAP','var')
    init = initAP.img;
    init(sourceAP) = 0;
    init(sinkAP) = 1;
    init(labelmap==1 & init==0) = nan;
    init = inpaintn(init,10);
    init = init(idxgm);
    init(init<0) = 0;
    init(init>1) = 1;
else
    init = [];
end

Laplace_AP = laplace_solver(idxgm,sourceAP,sinkAP,iters,init,sz);

%% PD gradient

% Define ROIs for Laplacian
sourcePD = find(labelmap==3);
sinkPD = find(labelmap==8);
if isempty(sinkPD)
    %have to make these dummy labels ourselves
    automatic_DGgcl_approximation; %note: has to be run after Laplace_AP
    sinkPD=find(sink_main | sink_unc); %DGgcl
end

% preprocess init
if exist('initPD','var')
    init = initPD.img;
    init(sourcePD) = 0;
    init(sinkPD) = 1;
    init(labelmap==1 & init==0) = nan;
    init = inpaintn(init,10);
    init = init(idxgm);
    init(init<0) = 0;
    init(init>1) = 1;
else
    init = [];
end

Laplace_PD = laplace_solver(idxgm,sourcePD,sinkPD,iters,init,sz);

%% Laminar gradient

% Define ROIs for Laplacian
% extend_SRLM; % etends SRLM label medially over subiculum. note: dummy extended SRLM label number is 44
sourceIO = find(labelmap==2 | labelmap==4 | labelmap==7); % | labelmap==44);
sinkIO = find(labelmap==0);

% preprocess init
if exist('initIO','var')
    init = initIO.img;
    init(sourceIO) = 0;
    init(sinkIO) = 1;
    init(labelmap==1 & init==0) = nan;
    init = inpaintn(init,10);
    init = init(idxgm);
    init(init<0) = 0;
    init(init>1) = 1;
else
    init = [];
end

Laplace_IO = laplace_solver(idxgm,sourceIO,sinkIO,iters,init,sz);

%% fine-tune solutions

% laplace_orthogonalize; %this seems to work poorly on low-res data...

% solve again, using more iters and with orthogonalized boundary conditions
if fineTune
    Laplace_AP = laplace_solver(idxgm,sourceAP,sinkAP,2000,Laplace_AP,sz);
    Laplace_PD = laplace_solver(idxgm,sourcePD,sinkPD,1000,Laplace_PD,sz);
    Laplace_IO = laplace_solver(idxgm,sourceIO,sinkIO,100,Laplace_IO,sz);
end

%% clean up and save coords

rm = [];
rm = find(Laplace_AP==0 | Laplace_PD==0 | Laplace_IO==0 | Laplace_AP>1 | Laplace_PD>1 | Laplace_IO>1 | isnan(Laplace_AP) | isnan(Laplace_PD) |isnan(Laplace_IO));
if ~isempty(rm)
    warning(sprintf('Removing %d voxels from grey matter due to possibly incorrect Laplace coordinates',length(rm)));
end
Laplace_AP(rm)=[]; Laplace_PD(rm)=[]; Laplace_IO(rm)=[]; idxgm(rm)=[];

out = zeros(sz);
out(idxgm) = Laplace_AP;
origheader.img = out;
save_untouch_nii(origheader,[outprefix 'coords-AP.nii.gz']);

out = zeros(sz);
out(idxgm) = Laplace_PD;
origheader.img = out;
save_untouch_nii(origheader,[outprefix 'coords-PD.nii.gz']);

out = zeros(sz);
out(idxgm) = Laplace_IO;
origheader.img = out;
save_untouch_nii(origheader,[outprefix 'coords-IO.nii.gz']);

clearvars -except outprefix origheader labelmap sz idxgm Laplace_AP Laplace_PD... 
    Laplace_IO sourceAP sinkAP sourcePD sinkPD sourceIO sinkIO
save([outprefix 'unfold.mat']);
end
