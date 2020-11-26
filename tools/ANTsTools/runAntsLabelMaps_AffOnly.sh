#!/bin/bash

in_template_nii=$1
in_target_nii=$2
out_dir=$3

if [ "$#" -lt 3 ]
then
	 echo "Usage: $0 <in_ref_seg_nii> <in_floating_seg_nii> <out_dir>  [optional arguments]"
	 echo ""
	 echo " -r cc_radius (default 3)"
	 echo " -L \"label1 label2 ...\" (labels to extract, default 1)"
	 echo " -W \"weight1 weight2 ...\" (weights for each, default 1)"
	 echo ""

	 exit 1
 fi

 shift 3

convergence_aff="[50x50x50,1e-6,10]"
shrink_factors_aff="8x4x2"
smoothing_sigmas_aff="8x4x2vox"
radiusnbins=3
stepsize=0.25 
labellist=1
weightlist=1
interp=Linear
dim=3
cost=MeanSquares # this seems to work better for binary images

while getopts "r:L:W:" options; do
 case $options in
  r ) echo "CC radius $OPTARG"
	  radiusnbins=$OPTARG;;
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

# ignore missing labels (empty bin, i.e., no non-zero voxels)
v1=$(fslstats $template_bin -V) ; v1=(${v1// / })
v2=$(fslstats $target_bin -V) ; v2=(${v2// / })

if [ "$v1" == "0" ] || [ "$v2" == "0" ] ;
then

echo "skipping label $label"

else

weight=${weightlist[$i]}

echo label: $label
echo weight: $weight

#template is fixed
#target is moving
metric="$metric --metric ${cost}[${template_bin},${target_bin},${weight},${radiusnbins}]"

fi
i=$((i+1))
done


if [ ! -e $out_dir/ants_0GenericAffine.mat ]
then

multires_aff="--convergence $convergence_aff --shrink-factors $shrink_factors_aff --smoothing-sigmas $smoothing_sigmas_aff"
rigid="$multires_aff $metric --transform Rigid[0.1]"
affine="$multires_aff $metric --transform Affine[0.1]"

out="--output [$out_dir/ants_]"

echo antsRegistration -d $dim --interpolation $interp $rigid $affine $out -v
antsRegistration -d $dim --interpolation $interp $rigid $affine $out -v



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
	    -t [$out_dir/ants_0GenericAffine.mat, 1]

	antsApplyTransforms \
	    -d 3 \
	    --interpolation NearestNeighbor \
	    -i $template_bin\
	    -o $warped_template\
	    -r $target_bin\
	    -t [$out_dir/ants_0GenericAffine.mat, 1]

fi

if [ ! -e $warped_target ]
then	  
	echo antsApplyTransforms \
	    -d 3 \
	    --interpolation NearestNeighbor \
	    -i $target_bin\
	    -o $warped_target\
	    -r $template_bin\
	    -t $out_dir/ants_0GenericAffine.mat # removed affine inversion

	antsApplyTransforms \
	    -d 3 \
	    --interpolation NearestNeighbor \
	    -i $target_bin\
	    -o $warped_target\
	    -r $template_bin\
	    -t $out_dir/ants_0GenericAffine.mat # removed affine inversion

fi

done


