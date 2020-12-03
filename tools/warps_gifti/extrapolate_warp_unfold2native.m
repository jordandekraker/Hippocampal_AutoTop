function extrapolate_warp_unfold2native(in_folder, out_folder)

% second-pass extrapolation:
in_warp_unfold2native = sprintf('%s/Warp_unfold2native.nii',in_folder);
in_itkwarp_native2unfold = sprintf('%s/WarpITK_native2unfold.nii',in_folder);
out_warp_unfold2native = sprintf('%s/Warp_unfold2native_extrapolateNearest.nii',out_folder);
in_labelmap_native = sprintf('%s/labelmap-postProcess.nii.gz',in_folder);
out_labelmap_unfold = sprintf('%s/labelmap-postProcess_unfold.nii',out_folder);

init_warp = niftiread(in_warp_unfold2native);
init_warp_info = niftiinfo(in_warp_unfold2native);

%problem with scattered interpolant is it uses convex hull to define
%the space where interpolation occurs.. 

% we want to use only voxels where GM exists to define the warp
%can get these voxels by warping labelmap from native to unfolded


%this will try antsApplyTransforms first, if it doesn't work will run
%wb_command.. they should both produce same result, but this is just for
%convenience since antsApplyTransforms doesn't work within matlab on cbs
%server, while on graham wb_command isn't currently in the container.. :(
if ~(system(sprintf('antsApplyTransforms -i %s -r %s -t %s -n NearestNeighbor -o %s', ...
     in_labelmap_native, in_itkwarp_native2unfold, in_itkwarp_native2unfold, out_labelmap_unfold)))
    system(sprintf('wb_command -volume-warpfield-resample %s %s %s   ENCLOSING_VOXEL  %s', ...
    in_labelmap_native, in_warp_unfold2native, in_warp_unfold2native, out_labelmap_unfold));
end



labelmap_unfold = niftiread(out_labelmap_unfold);


gm_mask = labelmap_unfold==1;
gm_inds = find(gm_mask==1);
non_gm_inds = find(gm_mask==0);


%points inside GM
[px,py,pz]=ind2sub(size(init_warp,1,2,3),gm_inds);
gm_points = [px,py,pz];

%points outside
[qx,qy,qz]=ind2sub(size(init_warp,1,2,3),non_gm_inds);
query_points = [qx,qy,qz];

%get nearest gm coord from each non-gm coord:
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
    
    new_warp_abs_d(gm_inds) = init_warp_abs_d(gm_mask==1);
    new_warp_abs_d(non_gm_inds) = init_warp_abs_d(gm_inds(nearest_inds));
    
    new_warp_abs(:,:,:,d) = new_warp_abs_d;
end

%now change back to relative warp and save output
new_warp_rel = new_warp_abs - unfold_coords_phys_img;
niftiwrite(single(new_warp_rel),out_warp_unfold2native,init_warp_info);

end
