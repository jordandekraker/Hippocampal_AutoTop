#!/bin/bash

#this requires neuroglia-helpers 

in_surf=$1
in_ants_dir=$2
out_surf_dir=$3

if [ "$#" -lt 3 ]
then
	 echo "Usage: $0 <in_surf (leave out _V.csv or _F.csv)> <in_ants_warp_dir> <out_surf>"
	 exit 1
 fi


vert_csv=$in_surf\_V.csv
tri_csv=$in_surf\_F.csv

warped_vert_csv=$in_ants_dir/warped_vertices.csv
warped_vtk=$in_ants_dir/warped_polydata.vtk

if [ ! -e $warped_vert_csv ]
then	
antsApplyTransformsToPoints \
            -d 3 \
	    -i $vert_csv\
	    -o $warped_vert_csv\
	    -t $in_ants_dir/ants_1Warp.nii.gz  \
	    -t $in_ants_dir/ants_0GenericAffine.mat 
fi



if [ ! -e $warped_vtk ]
then
echo "csvToVTK('$warped_vert_csv','$tri_csv','$warped_vtk')" |  matlab  
fi

done

