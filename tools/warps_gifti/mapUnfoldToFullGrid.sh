#!/bin/bash

execpath=`dirname $0`
execpath=`realpath $execpath`

#this script performs registration between unfolded subj coords, and the full reference grid coords
# it creates the ref grid coords, and pads all the images for the registration 

in_dir=$1
out_dir=$2

if [ "$#" -lt 2 ]
then
    echo "Usage: $0 in_dir out_dir"
    exit 1
fi

#when padding:
fill_val=-1

pad_cmd="-pad 32x32x32vox 32x32x32vox $fill_val"


N_AP=256
N_PD=128
N_IO=16


in_unfold_ref=${execpath}/../../misc/unfold_ref_256x128x16.nii.gz
in_warpitk_native2unfold=${in_dir}/WarpITK_native2unfold.nii
out_norm_coords=${out_dir}/unfold_norm_coords.nii

convergence="[200x200x200,1e-6,10]"
shrink_factors="4x2x1"
smoothing_sigmas="0x0x0" # no smoothing to avoid blurring bgnd
stepsize=0.25 
updatefield=3 
totalfield=0
interp=NearestNeighbor #using nearest neighbour to avoid interpolation with bgnd
dim=3
cost=MeanSquares # this seems to work better for binary images

norm_AP=`echo "scale=6; 1/(${N_AP}-1)" | bc`
norm_PD=`echo "scale=6; 1/(${N_PD}-1)" | bc`
norm_IO=`echo "scale=6; 1/(${N_IO}-1)" | bc`


#create normalized coords image:
echo c3d $in_unfold_ref -cmv -popas IO -popas PD -popas AP -push AP -scale $norm_AP -push PD -scale $norm_PD -push IO -scale $norm_IO -omc $out_norm_coords
c3d $in_unfold_ref -cmv -popas IO -popas PD -popas AP -push AP -scale $norm_AP -push PD -scale $norm_PD -push IO -scale $norm_IO -omc $out_norm_coords

#unfold the coords
for C in AP PD IO
do 
 echo antsApplyTransforms -d 3 -r ${in_warpitk_native2unfold} -i ${in_dir}/coords-$C.nii.gz -t ${in_warpitk_native2unfold} -n NearestNeighbor -o ${out_dir}/coords-${C}_unfold.nii
 antsApplyTransforms -d 3 -r ${in_warpitk_native2unfold} -i ${in_dir}/coords-$C.nii.gz -t ${in_warpitk_native2unfold} -n NearestNeighbor -o ${out_dir}/coords-${C}_unfold.nii
done

#pad the unfolded images
for  C in AP PD IO
do
echo c3d  ${out_dir}/coords-${C}_unfold.nii $pad_cmd -replace 0 ${fill_val} -o ${out_dir}/coords-${C}_unfold_pad.nii
c3d  ${out_dir}/coords-${C}_unfold.nii $pad_cmd -replace 0 ${fill_val} -o ${out_dir}/coords-${C}_unfold_pad.nii
done


#create fullgrid padded images
echo c3d -mcs  ${out_norm_coords} -popas ZI -popas YI -popas XI -push XI $pad_cmd -o ${out_dir}/fullgrid-AP.nii  -push YI  $pad_cmd -o ${out_dir}/fullgrid-PD.nii -push ZI  $pad_cmd -o ${out_dir}/fullgrid-IO.nii
c3d -mcs  ${out_norm_coords} -popas ZI -popas YI -popas XI -push XI $pad_cmd -o ${out_dir}/fullgrid-AP.nii  -push YI  $pad_cmd -o ${out_dir}/fullgrid-PD.nii -push ZI  $pad_cmd -o ${out_dir}/fullgrid-IO.nii


#create mask to restrict to inside coords - not currently used
#coord_mask=${out_dir}/coords_mask.nii
#fullgrid_mask=${out_dir}/fullgrid_mask.nii
#c3d coords-AP_unfold_pad.nii -threshold 0 1 1 0 -o $coord_mask
#c3d fullgrid-AP.nii -threshold 0 1 1 0 -o $fullgrid_mask


#we want a mapping specifically from midthickness subj to full grid midthickness
# so we can binarize at 0.5 to explicitly enforce this
for C in IO 
do

