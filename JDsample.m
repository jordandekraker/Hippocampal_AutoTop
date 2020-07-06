# script for JD to demo some of the things that are no longer needed from Uzair's repo 
# since they have already been implemented in Hippocampal_AutoTop
addpath(genpath('tools'));

# DWI image is too large for github but can be found on graham:
DWIimg_dir = '/home/jdekrake/Hippocampal_AutoTop/example/HCP_100610_hemi-L/data_resampled_hemiL.nii.gz';

## load in existing subject example
# This file contains the original labelmap, a list of all grey matter voxels (AKA the domain), Laplace 
# solutions, and a few other useful variables
load('example/HCP_100610_hemi-L/unfold.mat');
# this file contains an indexed set of unfolded points (Vuvw) with correpsonding native space points 
# (Vxyz). Note that these were generated using interpolation, and so both sets are the same size (ie. 
# APres * PDres * IOres * 3), but this is not equal to the number of voxels in the hippocampus! 
Vxyz = reshape(Vxyz,[APres*PDres*IOres,3]);
figure;
scatter3(Vxyz(:,1),Vxyz(:,2),Vxyz(:,3));
axis equal;
Vuvw = reshape(Vuvw,[APres*PDres*IOres,3]);
figure;
scatter3(Vuvw(:,1),Vuvw(:,2),Vuvw(:,3));
axis equal;

# another useful thing in this file is Vmid, which contains xyz points along a midsurface, and F which 
# denotes the face connectivity between them:
Vmid = reshape(Vmid,[APres*PDres,3]);
figure;
p = patch('Faces',F,'Vertices',Vmid); 
p.FaceColor = 'b'; 
p.LineStyle = 'none'; 
axis equal tight off; 
material dull;
light;
# this will likely not be needed for the DWI data, but its good to know about.

## reparameterized space (according to real-world distances
# here I simply adapted and simplified Uzair original code
Vxyz = reshape(Vxyz,[APres,PDres,IOres,3]);
Vuvw_rp = CreateSmoothDistanceMaps(Vxyz,0.5);
Vuvw_rp = reshape(Vuvw,[APres*PDres*IOres,3]);
figure;
scatter3(Vuvw(:,1),Vuvw(:,2),Vuvw(:,3));
axis equal;
# Note this involves resampling to save memory, and also anisotropic smoothing. These parameters were chosen 
# by Uzair but I think they're somewhat arbitrary (see variables rsFactor, sz_filt_uv, sz_filt_w, sz_filt_w,
# sigma_w). Thus this step does involve some loss of information but Uzair assures me that that is OK and
# necessary ¯\_(ツ)_/¯

# This function does the same thing but then bins the output to easily visualize (Note even more information
# loss)
feature = reshape(qMap,[APres,PDres]); # example feature in this case T2w (or quantitative Map)
figure;
imagesc(feature);
axis equal tight;
feature_rp = reparameterize_unfoldedspace(Vxyz,feature);
figure;
imagesc(feature_rp);
axis equal tight;

## TODO
# Ideally, the DWI data will be unstacked (ie separated into a stack of 3D images) and then a transform will be 
# applied (eg. using ANTS) to get each volume into unfolded space. This one transform should be a combination 
# of i) the linear transforms to coronal oblique (provided using the current Hippocampal_AutoTop), ii) a 
# transform (Jacobian?) from Vxyz to Vuvw, iii) a transform from Vuvw to Vuvw_rp. I don't know how this transform
# should be computed or combined, but it should be in Uzair's code https://github.com/uhussai7/HippoDiffusion.
# I believe this should take the form of a Nifti image, with a 3x3 rotation matrix at each voxel
