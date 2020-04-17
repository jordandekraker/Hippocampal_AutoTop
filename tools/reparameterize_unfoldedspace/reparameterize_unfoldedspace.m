function flatmap_rp = reparameterize_unfoldedspace(Vxyz,flatmap)
% reparameterized unfolded space according to real-world distances. Vxyz
% should be a 4D tensor (APres*PDres*IOres*3), and its units (voxels, mm,
% etc.) will correspond to the output units.
% NOT RECOMMENDED - involves loss of information, smoothing, and parameters
% are not optimized


Vuvw_rp = CreateSmoothDistanceMaps(Vxyz,0.5);
Vuvw_rp_midsurf = squeeze(mean(Vuvw_rp,3));
Vuvw_rp_midsurf(:,:,3) = [];

xcoords_rp = Vuvw_rp_midsurf(:,:,1);
ycoords_rp = Vuvw_rp_midsurf(:,:,2);
shpx = [min(xcoords_rp(:)):max(xcoords_rp(:))];
shpy = [min(ycoords_rp(:)):max(ycoords_rp(:))];
[v,u] = meshgrid(shpx,shpy); % have to switch AP and PD because matlab sucks
qp = [u(:),v(:)];
mask = alphaShape(xcoords_rp(:),ycoords_rp(:));
flatmap_rp = griddata(xcoords_rp(:),ycoords_rp(:),flatmap(:),v,u);
flatmap_rp(~inShape(mask,v,u)) = nan;

