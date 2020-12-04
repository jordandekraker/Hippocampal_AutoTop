function create_warps(autotop_folder, warps_folder)
arguments
    autotop_folder string
    warps_folder string
end

n_steps_unfold = [256 128 16];

%get path to reference nifti relative to this script 
[path,name,ext] = fileparts(mfilename('fullpath'));
unfold_ref_nii = [path '/unfold_ref_256x128x16.nii.gz'];

in_coord_ap_nii=sprintf('%s/coords-AP.nii.gz',autotop_folder);
in_coord_pd_nii=sprintf('%s/coords-PD.nii.gz',autotop_folder);
in_coord_io_nii=sprintf('%s/coords-IO.nii.gz',autotop_folder);

out_native2unfold_nii=sprintf('%s/Warp_native2unfold.nii',warps_folder);
%ITK unfold2native is the same warp as world native2unfold
out_unfold2native_itk_nii=sprintf('%s/WarpITK_unfold2native.nii',warps_folder);
out_unfold2native_nii=sprintf('%s/Warp_unfold2native.nii',warps_folder);
out_native2unfold_itk_nii=sprintf('%s/WarpITK_native2unfold.nii',warps_folder);
out_absolute_unfold2native_nii=sprintf('%s/abswarp_unfold2native.nii',warps_folder);
out_unfold_phys_coords_nii=sprintf('%s/unfold_phys_coords.nii',warps_folder);
out_native_phys_coords_nii=sprintf('%s/native_phys_coords.nii',warps_folder);



native_info = niftiinfo(in_coord_ap_nii);
affine_native = native_info.Transform.T';

%% create unfolded coords reference
%




    
    unfold_info = niftiinfo(unfold_ref_nii);
    unfold_info.ImageSize = [unfold_info.ImageSize,3];
    unfold_info.PixelDimensions = [unfold_info.PixelDimensions,1];
    affine_unfold = unfold_info.Transform.T';



%build sampling vectors in normalized unfolded space (0-1)
samplingu=0:1/(n_steps_unfold(1)-1):1;  %here N is setting the number of steps
samplingv=0:1/(n_steps_unfold(2)-1):1;
samplingw=0:1/(n_steps_unfold(3)-1):1;


%and the corresponding meshgrid
[gv,gu,gw]=meshgrid(samplingv,samplingu,samplingw);


%first get coords in the space of the unfold nii (which is from 0 to N-1),
%not 0-1
gu_ = gu.*(n_steps_unfold(1)-1);  % here, N is setting the physical dimensions
gv_ = gv.*(n_steps_unfold(2)-1);
gw_ = gw.*(n_steps_unfold(3)-1);

%unfold_info = niftiinfo(unfold_ref_nii);
%affine_unfold = unfold_info.Transform.T';


%convert inds from 0-(N-1) to phys inds in unfolded space, byapplying
%affine (first cat into vec)
unfold_coords_mat = cat(4,gu_,gv_,gw_);
unfold_coords_mat = reshape(unfold_coords_mat,[prod(size(unfold_coords_mat,1,2,3)),3]);
unfold_coords_mat = [unfold_coords_mat,ones(size(unfold_coords_mat,1),1)]';

unfold_coords_phys = affine_unfold*unfold_coords_mat;
unfold_coords_phys = unfold_coords_phys(1:3,:)';


%reshape back to an image
unfold_coords_phys_img = reshape(unfold_coords_phys,[n_steps_unfold,1,3]);


niftiwrite(single(reshape(unfold_coords_phys_img,[n_steps_unfold,1,3])),out_unfold_phys_coords_nii,unfold_info);

%%

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


%% this section is the one that takes long..

%use this to interpolate at every unfolded grid point, the corresponding
%phys x,y,z

Xi=interp_X(gu,gv,gw);
Yi=interp_Y(gu,gv,gw);
Zi=interp_Z(gu,gv,gw);

%%
%stack these into a single vector image
mapToNative = cat(4,Xi,Yi,Zi);


%  unfolded_itk_coords + displacement = mapToNative
%
%  so, to get displacement field, we just subtract the image coords in unfolded
%  space, i.e. the meshgrid..
%
%  displacement = mapToNative - unfolded_itk_coords



% create the displacement field
displacementToNative = reshape(mapToNative,[n_steps_unfold,1,3]) - unfold_coords_phys_img;


displacementToNative = reshape(displacementToNative,[n_steps_unfold,1,3]);


niftiwrite(single(reshape(mapToNative,[n_steps_unfold,1,3])),out_absolute_unfold2native_nii,unfold_info);

%write to file
niftiwrite(single(displacementToNative),out_unfold2native_nii,unfold_info);

