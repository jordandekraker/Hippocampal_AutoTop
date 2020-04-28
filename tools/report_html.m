%% Quality Assurance metrics and images
% Please inspect these prior to interpreting any results! Errors in
% manually or automatically generated labelmaps can lead to incorrect
% unfolding. Use this tool to ensure measures are correct.

try
    sampleprefix = out_filename; %sometimes used this as variable name, catch it just in case
end
load([sampleprefix 'unfold.mat']);%, '-regexp', '^(?!sampleprefix)\w');
load([sampleprefix 'surf.mat'], '-regexp', '^(?!sampleprefix)\w');
T2w = ls([sampleprefix 'img.nii.gz']);
T2w(end) = [];
T2w = load_untouch_nii(T2w);
T2w = T2w.img;

%% Midsurf mesh
% This is the quickest way to ensure unfolding is correct. If this mesh is
% smooth and has relatively consistent face sizes then the other results are most likely correct.

% distance between neighbouring vertices (in voxels)
APdist = imresize(sum(diff(Vmid,1,1),3),[APres,PDres]);
PDdist = imresize(sum(diff(Vmid,1,2),3),[APres,PDres]);

% conver to perimiter
MeshFacePerimiter = (2*APdist + 2*PDdist) /2;

% standard deviation in face perimeters should not exceed 1
SDFacePerimiter = std(MeshFacePerimiter(:));
fprintf('Standard deviation of face perimiters: %.3f\n',SDFacePerimiter);
disp('This should be <1.0');

% view mesh in 3D
views = 1:30:360;
FV.faces = F;
FV.vertices = reshape(Vmid,[APres*PDres,3]);
for v = 1:length(views)
    h = figure; %('units','normalized','outerposition',[0 0 0.2 0.2]);
    view(views(v),30);
    p = patch(FV); 
    axis equal tight;
    light; axis equal tight; 
    p.LineStyle = 'none'; 
    p.FaceColor = 'b'; 
    material dull;
    set(gca,'LooseInset',get(gca,'TightInset'));
    drawnow;
end

%% Inspect Anterior-Posterior gradient
% This should increase evenly from the MTL cortex boundary to the
% inner-most Dentate Gyrus granule cell layer. Look for 'bridges' across
% digitations or through the SRLM.

alpha3d = zeros(sz);
alpha3d(idxgm) = 0.5;
grad3d = alpha3d;
grad3d(idxgm) = Laplace_AP;
% set 95% colourmap window
t = sort(T2w(:));
t(isnan(t)) = [];
window = [t(round(length(t)*.05)) t(round(length(t)*.95))];
[x,y,z] = ind2sub(sz,idxgm);
slices = max(y)-4:-8:min(y);

