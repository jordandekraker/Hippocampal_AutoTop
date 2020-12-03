function extrapolate_warp_unfold2native(in_folder, out_folder)

% second-pass extrapolation:
in_warp_unfold2native = sprintf('%s/Warp_unfold2native.nii',in_folder);
out_warp_unfold2native = sprintf('%s/Warp_unfold2native_extrapolateNearest.nii',out_folder);


init_warp = niftiread(in_warp_unfold2native);
init_warp_info = niftiinfo(in_warp_unfold2native);


nan_mask = isnan(squeeze(sum(init_warp,5)));


bad_inds = find(nan_mask==1);
good_inds = find(nan_mask==0);


%points inside 
[px,py,pz]=ind2sub(size(init_warp,1,2,3),good_inds);
gm_points = [px,py,pz];

%points outside to extrapolate
[qx,qy,qz]=ind2sub(size(init_warp,1,2,3),bad_inds);
query_points = [qx,qy,qz];

%get nearest good coord from each bad coord:
nearest_inds = dsearchn(gm_points,query_points);


%warp is a displacement from current voxel --
%  so if we take displacment from the nearest voxel, it has the wrong
%  reference
% so instead, we first convert the displacement to a an absolute
% coordinate, use that, and then go back to displacemtn


%-- get unfold coords so we can convert from displacement to abs coord
n_steps_unfold = size(init_warp,1,2,3);
%build sampling vectors in normalized unfolded space (0-1)
samplingu=0:1/((n_steps_unfold(1)-1)):1;  %here N is setting the number of steps
samplingv=0:1/(n_steps_unfold(2)-1):1;
samplingw=0:1/(n_steps_unfold(3)-1):1;



%and the corresponding meshgrid
[gv,gu,gw]=meshgrid(samplingv,samplingu,samplingw);

gu_ = gu.*(n_steps_unfold(1)-1);  % here, N is setting the physical dimensions
gv_ = gv.*(n_steps_unfold(2)-1);
gw_ = gw.*(n_steps_unfold(3)-1);

affine_unfold = init_warp_info.Transform.T';


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
unfold_coords_phys_img = reshape(unfold_coords_phys,size(init_warp));

%change from relative to absolute coords
init_warp_abs = init_warp + unfold_coords_phys_img;



%set to nan (so can check if all points accounted for):
new_warp_abs = nan(size(init_warp));



for d = 1:3
    new_warp_abs_d = squeeze(new_warp_abs(:,:,:,d));
    init_warp_abs_d = squeeze(init_warp_abs(:,:,:,d));
    
    new_warp_abs_d(good_inds) = init_warp_abs_d(nan_mask==0);
    new_warp_abs_d(bad_inds) = init_warp_abs_d(good_inds(nearest_inds));
    
    new_warp_abs(:,:,:,d) = new_warp_abs_d;
end

%now change back to relative warp and save output
new_warp_rel = new_warp_abs - unfold_coords_phys_img;
niftiwrite(single(new_warp_rel),out_warp_unfold2native,init_warp_info);

end
