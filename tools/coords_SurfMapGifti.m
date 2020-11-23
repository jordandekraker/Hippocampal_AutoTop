function coords_SurfMapGifti(outprefix)

%% build warp from unfold to native

arg_outprefix = outprefix;
APres = 256; PDres = 128; IOres = 16;

load([outprefix 'unfold.mat']);

%need this if your outprefix isn't the same as 
%when autotop was initially run
outprefix = arg_outprefix;  


%get affine from labelmap-postProcess.nii.gz
ref_native_nii = [outprefix 'labelmap-postProcess.nii.gz'];
img_info = niftiinfo(ref_native_nii);
affine = img_info.Transform.T';

[i_L,j_L,k_L]=ind2sub(sz,idxgm);

%indices need to start from 0 if applying xfm
native_coords_mat = [i_L-1, j_L-1, k_L-1,ones(size(i_L))]';

%apply affine to get world coords
native_coords_phys = affine*native_coords_mat;

native_coords_phys = native_coords_phys(1:3,:)';

%transform from world to ITK coords.. (RAS vs LPS)
native_coords_phys(:,1) = -native_coords_phys(:,1);
native_coords_phys(:,2) = -native_coords_phys(:,2);

%build interpolator to go from normalized (0-1) unfolded space to native
%physical (ITK) space

interp='natural';
extrap='nearest';
interp_X = scatteredInterpolant(Laplace_AP,Laplace_PD,Laplace_IO,native_coords_phys(:,1),interp,extrap);
interp_Y = scatteredInterpolant(Laplace_AP,Laplace_PD,Laplace_IO,native_coords_phys(:,2),interp,extrap);
interp_Z = scatteredInterpolant(Laplace_AP,Laplace_PD,Laplace_IO,native_coords_phys(:,3),interp,extrap);

%interp at regular grid points in unfolded space, and write to a file
% this becomes the warp from unfolded to native
N_unfold = [APres,PDres,IOres];


%build sampling vectors in normalized unfolded space (0-1)
samplingu=0:1/(N_unfold(1)-1):1;
samplingv=0:1/(N_unfold(2)-1):1;
samplingw=0:1/(N_unfold(3)-1):1;

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
gu_ = gu.*(N_unfold(1)-1);
gv_ = gv.*(N_unfold(2)-1);
gw_ = gw.*(N_unfold(3)-1);

%create a ref unfolded space nifti, with same orientation as ref_native_nii
%(just in case this throws off things..  I think could work with just
%arbitrary image too, as long as affine is read)
ref_unfolded_nii = [outprefix 'ref_unfolded.nii.gz'];
system(sprintf('c3d %s -resample %dx%dx%d -spacing 1x1x1mm -scale 0 -o %s.nii.gz', ref_native_nii,N_unfold,ref_unfolded_nii));

ref_unfolded_vec_nii = [outprefix 'ref_unfolded_vec.nii.gz'];
%make it vector image by fslmerge (ugly..)
system(sprintf('fslmerge -t %s %s %s %s',ref_unfolded_vec_nii,ref_unfolded_nii,ref_unfolded_nii,ref_unfolded_nii));
            
%read in ref image header to get affine
unfold_info = niftiinfo(ref_unfolded_vec_nii);
affine_unfold = unfold_info.Transform.T';

%convert inds from 0-(N-1) to phys inds in unfolded space, byapplying
%affine (first cat into vec)

unfold_coords_mat = cat(4,gu_,gv_,gw_);
unfold_coords_mat = reshape(unfold_coords_mat,[prod(size(unfold_coords_mat,1,2,3)),3]);
unfold_coords_mat = [unfold_coords_mat,ones(size(unfold_coords_mat,1),1)]';

unfold_coords_phys = affine_unfold*unfold_coords_mat;
unfold_coords_phys = unfold_coords_phys(1:3,:)';

%convert from world to itk coords (RAS to LPS)
unfold_coords_phys(:,1) = -unfold_coords_phys(:,1);
unfold_coords_phys(:,2) = -unfold_coords_phys(:,2);

%reshape back to an image
unfold_coords_phys_img = reshape(unfold_coords_phys,size(mapToNative));

% create the displacement field
displacementToNative = mapToNative - unfold_coords_phys_img;

%convert from world to itk
displacementToNative(:,:,:,1) = -displacementToNative(:,:,:,1);
displacementToNative(:,:,:,2) = -displacementToNative(:,:,:,2);

warp_nii = [outprefix, 'Warp_unfold2nativecrop.nii'];

%write to file
niftiwrite(single(displacementToNative),warp_nii,unfold_info);

%gzip the file
gzip(warp_nii)

warp_nii_gz = [outprefix, 'Warp_unfold2nativecrop.nii'];

%% build flat gifti meshes and transform to native (cropped) space

