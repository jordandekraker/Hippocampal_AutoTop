function create_template_unfold_gifti(out_folder, ...
    n_steps_unfold, affine_unfold)
arguments
    out_folder string
    n_steps_unfold  (1,3) double = [256, 128, 16]
    affine_unfold (4,4) double = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
end

% This function will generate the following files in the
% template unfolded space:
%  midthickness_254x126.unfolded.surf.gii
%  inner_254x126.unfolded.surf.gii
%  outer_254x126.unfolded.surf.gii
%
% Then, you can use wb_command with a subject's warp to transform to native
% wb_command  -surface-apply-warpfield  midthickness_254x126.unfolded.surf.gii Warp_unfold2native.nii midthickness_254x126.native.surf.gii 



%if transforming with wb_command, will complain if the points are not
%completed enclosed by the warp volume -- e.g. has an issue with the most
%extreme vertices.. to get around that, we should define the warp volume
%larger (i.e. extend laplace's field) -- but for now, will just create a
%flat mesh with the border vertices removed.. with a large discretization
%this is not a big deal..

n_steps_unfold_crop = [n_steps_unfold(1)-2,n_steps_unfold(2)-2,1];

%we create three 2-d surfaces:
io_inds = [2,ceil(n_steps_unfold(3)/2),n_steps_unfold(3)-1];
surf_names = {'inner','midthickness','outer'};


% get face connectivity - same for all surfs
t = [1:prod(n_steps_unfold_crop)]';
F = [t,t+1,t+(n_steps_unfold_crop(1)) ; t,t-1,t-(n_steps_unfold_crop(1))];
F = reshape(F',[3,n_steps_unfold_crop(1),n_steps_unfold_crop(2),2]);
F(:,n_steps_unfold_crop(1),:,1) = nan;
F(:,1,:,2) = nan;
F(:,:,n_steps_unfold_crop(2),1) = nan;
F(:,:,1,2) = nan;
F(isnan(F)) = [];
F=reshape(F,[3,(n_steps_unfold_crop(1)-1)*(n_steps_unfold_crop(2)-1)*2])';

%build sampling vectors in normalized unfolded space (0-1)
samplingu=0:1/((n_steps_unfold(1)-1)):1;  %here N is setting the number of steps
samplingv=0:1/(n_steps_unfold(2)-1):1;
samplingw=0:1/(n_steps_unfold(3)-1):1;

%and the corresponding meshgrid
[gv,gu,gw]=meshgrid(samplingv,samplingu,samplingw);

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

%reshape back to an image
unfold_coords_phys_img = reshape(unfold_coords_phys,size(unfold_ref));


for surf_i = 1:length(surf_names)
    io_ind = io_inds(surf_i);
    surf_name = surf_names{surf_i};
    
    basename = sprintf('%s/%s_%dx%d',out_folder,surf_name,n_steps_unfold_crop(1),n_steps_unfold_crop(2));
    
    %get surface
    unfold_midsurf_phys_img = squeeze(unfold_coords_phys_img(2:(end-1),2:(end-1),io_ind,:));
    
    unfold_midsurf_phys_vec = reshape(unfold_midsurf_phys_img,prod(size(unfold_midsurf_phys_img,1,2)),3);
    
    
    %save as gifti
    g = gifti;
    g.faces = int32(F);
    g.mat = eye(4,4);
    g.vertices = single(unfold_midsurf_phys_vec);
    
    gii_unfold = sprintf('%s.unfolded.surf.gii',basename);
    save(g,gii_unfold,'Base64Binary');
    
    
    
end
