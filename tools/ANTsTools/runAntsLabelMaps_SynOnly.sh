#!/bin/bash

in_template_nii=$1
in_target_nii=$2
in_affine=$3
out_dir=$4

if [ "$#" -lt 4 ]
then
	 echo "Usage: $0 <in_ref_seg_nii> <in_floating_seg_nii> <in_affine> <out_dir>  [optional arguments]"
	 echo ""
	 echo " -r cc_radius (default 3)"
	 echo " -s SyN_stepsize (default 0.25)"
	 echo " -u SyN_updatefieldsigma (fluid deformation)"
	 echo " -t SyN_totalfieldsigma (elastic deformation) (default 0)"
	 echo " -L \"label1 label2 ...\" (labels to extract, default 1)"
	 echo " -W \"weight1 weight2 ...\" (weights for each, default 1)"
	 echo " Note: if specifying multiple labels, you must specify weights"
	 echo ""

	 exit 1
 fi

 shift 4

convergence="[500x250x100,1e-6,50]"
shrink_factors="4x2x1"
smoothing_sigmas="4x2x1vox" # cannot exceed 8vox (hard-coded limit in ANTS)
radiusnbins=3
stepsize=0.1 
updatefield=5 # fluid deformation (default 3)
totalfield=0 # elastic deformation
labellist=1
weightlist=1
interp=Linear
dim=3
cost=MeanSquares # this seems to work better for binary images

while getopts "r:s:u:t:L:W:" options; do
 case $options in
  r ) echo "CC radius $OPTARG"
	  radiusnbins=$OPTARG;;
  s ) echo "SyN stepsize $OPTARG"
	  stepsize=$OPTARG;;
  u ) echo "SyN update field sigma $OPTARG"
	  updatefield=$OPTARG;;
  t ) echo "SyN total field sigma $OPTARG"
	  totalfield=$OPTARG;;
  L ) echo "Extracting labels $OPTARG"
	  labellist=$OPTARG;;
  W ) echo "Weighting labels $OPTARG"
	  weightlist=$OPTARG;;
    * ) usage
	exit 1;;
 esac
done

weightlist=($weightlist) # must be made indexable
mkdir -p $out_dir


metric=""
i=0
for label in $labellist

do
weight=${weightlist[$i]}
	echo label: $label
	echo weight: $weight
	template_bin=$out_dir/template_label-$label.nii.gz
	target_bin=$out_dir/target_label-$label.nii.gz



if [ ! -e $template_bin ]
then
echo fslmaths $in_template_nii -thr $label -uthr $label -bin $template_bin
fslmaths $in_template_nii -thr $label -uthr $label -bin $template_bin
fi

if [ ! -e $target_bin ]
then
echo fslmaths $in_target_nii -thr $label -uthr $label -bin $target_bin
fslmaths $in_target_nii -thr $label -uthr $label -bin $target_bin
fi

#template is fixed
#target is moving
metric="$metric --metric ${cost}[${template_bin},${target_bin},${weight},${radiusnbins}]"

i=$((i+1))
done


if [ ! -e $out_dir/ants_1Warp.nii.gz ]
then

multires="--convergence $convergence --shrink-factors $shrink_factors --smoothing-sigmas $smoothing_sigmas"
syn="$multires $metric --transform SyN[${stepsize},$updatefield,$totalfield]"

out="--output [$out_dir/ants_]"

echo antsRegistration -d $dim --interpolation $interp -r $in_affine $syn $out -v
antsRegistration -d $dim --interpolation $interp -r $in_affine $syn $out -v



fi


for label in $labellist
do
	echo label: $label
	template_bin=$out_dir/template_label-$label.nii.gz
	target_bin=$out_dir/target_label-$label.nii.gz

	warped_target=$out_dir/target_label-${label}_warped.nii.gz
	warped_template=$out_dir/template_label-${label}_warped.nii.gz

if [ ! -e $warped_template ]
then	  
	echo antsApplyTransforms \
	    -d 3 \
	    --interpolation NearestNeighbor \
	    -i $template_bin\
	    -o $warped_template\
	    -r $target_bin\
	    -t [$out_dir/ants_0GenericAffine.mat, 1] \
	    -t $out_dir/ants_1InverseWarp.nii.gz 

	antsApplyTransforms \
	    -d 3 \
	    --interpolation NearestNeighbor \
	    -i $template_bin\
	    -o $warped_template\
	    -r $target_bin\
	    -t [$out_dir/ants_0GenericAffine.mat, 1] \
	    -t $out_dir/ants_1InverseWarp.nii.gz 

fi

if [ ! -e $warped_target ]
then	  
	echo antsApplyTransforms \
	    -d 3 \
	    --interpolation NearestNeighbor \
	    -i $target_bin\
	    -o $warped_target\
	    -r $template_bin\
	    -t $out_dir/ants_1Warp.nii.gz \
	    -t $out_dir/ants_0GenericAffine.mat # removed affine inversion

	antsApplyTransforms \
	    -d 3 \
	    --interpolation NearestNeighbor \
	    -i $target_bin\
	    -o $warped_target\
	    -r $template_bin\
	    -t $out_dir/ants_1Warp.nii.gz \
	    -t $out_dir/ants_0GenericAffine.mat # removed affine inversion

fi

done


