function create_template_unfold_gifti(out_folder)
arguments
    out_folder string
end

n_steps_unfold = [256 128 16];

%get path to reference nifti relative to this script 
[path,name,ext] = fileparts(mfilename('fullpath'));
unfold_ref_nii = [path '/unfold_ref_256x128x16.nii.gz'];




unfold_info = niftiinfo(unfold_ref_nii);
unfold_info.ImageSize = [unfold_info.ImageSize,3];
unfold_info.PixelDimensions = [unfold_info.PixelDimensions,1];
affine_unfold = unfold_info.Transform.T';

% we want the vertices to lie in the *centre* of a voxel;
% e.g. for voxel 0,0,0; and if voxel spacing is 1mm
%   then we want the vertex placed at 0.5,0.5,0.5;  so instead of index i,
%   we use index i+0.5;  from matlab index J, we want J-0.5


samplingu=0.5:1:(n_steps_unfold(1)-0.5);
samplingv=0.5:1:(n_steps_unfold(2)-0.5);  
samplingw=0.5:1:(n_steps_unfold(3)-1);
n_steps_unfold(3) = n_steps_unfold(3)-1;

%and the corresponding meshgrid
[gv,gu,gw]=meshgrid(samplingv,samplingu,samplingw);

%convert inds from 0-(N-1) to phys inds in unfolded space, byapplying
%affine (first cat into vec)
unfold_coords_mat = cat(4,gu,gv,gw);
unfold_coords_mat = reshape(unfold_coords_mat,[prod(size(unfold_coords_mat,1,2,3)),3]);
unfold_coords_mat = [unfold_coords_mat,ones(size(unfold_coords_mat,1),1)]';
unfold_coords_phys = affine_unfold*unfold_coords_mat;
unfold_coords_phys = unfold_coords_phys(1:3,:)';

%reshape back to an image
unfold_coords_phys_img = reshape(unfold_coords_phys,[size(gu,1,2,3),3]);

% --- for backwards compatibility with earlier surfaces, we use 254x126
% vertices instead of 256x128.. not a big deal I think..

%n_steps_unfold_crop = [n_steps_unfold(1)-2,n_steps_unfold(2)-2,1];
n_steps_unfold_crop = [n_steps_unfold(1)-2,n_steps_unfold(2)-2,1];

%we create three 2-d surfaces:
% the inner and outer 
io_inds = [1,ceil(n_steps_unfold(3)/2),n_steps_unfold(3)];
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


for surf_i = 1:length(surf_names)
    io_ind = io_inds(surf_i);
    surf_name = surf_names{surf_i};
    
    
    %get surface
    unfold_midsurf_phys_img = squeeze(unfold_coords_phys_img(2:(end-1),2:(end-1),io_ind,:));
    unfold_midsurf_phys_vec = reshape(unfold_midsurf_phys_img,prod(n_steps_unfold_crop),3);
    
    
    %save as gifti
    g = gifti;
    g.faces = int32(F);
    g.mat = eye(4,4);
    g.vertices = single(unfold_midsurf_phys_vec);
    
    gii_unfold = sprintf('%s/%s.unfoldedtemplate.surf.gii',out_folder,surf_name);
    vtk_unfold = sprintf('%s/%s.unfoldedtemplate.surf.vtk',out_folder,surf_name);

    save(g,gii_unfold,'Base64Binary');
    saveas(g,vtk_unfold);
    
end 
    
end
