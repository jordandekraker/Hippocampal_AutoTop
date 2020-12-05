function constrain_surf_to_warp(in_gii,in_ref_nii,out_gii)

    g=gifti(in_gii);

    epsilon=0.01; 
    
    %get warp bounding box
    info=niftiinfo(in_ref_nii);
    
    lower_coord = [0,0,0,1]';
    upper_coord = [info.ImageSize(1:3)-1,1]';
    
    affine = info.Transform.T';
    %get bounds by taking corners of img and getting phys coords
    bounds = [affine*lower_coord,affine*upper_coord];
    %drop the 4-th dim
    bounds = bounds(1:3,:)';
    %and sort from neg to pos in each dim
    bounds = sort(bounds);
    
    %replicate to enable comparison with g.vertices
    minrep = repmat(bounds(1,:),size(g.vertices,1),1) + epsilon;
    maxrep = repmat(bounds(2,:),size(g.vertices,1),1) - epsilon;
    
    %get indices where too low or high
    too_low = find(g.vertices<minrep);
    too_high = find(g.vertices>maxrep);
    fprintf('surface %s:\n',in_gii);
    fprintf('%d vertices below minimum\n',length(too_low));
    fprintf('%d vertices above maximum\n',length(too_high));
    
    %replace with the bounding value
    g.vertices(too_low) = minrep(too_low);
    g.vertices(too_high) = maxrep(too_high);

    %save gifti
    save(g,out_gii,'Base64Binary');


end