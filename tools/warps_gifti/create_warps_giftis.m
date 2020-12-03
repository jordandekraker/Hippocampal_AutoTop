function create_warps_giftis( autotop_folder, warps_folder )
arguments
    autotop_folder string
    warps_folder string
end

    if ( ~exist(warps_folder))
        mkdir(warps_folder)
    end

    %autotop_folder has the regular outputs of hippocampal_autotop

    %generate warps, and template unfolded surfaces
    create_warps(autotop_folder, warps_folder); %args are in_dir, out_dir

    % Note: these giftis are in the template space (ie are not specifically associated with this subject, 
    % but just generated here for convenience)
    create_template_unfold_gifti(warps_folder); 


    extrapolate_warp_unfold2native(warps_folder);

    %this performs ants registration from the unfolded coords-AP to a full grid
    %coords-AP. This is done with smoothed inner and outer labels to ensure the
    %midthickness as accurately mapped

    %get path to script:
    [path,name,ext] = fileparts(mfilename('fullpath'));
    system(sprintf('%s/mapUnfoldToFullGrid.sh %s %s', ... 
                path, ...
                autotop_folder,warps_folder));


end
