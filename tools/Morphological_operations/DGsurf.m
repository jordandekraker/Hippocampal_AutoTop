load('hemi-R/surf.mat');
load('hemi-R/unfold.mat');
lbl = labelmap;

% % crop
% buffer = 5;
% [r,c,v] = ind2sub(sz,find(lbl==8));
% lbl(max(r)+buffer:end,:,:) = [];
% lbl(1:min(r)-buffer,:,:) = [];
% lbl(:,max(c)+buffer:end,:) = [];
% lbl(:,1:min(c)-buffer,:) = [];
% lbl(:,:,max(v)+buffer:end) = [];
% lbl(:,:,1:min(v)-buffer) = [];
szc = size(lbl);

% thickness laplacian
IOdg = laplace_solver(lbl==8,lbl==1,lbl~=8 & lbl~=1, 100);

% isosurface (note will vary in size)
IOdg3d = zeros(szc);
IOdg3d(lbl==8) = IOdg;
% IOdg3d(lbl~=8 & lbl~=1) = 1;
FVdg = isosurface(IOdg3d,0.5);
IOdg3d = zeros(szc);
IOdg3d(lbl==8) = -IOdg+1;
IOdg3d(lbl==1) = 1;
FVdg2 = isosurface(IOdg3d,0.5);
% keep only the midsurface, not the two separate outersurfaces
i = ismember(FVdg.vertices,FVdg2.vertices,'rows');
FVdg.vertices(~i,:) = nan;
FVdg.vertices(:,[1 2]) = FVdg.vertices(:,[2 1]);% x and y get swapped by isosurface()

% un-crop
% FVdg.vertices(:,1) = FVdg.vertices(:,1) + min(r)-buffer;
% FVdg.vertices(:,2) = FVdg.vertices(:,2) + min(c)-buffer;
% FVdg.vertices(:,3) = FVdg.vertices(:,3) + min(v)-buffer;

% clean up surface (remove nans)
for i = length(FVdg.vertices):-1:1
    if any(isnan(FVdg.vertices(i,:)))
        FVdg.faces(any(FVdg.faces==i,2), :) = []; % remove faces
        FVdg.vertices(i,:) = []; % remove vertices
        FVdg.faces(FVdg.faces>i) = FVdg.faces(FVdg.faces>i)-1; % slide indices
    end
end

% get closest corresponding AP points (from ~CA4 region only)
ap3d = zeros(sz);
ap3d(idxgm) = Laplace_AP;
pd3d = zeros(sz);
pd3d(idxgm) = Laplace_PD;
[x,y,z] = ind2sub(sz,find(pd3d>0.9));
for i = 1:length(x)
    ap(i,1) = ap3d(x(i),y(i),z(i));
end
g = scatteredInterpolant(x,y,z,ap,'nearest','nearest');
APdg = g(FVdg.vertices(:,1),FVdg.vertices(:,2),FVdg.vertices(:,3));



% plot usual midsurface
FV.faces = F;
FV.vertices = reshape(Vmid,[APres*PDres,3]);
orig = load_untouch_nii('hemi-R/img.nii.gz');
v = round(reshape(Vmid,[APres*PDres,3]));
for i = 1:length(v)
    img(i) = orig.img(v(i,1),v(i,2),v(i,3));
end
img = reshape(img,[APres,PDres]);
plot_foldunfold(img,FV);

% add DG surf
subplot(1,2,1);
hold on;
p = patch(FVdg);
p.FaceColor = 'r';
p.LineStyle = 'none';
%imagesc(squeeze(IOdg3d(:,90,:)))