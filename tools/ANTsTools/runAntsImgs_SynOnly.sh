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
	 echo " -N specify custom output filename"
	 echo " -s SyN_stepsize (default 0.1)"
	 echo " -u SyN_updatefieldsigma (default 3)"
	 echo " -t SyN_totalfieldsigma (default 0)"
	 echo " -i interpolation method (Linear, NearestNeighbor"
	 echo ""

	 exit 1
 fi

 shift 4


convergence="[200,1e-6,10]"
shrink_factors="1"
smoothing_sigmas="0.5vox" # cannot exceed 8vox (hard-coded limit in ANTS)
radiusnbins=3
stepsize=0.25 
updatefield=3 # fluid deformation. 10 is quite high fluidity
totalfield=1 # elastic deformation
labellist=1
weightlist=1
interp=Linear
dim=3
cost=MeanSquares # this seems to work better for binary images

while getopts "r:N:s:u:t:i:" options; do
 case $options in
  r ) echo "CC radius $OPTARG"
	  radiusnbins=$OPTARG;;
  N ) echo "Custom output filename $OPTARG"
	  out_fn=$OPTARG;;
  s ) echo "SyN stepsize $OPTARG"
	  stepsize=$OPTARG;;
  u ) echo "SyN update field sigma $OPTARG"
	  updatefield=$OPTARG;;
  t ) echo "SyN total field sigma $OPTARG"
	  totalfield=$OPTARG;;
  L ) echo "Interpolation $OPTARG"
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
multires="--convergence $convergence --shrink-factors $shrink_factors --smoothing-sigmas $smoothing_sigmas"
syn="$multires $metric --transform SyN[${stepsize},$updatefield,$totalfield]"

out="--output [$out_dir/ants_]"

echo antsRegistration -d $dim --interpolation $interp -r $in_affine $syn $out -v
antsRegistration -d $dim --interpolation $interp -r $in_affine $syn $out -v

