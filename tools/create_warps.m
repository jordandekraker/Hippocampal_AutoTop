function create_warps(in_folder, out_folder, n_steps_unfold, affine_unfold)
    arguments
        in_folder string
        out_folder string
        n_steps_unfold  (1,3) double = [256, 128, 16]
        affine_unfold (4,4) double = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
    end
% - test params:       
%     n_steps_unfold = [256, 128, 16]
%     affine_unfold = eye(4,4) %to define space of coords

     in_coord_ap_nii=sprintf('%s/coords-AP.nii.gz',in_folder);
     in_coord_pd_nii=sprintf('%s/coords-PD.nii.gz',in_folder);
     in_coord_io_nii=sprintf('%s/coords-IO.nii.gz',in_folder);
     out_native2unfold_nii=sprintf('%s/Warp_native2unfold.nii',out_folder);
     out_unfold2native_nii=sprintf('%s/Warp_unfold2native.nii',out_folder);


    native_info = niftiinfo(in_coord_ap_nii);
    affine_native = native_info.Transform.T';

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


    %transform from world to ITK coords.. (RAS vs LPS)
%     native_coords_phys(:,1) = -native_coords_phys(:,1);
%     native_coords_phys(:,2) = -native_coords_phys(:,2);


    %build interpolator to go from normalized (0-1) unfolded space to native

    interp='natural';
    extrap='none';
    interp_X = scatteredInterpolant(Laplace_AP,Laplace_PD,Laplace_IO,native_coords_phys(:,1),interp,extrap);
    interp_Y = scatteredInterpolant(Laplace_AP,Laplace_PD,Laplace_IO,native_coords_phys(:,2),interp,extrap);
    interp_Z = scatteredInterpolant(Laplace_AP,Laplace_PD,Laplace_IO,native_coords_phys(:,3),interp,extrap);


    %build sampling vectors in normalized unfolded space (0-1)
    samplingu=0:1/((n_steps_unfold(1)-1)):1;  %here N is setting the number of steps
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


    %create a nifti from scratch for unfold space - as want this to be same for
    %all subjects, regardless of native space nifti
    unfold_ref_nii = [tempname '.nii'];
    unfold_ref = zeros([n_steps_unfold,3]);

    niftiwrite(single(unfold_ref), unfold_ref_nii);
    unfold_info = niftiinfo(unfold_ref_nii);
    unfold_info.Transform.T = affine_unfold'; %note transposing here


    %convert inds from 0-(N-1) to phys inds in unfolded space, byapplying
    %affine (first cat into vec)
    unfold_coords_mat = cat(4,gu_,gv_,gw_);
    unfold_coords_mat = reshape(unfold_coords_mat,[prod(size(unfold_coords_mat,1,2,3)),3]);
    unfold_coords_mat = [unfold_coords_mat,ones(size(unfold_coords_mat,1),1)]';

    unfold_coords_phys = affine_unfold*unfold_coords_mat;
    unfold_coords_phys = unfold_coords_phys(1:3,:)';


    %convert from world to itk coords (RAS to LPS)
%     unfold_coords_phys(:,1) = -unfold_coords_phys(:,1);
%     unfold_coords_phys(:,2) = -unfold_coords_phys(:,2);

    %reshape back to an image
    unfold_coords_phys_img = reshape(unfold_coords_phys,size(mapToNative));

    % create the displacement field
    displacementToNative = mapToNative - unfold_coords_phys_img;


    %convert from world to itk
%     displacementToNative(:,:,:,1) = -displacementToNative(:,:,:,1);
%     displacementToNative(:,:,:,2) = -displacementToNative(:,:,:,2);

    %write to file
    niftiwrite(single(displacementToNative),out_unfold2native_nii,unfold_info);

%----------- native2unfold

    mask_vec = repmat(mask,[1,1,1,3]);
    coords_vec = zeros(size(mask_vec));

    dilation_radius = 2;

    % use dilation of the laplace coords to extrapolate slightly
    %first dilate the mask
    dilated = imdilate(mask,strel('sphere',dilation_radius));

    %get only dilated region 
    boundarymask = dilated - mask;

    %dilated mask is the new mask
    mask = dilated;


    uvw = zeros(sum(mask(:)==1),3);
    for d = 1:3
        coord_img =  squeeze(coord_all(:,:,:,d));

        %dilate the coords to fill in the nearby boundaries
        dilated_coords_img = imdilate(coord_all,strel('sphere',dilation_radius));
        coord_img(boundarymask==1) = dilated_coords_img(boundarymask==1);

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
    native_vec_info.ImageSize = [native_vec_info.ImageSize, 3];
    native_vec_info.PixelDimensions = [native_vec_info.PixelDimensions, 0];
    native_vec_info.Datatype = 'single';

    niftiwrite(single(coords_vec),out_native2unfold_nii,native_vec_info);

    
    
end