smoothing=2x2x2vox
#create segs binarized at half coord iin subject
c3d $out_dir/coords-${C}_unfold_pad.nii  -threshold 0 0.5 1 0 -smooth $smoothing  -o $out_dir/coords-${C}_unfold_pad_inner_smoothed.nii 
c3d $out_dir/coords-${C}_unfold_pad.nii -threshold 0.5 1 1 0 -smooth $smoothing -o $out_dir/coords-${C}_unfold_pad_outer_smoothed.nii 


c3d $out_dir/fullgrid-${C}.nii -threshold 0 0.5 1 0 -smooth $smoothing -o $out_dir/fullgrid-${C}_inner_smoothed.nii 
c3d $out_dir/fullgrid-${C}.nii -threshold 0.5 1 1 0 -smooth $smoothing -o $out_dir/fullgrid-${C}_outer_smoothed.nii 

done

stages=""
for C in IO 
do
    metric="--metric ${cost}[${out_dir}/fullgrid-${C}_inner_smoothed.nii,${out_dir}/coords-${C}_unfold_pad_inner_smoothed.nii,1]"
    metric="${metric} --metric ${cost}[${out_dir}/fullgrid-${C}_outer_smoothed.nii,${out_dir}/coords-${C}_unfold_pad_outer_smoothed.nii,1]"
    multires="--convergence $convergence --shrink-factors $shrink_factors --smoothing-sigmas $smoothing_sigmas"
    syn="--transform SyN[${stepsize},$updatefield,$totalfield]"
    stages="$stages $metric $multires $syn"
done

warp_name=unfold2unfoldtemplate

out="--output [$out_dir/WarpITK_${warp_name}_]"

echo antsRegistration -d $dim --interpolation $interp $stages $out -v
antsRegistration -d $dim --interpolation $interp $stages $out -v



#--- wb_command required below: 


#convert to world warps 
echo wb_command -convert-warpfield -from-itk ${out_dir}/WarpITK_${warp_name}_0Warp.nii.gz -to-world ${out_dir}/Warp_unfoldtemplate2unfold.nii
wb_command -convert-warpfield -from-itk ${out_dir}/WarpITK_${warp_name}_0Warp.nii.gz -to-world ${out_dir}/Warp_unfoldtemplate2unfold.nii
echo wb_command -convert-warpfield -from-itk ${out_dir}/WarpITK_${warp_name}_0InverseWarp.nii.gz -to-world ${out_dir}/Warp_unfold2unfoldtemplate.nii
wb_command -convert-warpfield -from-itk ${out_dir}/WarpITK_${warp_name}_0InverseWarp.nii.gz -to-world ${out_dir}/Warp_unfold2unfoldtemplate.nii

for surf in midthickness inner outer
do
#transform surfaces
echo wb_command -surface-apply-warpfield ${out_dir}/$surf.unfoldedtemplate.surf.gii ${out_dir}/Warp_unfoldtemplate2unfold.nii ${out_dir}/$surf.unfolded.surf.gii
wb_command -surface-apply-warpfield ${out_dir}/$surf.unfoldedtemplate.surf.gii ${out_dir}/Warp_unfoldtemplate2unfold.nii ${out_dir}/$surf.unfolded.surf.gii
echo wb_command -surface-apply-warpfield ${out_dir}/$surf.unfolded.surf.gii ${out_dir}/Warp_unfold2native_extrapolateNearest.nii ${out_dir}/$surf.native.surf.gii 
wb_command -surface-apply-warpfield ${out_dir}/$surf.unfolded.surf.gii ${out_dir}/Warp_unfold2native_extrapolateNearest.nii ${out_dir}/$surf.native.surf.gii 
mris_convert ${surf}.native.surf.gii ${surf}.native.surf.vtk; mv rh.${surf}.native.surf.vtk ${surf}.native.surf.vtk

done

#transform image to evaluate reg
for C in AP PD IO
do
    echo antsApplyTransforms -d 3 -f -1 -r ${out_dir}/coords-${C}_unfold.nii -i ${out_dir}/coords-${C}_unfold.nii -n NearestNeighbor -t ${out_dir}/WarpITK_${warp_name}_0Warp.nii.gz -o ${out_dir}/coords-${C}_unfoldtemplate.nii
    antsApplyTransforms -d 3 -f -1 -r ${out_dir}/coords-${C}_unfold.nii -i ${out_dir}/coords-${C}_unfold.nii -n NearestNeighbor -t ${out_dir}/WarpITK_${warp_name}_0Warp.nii.gz -o ${out_dir}/coords-${C}_unfoldtemplate.nii

done
