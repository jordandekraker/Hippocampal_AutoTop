function create_warps(in_folder, out_folder, n_steps_unfold, phys_scaling_mm, unfold_origin_mm)
arguments
    in_folder string
    out_folder string
    n_steps_unfold  (1,3) double = [256, 128, 16]
    phys_scaling_mm  (1,3) double = [40,20,2.5]
    unfold_origin_mm (1,3) double = [0,200,0] %needs to be outside of brain to
    %avoid artifacts when resampling from unfold to native
    
end
% - test params:
%     n_steps_unfold = [256, 128, 16]
%     phys_scaling_mm = [40,20,2.5]

if ( ~exist(out_folder))
    mkdir(out_folder)
end

in_coord_ap_nii=sprintf('%s/coords-AP.nii.gz',in_folder);
in_coord_pd_nii=sprintf('%s/coords-PD.nii.gz',in_folder);
in_coord_io_nii=sprintf('%s/coords-IO.nii.gz',in_folder);
out_native2unfold_nii=sprintf('%s/Warp_native2unfold.nii',out_folder);
%ITK unfold2native is the same warp as world native2unfold
out_unfold2native_itk_nii=sprintf('%s/WarpITK_unfold2native.nii',out_folder);
out_unfold2native_nii=sprintf('%s/Warp_unfold2native.nii',out_folder);
out_native2unfold_itk_nii=sprintf('%s/WarpITK_native2unfold.nii',out_folder);
out_absolute_unfold2native_nii=sprintf('%s/abswarp_unfold2native.nii',out_folder);
out_unfold_phys_coords_nii=sprintf('%s/unfold_phys_coords.nii',out_folder);
out_native_phys_coords_nii=sprintf('%s/native_phys_coords.nii',out_folder);



native_info = niftiinfo(in_coord_ap_nii);
affine_native = native_info.Transform.T';

%create unfolded coords reference

vox_size = 1.0./(n_steps_unfold -1);


scaled_vox_size = phys_scaling_mm./n_steps_unfold;

unfold_coord_nii = sprintf('%s/unfold_ref.nii',out_folder);

%create unfold phys coordinates file using c3d:
%  orientation: ALI is A-P,  L-R,  I-S;
%    chosen to correspond with hippocampal coords: A-P, P-D, I-O
system(sprintf('c3d -create %dx%dx%d %fx%fx%fmm -origin %fx%fx%fmm -orient ALI -coordinate-map-voxel -spacing %fx%fx%fmm -popas ZI -popas YI -popas XI -push XI -scale %f -push YI -scale %f -push ZI -scale %f -omc %s',n_steps_unfold, vox_size,unfold_origin_mm,scaled_vox_size,vox_size,unfold_coord_nii));



unfold_info = niftiinfo(unfold_coord_nii);
affine_unfold = unfold_info.Transform.T';


%load coords niftis
coord_ap = double(niftiread(in_coord_ap_nii));
coord_pd = double(niftiread(in_coord_pd_nii));
coord_io = double(niftiread(in_coord_io_nii));

coord_all = cat(4,coord_ap,coord_pd,coord_io);

%create the mask
mask = (coord_ap>0 & coord_pd>0 & coord_io>0);
idxgm = find(mask ==1);
sz = size(coord_ap);

Laplace_AP = coord_ap(mask==1);
Laplace_PD = coord_pd(mask==1);
Laplace_IO = coord_io(mask==1);

[i_L,j_L,k_L]=ind2sub(sz,idxgm);

%indices need to start from 0 if applying xfm
native_coords_mat = [i_L-1, j_L-1, k_L-1,ones(size(i_L))]';

%apply affine to get world coords
native_coords_phys = affine_native*native_coords_mat;
native_coords_phys = native_coords_phys(1:3,:)';


%build interpolator to go from normalized (0-1) unfolded space to native
interp='natural';
extrap='none';
interp_X = scatteredInterpolant(Laplace_AP,Laplace_PD,Laplace_IO,native_coords_phys(:,1),interp,extrap);
interp_Y = scatteredInterpolant(Laplace_AP,Laplace_PD,Laplace_IO,native_coords_phys(:,2),interp,extrap);
interp_Z = scatteredInterpolant(Laplace_AP,Laplace_PD,Laplace_IO,native_coords_phys(:,3),interp,extrap);



%build sampling vectors in normalized unfolded space (0-1)
samplingu=0:1/(n_steps_unfold(1)-1):1;  %here N is setting the number of steps
samplingv=0:1/(n_steps_unfold(2)-1):1;
samplingw=0:1/(n_steps_unfold(3)-1):1;