%if transforming with wb_command, will complain if the points are not
%completed enclosed by the warp volume -- e.g. has an issue with the most
%extreme vertices.. to get around that, we should define the warp volume
%larger (i.e. extend laplace's field) -- but for now, will just create a
%flat mesh with the border vertices removed.. with a large discretization
%this is not a big deal..

% could distinguish the diff density meshes same convention HCP uses, by #
% of thousands of vertices
% 256x128 sampling, is 254*126 vertices = 320004 = 32k
%  but this could be confusing since hcp has a 32k fsLR surf..


N_unfold_crop = [N_unfold(1)-2,N_unfold(2)-2,1];

%we create three 2-d surfaces:
io_inds = [2,ceil(N_unfold(3)/2),N_unfold(3)-1];
surf_names = {'inner','midthickness','outer'};


% get face connectivity - same for all surfs
t = [1:prod(N_unfold_crop)]';
F = [t,t+1,t+(N_unfold_crop(1)) ; t,t-1,t-(N_unfold_crop(1))];
F = reshape(F',[3,N_unfold_crop(1),N_unfold_crop(2),2]);
F(:,N_unfold_crop(1),:,1) = nan;
F(:,1,:,2) = nan;
F(:,:,N_unfold_crop(2),1) = nan;
F(:,:,1,2) = nan;
F(isnan(F)) = [];
F=reshape(F,[3,(N_unfold_crop(1)-1)*(N_unfold_crop(2)-1)*2])';


    for surf_i = 1:length(surf_names)
        io_ind = io_inds(surf_i);
        surf_name = surf_names{surf_i};

        basename = [outprefix, sprintf('%s_%dx%d',surf_name,N_unfold_crop(1),N_unfold_crop(2))];

        %get surface
        unfold_midsurf_phys_img = squeeze(unfold_coords_phys_img(2:(end-1),2:(end-1),io_ind,:));

        %bring into itk space before writing
        unfold_midsurf_phys_img_itkspace = unfold_midsurf_phys_img;
        unfold_midsurf_phys_img_itkspace(:,:,1) = -unfold_midsurf_phys_img_itkspace(:,:,1);
        unfold_midsurf_phys_img_itkspace(:,:,2) = -unfold_midsurf_phys_img_itkspace(:,:,2);

        unfold_midsurf_phys_vec = reshape(unfold_midsurf_phys_img_itkspace,prod(size(unfold_midsurf_phys_img_itkspace,1,2)),3);


        %save as gifti
        g = gifti;
        g.faces = int32(F);
        g.mat = eye(4,4);
        g.vertices = single(unfold_midsurf_phys_vec);

        gii_unfold = sprintf('%s.unfolded.surf.gii',basename);
        save(g,gii_unfold,'Base64Binary');



        %check that surface is produced correctly and is able to sample img.nii.gz
        gii_warped_wb = sprintf('%s.nativecrop.surf.gii',basename);


        %now, try warping with wb_command -- 
        system(sprintf('wb_command -surface-apply-warpfield %s %s %s ',gii_unfold,warp_nii_gz,gii_warped_wb));

        %%convert to vtk for vis
        %gii_warped_wb_vtk = sprintf('%s.nativecrop.surf.vtk',basename);
        %system(sprintf('mris_convert %s %s',gii_warped_wb,gii_warped_wb_vtk));


        %can also set structure for the files (so wb_view doesn't complain) -
        %left/right not known inside this funtion though..


    %     
    %     gii_wb_t2w = sprintf('%s.shape.gii',basename);
    % 
    %     %test by mapping from volume
    %     system(sprintf('wb_command -volume-to-surface-mapping img.nii.gz %s %s -trilinear',gii_warped_wb,gii_wb_t2w));


    end

    coord_ap = [outprefix, 'coords-AP.nii.gz'];
    coord_pd = [outprefix, 'coords-PD.nii.gz'];
    mid = [outprefix, sprintf('midthickness_%dx%d.nativecrop.surf.gii',N_unfold_crop(1),N_unfold_crop(2))];
    inner = [outprefix, sprintf('inner_%dx%d.nativecrop.surf.gii',N_unfold_crop(1),N_unfold_crop(2))];
    outer = [outprefix, sprintf('outer_%dx%d.nativecrop.surf.gii',N_unfold_crop(1),N_unfold_crop(2))];
    metric_ap = [outprefix, sprintf('coords-AP_%dx%d.shape.gii',N_unfold_crop(1),N_unfold_crop(2))];
    metric_pd = [outprefix, sprintf('coords-PD_%dx%d.shape.gii',N_unfold_crop(1),N_unfold_crop(2))];
    
    %test by mapping coords (AP, PD) from ribbon
    system(sprintf('wb_command -volume-to-surface-mapping %s %s %s -ribbon-constrained %s %s',coord_ap,mid, metric_ap,inner, outer));
    system(sprintf('wb_command -volume-to-surface-mapping %s %s %s -ribbon-constrained %s %s',coord_pd,mid, metric_pd,inner, outer));

end