itk_displacementToNative = displacementToNative;
itk_displacementToNative(:,:,:,:,1) = -itk_displacementToNative(:,:,:,:,1);
itk_displacementToNative(:,:,:,:,2) = -itk_displacementToNative(:,:,:,:,2);

comp_info = unfold_info;
comp_info.ImageSize = comp_info.ImageSize(1:3);
comp_info.PixelDimensions = comp_info.PixelDimensions(1:3);

disp_x_nii = [tempname '_x.nii'];
disp_y_nii = [tempname '_y.nii'];
disp_z_nii = [tempname '_z.nii'];
    
niftiwrite(single(squeeze(displacementToNative(:,:,:,:,1))),disp_x_nii,comp_info);
niftiwrite(single(squeeze(displacementToNative(:,:,:,:,2))),disp_y_nii,comp_info);
niftiwrite(single(squeeze(displacementToNative(:,:,:,:,3))),disp_z_nii,comp_info);

%convert to ITK transform using c3d (simply scaling X and Y by -1)
system(sprintf('c3d %s -popas DZ %s -popas DY %s -popas DX -push DX -scale -1 -push DY -scale -1 -push DZ -omc %s',...
    disp_z_nii,disp_y_nii,disp_x_nii, ...
     out_native2unfold_itk_nii));
 
%% native to unfold

    mask_vec = repmat(mask,[1,1,1,3]);
    coords_vec = zeros(size(mask_vec));



    uvw = zeros(sum(mask(:)==1),3);
    for d = 1:3
        coord_img =  squeeze(coord_all(:,:,:,d));

        uvw(:,d) = coord_img(mask==1) .* (n_steps_unfold(d)-1);
    end

    uvw1 = [uvw, ones(size(uvw,1),1)];
    uvw1_phys = affine_unfold*uvw1';
    uvw_phys = uvw1_phys(1:3,:)';

    for d=1:3
        coord_img = zeros(size(mask));
        coord_img(mask==1) = uvw_phys(:,d);
        coords_vec(:,:,:,d) = coord_img;
    end


    % at this point, coords_vec contains the new_coords in unfolded space
    % we want to subtract the original coords from this


    % a warp file is the displacement,   origcoord + displacement = new_coords
    % right now, coords_vec has the new_coords
    % so we just need to subtract is origcoords, which is the subscripts of the
    % voxel, changed to index from 0 (ie subtract 1), and converted to phys
    % coords by affine

    [x,y,z] = ind2sub(size(mask),find(mask==1));

    %indices need to start from 0 if applying xfm
    native_coords_mat = [x-1, y-1, z-1,ones(size(x,1),1)]';

    %apply affine to get world coords
    native_coords_phys = affine_native*native_coords_mat;


    %put phys coords back into coords_vec, and write out nifti
    for d=1:3
        unfold_coord = coords_vec(:,:,:,d);
        orig_coord = zeros(size(unfold_coord));
        %here, we are doing:  new_coords - orig_coords (to get displacement)
        orig_coord(mask==1) = native_coords_phys(d,:);   
        coords_vec(:,:,:,d) = mask.*(unfold_coord - orig_coord);
    end

    
 
    native_vec_info = native_info;
    native_vec_info.ImageSize = [native_vec_info.ImageSize, 1,3];
    native_vec_info.PixelDimensions = [native_vec_info.PixelDimensions, 1,1];
    native_vec_info.Datatype = 'single';

    niftiwrite(single(reshape(coords_vec,native_vec_info.ImageSize)),out_native2unfold_nii,native_vec_info);

    
    
comp_info = native_info;
comp_info.ImageSize = comp_info.ImageSize(1:3);
comp_info.PixelDimensions = comp_info.PixelDimensions(1:3);

disp_x_nii = [tempname '_x.nii'];
disp_y_nii = [tempname '_y.nii'];
disp_z_nii = [tempname '_z.nii'];
    
niftiwrite(single(squeeze(coords_vec(:,:,:,1))),disp_x_nii,comp_info);
niftiwrite(single(squeeze(coords_vec(:,:,:,2))),disp_y_nii,comp_info);
niftiwrite(single(squeeze(coords_vec(:,:,:,3))),disp_z_nii,comp_info);

   
%convert to ITK transform using c3d (simply scaling X and Y by -1)
system(sprintf('c3d %s -popas DZ %s -popas DY %s -popas DX -push DX -scale -1 -push DY -scale -1 -push DZ -omc %s',...
    disp_z_nii,disp_y_nii,disp_x_nii, ...
     out_unfold2native_itk_nii));
    
    


end