for s=1:length(slices)
    f1 = figure; %('units','normalized','outerposition',[0 0 0.2 0.2]);
    h1 = axes;
    t2 = imagesc(h1,squeeze(T2w(:,slices(s),:))');
    colormap(h1,'gray');
    caxis(window);
    set(h1,'ydir','normal');
    axis equal tight off;
    set(gca,'LooseInset',get(gca,'TightInset'));
    h2 = axes;
    ap = imagesc(squeeze(grad3d(:,slices(s),:))',...
        'alphadata',squeeze(alpha3d(:,slices(s),:))');
    caxis(h2,[0 1]);
    set(h2,'color','none','visible','off')
    colormap(h2,'parula');
    set(h2,'ydir','normal');
    linkaxes([h1 h2]);
    axis equal tight off;
    set(gca,'LooseInset',get(gca,'TightInset'));
    drawnow;
end

%% Inspect Proximal-Distal gradient
% This should increase evenly from the antero-medial HATA boundary to the
% postero-medial indiseum griseum border. Look for 'bridges' across
% or through the SRLM.

alpha3d = zeros(sz);
alpha3d(idxgm) = 0.75;
grad3d = alpha3d;
grad3d(idxgm) = Laplace_PD;

for s=1:length(slices)
    f1 = figure; %('units','normalized','outerposition',[0 0 0.2 0.2]);
    h1 = axes;
    t2 = imagesc(h1,squeeze(T2w(:,slices(s),:))');
    colormap(h1,'gray');
    caxis(window);
    set(h1,'ydir','normal');
    axis equal tight off;
    set(gca,'LooseInset',get(gca,'TightInset'));
    h2 = axes;
    ap = imagesc(squeeze(grad3d(:,slices(s),:))',...
        'alphadata',squeeze(alpha3d(:,slices(s),:))');
    caxis(h2,[0 1]);
    set(h2,'color','none','visible','off')
    colormap(h2,'parula');
    set(h2,'ydir','normal');
    linkaxes([h1 h2]);
    axis equal tight off;
    set(gca,'LooseInset',get(gca,'TightInset'))
    drawnow;
end

%% Inspect Inner-Outer gradient
% This should increase evenly from the inner surface to the outer surface.
% Look for areas where the inner (or equavalently extended inner surface
% over the subiculum or vert. uncus) is absent, or where no gradient is
% present

alpha3d = zeros(sz);
alpha3d(idxgm) = 0.75;
grad3d = alpha3d;
grad3d(idxgm) = Laplace_IO;

for s=1:length(slices)
    f1 = figure; %('units','normalized','outerposition',[0 0 0.2 0.2]);
    h1 = axes;
    t2 = imagesc(h1,squeeze(T2w(:,slices(s),:))');
    colormap(h1,'gray');
    caxis(window);
    set(h1,'ydir','normal');
    axis equal tight off;
    set(gca,'LooseInset',get(gca,'TightInset'));
    h2 = axes;
    ap = imagesc(squeeze(grad3d(:,slices(s),:))',...
        'alphadata',squeeze(alpha3d(:,slices(s),:))');
    caxis(h2,[0 1]);
    set(h2,'color','none','visible','off')
    colormap(h2,'parula');
    set(h2,'ydir','normal');
    linkaxes([h1 h2]);
    axis equal tight off;
    set(gca,'LooseInset',get(gca,'TightInset'));
    drawnow;
end

%% Inspect extracted quantitative data
% These measures should differ between subfields, but can be somewhat noisy
% on invidivual subject data. Look for outliers

%% Thickness
% Thicknesses should vary from ~0.5mm to 2.5mm, and should be highest in
% subiculum and CA4, lowest in CA2 and CA3

figure; %('units','normalized','outerposition',[0 0 0.3 0.3]);
plot_foldunfold(streamlengths,FV,true,'');
set(gca,'LooseInset',get(gca,'TightInset'));
drawnow;
figure; %('units','normalized','outerposition',[0 0 0.2 0.2]);
hist(streamlengths(:),100);
set(gca,'LooseInset',get(gca,'TightInset'));
drawnow;

%% Gyrification index
% Gyrification index is measured as the difference in surface area between
% unfolded and native space (or the amount of distortion that results from
% flatmapping). Should be distributed around 1 but can have a very large
% positive tail if unfolding is not correct.

figure; %('units','normalized','outerposition',[0 0 0.3 0.3]);
plot_foldunfold(GI,FV,true,'');
set(gca,'LooseInset',get(gca,'TightInset'));
drawnow;
figure; %('units','normalized','outerposition',[0 0 0.2 0.2]);
hist(GI(:),100);
set(gca,'LooseInset',get(gca,'TightInset'));
drawnow;

%% Quantitative MRI
% This measure samples the original input image along the midsurface of
% hippocampal grey matter to minimize partial voluming effects from
% surrounding structures (alveus, SRLM, cysts, ventricles, blood vessels,
% etc). The distribution will depend on the input image but should fall
% withing grey matter range. Generally higher intracortical myelin is seen
% in subiculum and CA3.

try
    figure; %('units','normalized','outerposition',[0 0 0.3 0.3]);
    plot_foldunfold(qMap,FV,true,'');
    set(gca,'LooseInset',get(gca,'TightInset'));
    drawnow;
    figure; %('units','normalized','outerposition',[0 0 0.2 0.2]);
    hist(qMap(:),100);
    set(gca,'LooseInset',get(gca,'TightInset'));
    drawnow;
catch
    disp('No MRI image found to sample');
end