%and the corresponding meshgrid
[gv,gu,gw]=meshgrid(samplingv,samplingu,samplingw);

%use this to interpolate at every unfolded grid point, the corresponding
%phys x,y,z

Xi=interp_X(gu,gv,gw);
Yi=interp_Y(gu,gv,gw);
Zi=interp_Z(gu,gv,gw);

%stack these into a single vector image
mapToNative = cat(4,Xi,Yi,Zi);


%  unfolded_itk_coords + displacement = mapToNative
%
%  so, to get displacement field, we just subtract the image coords in unfolded
%  space, i.e. the meshgrid..
%
%  displacement = mapToNative - unfolded_itk_coords

%first get coords in the space of the unfold nii (which is from 0 to N-1),
%not 0-1
gu_ = gu.*(n_steps_unfold(1)-1);  % here, N is setting the physical dimensions
gv_ = gv.*(n_steps_unfold(2)-1);
gw_ = gw.*(n_steps_unfold(3)-1);


%convert inds from 0-(N-1) to phys inds in unfolded space, byapplying
%affine (first cat into vec)
unfold_coords_mat = cat(4,gu_,gv_,gw_);
unfold_coords_mat = reshape(unfold_coords_mat,[prod(size(unfold_coords_mat,1,2,3)),3]);
unfold_coords_mat = [unfold_coords_mat,ones(size(unfold_coords_mat,1),1)]';

unfold_coords_phys = affine_unfold*unfold_coords_mat;
unfold_coords_phys = unfold_coords_phys(1:3,:)';


%reshape back to an image
unfold_coords_phys_img = reshape(unfold_coords_phys,size(mapToNative));

% create the displacement field
displacementToNative = mapToNative - unfold_coords_phys_img;


displacementToNative = reshape(displacementToNative,[n_steps_unfold,1,3]);


niftiwrite(single(reshape(mapToNative,[n_steps_unfold,1,3])),out_absolute_unfold2native_nii,unfold_info);

niftiwrite(single(reshape(unfold_coords_phys_img,[n_steps_unfold,1,3])),out_unfold_phys_coords_nii,unfold_info);

%write to file
niftiwrite(single(displacementToNative),out_unfold2native_nii,unfold_info);

%convert to ITK transform using c3d (simply scaling X and Y by -1)
system(sprintf('c3d -mcs %s -popas DZ -popas DY -popas DX -push DX -scale -1 -push DY -scale -1 -push DZ -omc %s',...
    out_unfold2native_nii, out_native2unfold_itk_nii));

%----------- native2unfold

mask_vec = repmat(mask,[1,1,1,3]);
coords_vec = zeros(size(mask_vec));

%get native phys coords
native_vec_info = niftiinfo(out_native_phys_coords_nii);
native_phys_coords = niftiread(out_native_phys_coords_nii);

%here we get the ap, pd, io coords, (the new unfolded coords)
uvw = zeros(sum(mask(:)==1),3);
for d = 1:3
    coord_img =  squeeze(coord_all(:,:,:,d));
    uvw(:,d) = coord_img(mask==1) .* (n_steps_unfold(d)-1);
end

uvw1 = [uvw, ones(size(uvw,1),1)];
uvw1_phys = affine_unfold*uvw1';
uvw_phys = uvw1_phys(1:3,:)';



for d=1:3
    coord_img = squeeze(native_phys_coords(:,:,:,d));
    coord_img(mask==1) = uvw_phys(:,d);
    coords_vec(:,:,:,d) = coord_img;
end


% at this point, coords_vec contains the new_coords in unfolded space
% we want to subtract the original coords from this

%easy way of getting the original phys coords is from c3d:
system(sprintf('c3d %s -coordinate-map-physical -omc %s', ...
    in_coord_ap_nii,out_native_phys_coords_nii));


%now we want to load it up and subtract from new_coords


displacement_native = reshape(coords_vec,[size(coords_vec,1,2,3),1,3]) - native_phys_coords;

niftiwrite(displacement_native,out_native2unfold_nii,native_vec_info);


%convert to ITK transform using c3d (simply scaling X and Y by -1)
system(sprintf('c3d -mcs %s -popas DZ -popas DY -popas DX -push DX -scale -1 -push DY -scale -1 -push DZ -omc %s',...
    out_native2unfold_nii, out_unfold2native_itk_nii));




end
