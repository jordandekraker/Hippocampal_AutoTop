#!/bin/bash

in_template_nii=$1
in_target_nii=$2
out_dir=$3

if [ "$#" -lt 3 ]
then
	 echo "Usage: $0 <in_ref_seg_nii> <in_floating_seg_nii> <out_dir>  [optional arguments]"
	 echo ""
	 echo " -r cc_radius (default 3)"
	 echo " -C specify cost (default CC)"
	 echo " -N specify custom output filename"
	 echo " -i interpolation method (Linear, NearestNeighbor)"
	 echo ""

	 exit 1
 fi

 shift 3

tp=${in_template_nii##*/} # remove path template
tp=${tp%.nii.gz} # remove extension template
tg=${in_target_nii##*/} # remove path target
tg=${tg%.nii.gz} # remove extension target
out_fn=$tp'_space-'$tg # combine names

convergence_aff="[100x50x50,1e-5,10]"
shrink_factors_aff="4x2x1"
smoothing_sigmas_aff="4x2x1vox"
radiusnbins=3
interp=Linear
dim=3
cost=MeanSquares # MeanSquares is faster than CC, could we use that?

while getopts "r:C:N:i:" options; do
 case $options in
  r ) echo "CC radius $OPTARG"
	  radiusnbins=$OPTARG;;
  C ) echo "Coust Function $OPTARG"
	  cost=$OPTARG;;
  N ) echo "Custom output filename $OPTARG"
	  out_fn=$OPTARG;;
  i ) echo "Interpolation $OPTARG"
	  interp=$OPTARG;;
    * ) usage
	exit 1;;
 esac
done

mkdir -p $out_dir

#template is fixed
#target is moving
metric="--metric ${cost}[${in_template_nii},${in_target_nii},1,${radiusnbins}]"
multires_aff="--convergence $convergence_aff --shrink-factors $shrink_factors_aff --smoothing-sigmas $smoothing_sigmas_aff"
rigid="$multires_aff $metric --transform Rigid[0.1]"
affine="$multires_aff $metric --transform Affine[0.1]"

out="--output $out_dir" #$out_fn]"

echo antsRegistration -d $dim --interpolation $interp $rigid $affine $out -v
antsRegistration -d $dim --interpolation $interp $rigid $affine $out -v

echo antsApplyTransforms -d $dim --interpolation $interp -i $in_target_nii -r  $in_template_nii -o $out_dir/orig_space-atlas.nii.gz -t $out_dir/0GenericAffine.mat
antsApplyTransforms -d $dim --interpolation $interp -i $in_target_nii -r  $in_template_nii -o $out_dir/orig_space-atlas.nii.gz -t $out_dir/0GenericAffine.mat

