function create_subj_isosurf (in_coords_io_nii, out_prefix)

% this is still a work in progress, needs hole-filling, and then another function to resample to a different mesh in the unfolded space
%   (i.e. could be similar to -surface-resample  or -metric-resample;  <in_surf> <curr_flat_mesh> <new_flat_mesh> <out_surf>)

%-- example args
%in_coords_io_nii = 'coords-IO.nii.gz';
%out_prefix = './';
%--

io_img = niftiread(in_coords_io_nii);
img_info = niftiinfo(in_coords_io_nii);

affine = img_info.Transform.T';

%smoothing params
VoxSize = 0.3;
DisplTol = 0.001*VoxSize; %default 0.01*VoxSize
IterTol = 100; %default is 100
Freedom = 1; %default 2, unrestricts normal and tangential smoothing -- 1 just unrestricts tangential


%set non gm to nan
io_img(io_img==0) = nan;

io_threshold = 0.5;
surf_name = 'midthickness';


%generate isosurf
[faces, vert_iso ] = isosurface(io_img,io_threshold);

%isosurface uses meshgrid, so need to swap X and Y
vertices = zeros(size(vert_iso));
vertices(:,1) = vert_iso(:,2);
vertices(:,2) = vert_iso(:,1);
vertices(:,3) = vert_iso(:,3);


%adjust to phys coordinates
vert_phys = affine*[vertices,ones(size(vertices,1),1)]';
vertices = vert_phys(1:3,:)';



%---- remove disconnected vertices

%create a graph of edges
G = graph([faces(:,1); faces(:,1); faces(:,2)],[faces(:,2); faces(:,3); faces(:,3)]);
A = adjacency(G);
[numcomponents, C] = graphconncomp(A);

%first component is the largest
%keep only the vertices in the largest component:
[vertices_pruned, faces_pruned] = remove_vertices(vertices, faces, find(C>1));

% as a test, compute graph again
G = graph([faces_pruned(:,1); faces_pruned(:,1); faces_pruned(:,2)],[faces_pruned(:,2); faces_pruned(:,3); faces_pruned(:,3)]);
A = adjacency(G);
[numcomponents, C] = graphconncomp(A);
%assert numcomponents == 1

%----  smoooth the surface --
%not really necessary anymore..

vertices_smoothed = SurfaceSmooth(vertices_pruned, faces_pruned, VoxSize,DisplTol, IterTol, Freedom);

%---- to do:

% identify and fill holes (topological correction)
% clean up the boundary (fix the jagged edges)

%----  save as gifti
g = gifti;
g.mat = eye(4,4);
g.faces = int32(faces);
g.vertices = single(vertices);
save(g,sprintf('%s%s.iso.surf.gii',out_prefix,surf_name),'Base64Binary');
saveas(g,sprintf('%s%s.iso.surf.vtk',out_prefix,surf_name));
g_pruned = g;
g_pruned.faces = int32(faces_pruned);
g_pruned.vertices = single(vertices_pruned);
save(g_pruned,sprintf('%s%s.isopruned.surf.gii',out_prefix,surf_name),'Base64Binary');
saveas(g_pruned,sprintf('%s%s.isopruned.surf.vtk',out_prefix,surf_name));

g_smooth = g_pruned;
g_smooth.vertices = single(vertices_smoothed);
save(g_smooth,sprintf('%s%s.isosmoothed.surf.gii',out_prefix,surf_name),'Base64Binary');
saveas(g_smooth,sprintf('%s%s.isosmoothed.surf.vtk',out_prefix,surf_name));

%plot them
figure;
plot(g);
title(sprintf('%s.iso.surf.gii',surf_name));
axis equal;
figure;
plot(g_pruned);
title(sprintf('%s.isopruned.surf.gii',surf_name));
axis equal;
figure;
plot(g_smooth);
title(sprintf('%s.isosmoothed.surf.gii',surf_name));
axis equal;

end
