function Resample_Native(hippDir,outdir,imgList)
addpath(genpath('/cvmfs/soft.computecanada.ca/easybuild/software/2017/Core/freesurfer/5.3.0/matlab'));
%addpath(genpath('/srv/software/freesurfer/6.0.0/matlab'))

subjects=["01","02","03","04","05"];
morphology=["streamlengths","GI";"thickness","gyrification"];
qmri=["B1";"TOF";"T2w";"T1";"Perfusion";"tSNR"];  
  
% Range for truncating scalars
min_prctile = 3;
max_prctile = 97;

for s=1:size(subjects,2)
    sub=subjects{s};
    hippDir = ['unfolding_autotop/sub-' sub];
    aff = [hippDir '/0GenericAffine.mat'];
    
    % Load affine tranformation compute its inverse
    load(aff, 'AffineTransform_double_3_3');
    itransf = [ 1,-1, 1,-1; ...
               -1, 1, 1,-1; ...
                1, 1, 1, 1; ...
                0, 0, 0, 1];
    transf = reshape(AffineTransform_double_3_3,[3,4]);
    transf(4,1:4) = [0,0,0,1];
    transf = itransf.*transf;
    
    % Path to individual maps to map on HPC mesh (must be coregistered to unfolding input)
    qmri_in={['sri/sub-' sub '/anat_final/*SA2RAGE_b1map*0p3ISO.nii.gz']; ...
             ['sri/sub-' sub '/anat_final/*TOF_AVG_angio*Warped.nii.gz']; ...
             ['sri/sub-' sub '/anat_final/*TSE_AVG_T2w*0p3ISO.nii.gz']; ...
             ['sri/sub-' sub '/anat_final/*hiresMP2RAGE*Warped.nii.gz']; ...
             ['oxford_asl/sub-' sub '/asl_final/*MAP*.nii.gz']; ...
             ['oxford_asl/sub-' sub '/asl_final/*tSNR*.nii.gz']};
    
    % Do for both hemispheres
    for LR = 'LR'
        load([hippDir '/hemi-' LR '/surf.mat']);
        load([hippDir '/hemi-' LR '/unfold.mat']);

        img = load_nifti([hippDir '/hemi-' LR '_img.nii.gz']);
    
        %vtk_in = [hippDir '/hemi-' LR '/midSurf_space-native_hemi-' LR '.vtk'];
        %vtk = read_vtk(vtk_in);
        
        v = Vnative;

        % Map morphology
        smooth=true;
        for i=1:size(morphology,2)
            eval(['img = ',morphology{1,i},';']);
            if smooth % TODO: set adjustable input parameters
                img(isoutlier(img(:))) = nan;
                img = inpaintn(img);
                %smoothKernel = fspecial('gaussian',[25 25],3);
                %img = imfilter(img,smoothKernel,'symmetric');
            end
            img = img(:);
            img(img<prctile(img,min_prctile)) = prctile(img,min_prctile);
            img(img>prctile(img,max_prctile)) = prctile(img,max_prctile);
            scalartype = genvarname(morphology{2,i});
            eval([scalartype '= img;']);
        end

        % Map qMRI
        for i=1:size(qmri)
            in = load_nifti(qmri_in{i});

            for j=1:3
                indices{j} = [0:1:size(in.vol,j)-1];
            end            
            
            [X,Y,Z] = meshgrid(indices{2},indices{1},indices{3});
            vv = inv(in.vox2ras)*v';
            vv = vv';
            out = interp3(X,Y,Z,in.vol,vv(:,2),vv(:,1),vv(:,3));
            out(out<prctile(out,min_prctile)) = prctile(out,min_prctile);
            out(out>prctile(out,max_prctile)) = prctile(out,max_prctile);

            scalartype = genvarname(qmri{i});
            eval([scalartype '= out;']);
        end

        %% Save data
        %v = v';
        vtk_out = [hippDir '/hemi-' LR '/midSurf_space-native_hemi-' LR '_qMRI.vtk'];
        vtkwrite(vtk_out,'polydata','triangle',Vnative(:,1),Vnative(:,2),Vnative(:,3),F, ...
            'scalars','Thickness',thickness, ...
            'scalars','Gyrification',gyrification, ...
            'scalars','B1',B1, ...
            'scalars','TOF',TOF, ...
            'scalars','T2w',T2w, ...
            'scalars','T1',T1, ...
            'scalars','Perfusion',Perfusion, ...
            'scalars','tSNR',tSNR);

%         qmri = zeros(128,256,10);
%         qmri(:,:,1) = fliplr(flipud(reshape(bb,[256,128])')); % BigBrain labels
%         qmri(:,:,2) = fliplr(flipud(reshape(thickness,[256,128])')); % Thickness
%         qmri(:,:,3) = fliplr(flipud(reshape(gyrification,[256,128])')); % GI
%         qmri(:,:,4) = fliplr(flipud(reshape(tse,[256,128])')); % T2w
%         qmri(:,:,5) = fliplr(flipud(reshape(t1,[256,128])')); % T1
%         qmri(:,:,6) = fliplr(flipud(reshape(tof,[256,128])')); % TOF
%         qmri(:,:,7) = fliplr(flipud(reshape(perf,[256,128])')); % Perfusion
%         qmri(:,:,8) = fliplr(flipud(reshape(tsnr,[256,128])')); % tSNR
%         qmri(:,:,9) = fliplr(flipud(reshape(distance,[256,128])')); % Minimum distance
%         qmri(:,:,10) = fliplr(flipud(reshape(diameter,[256,128])')); % Distance

%        save([autotop,'Unfold/',subjects{s},'/',LR,'/qmri.mat'],'qmri');
    end
end

%         %% Vesselness
%         in_vessels = [derivatives,'angiography/',subjects{s},'/anat/visualization/lh/'];
% 
%         % Minimum distance
%         in_distance = load_nifti([in_vessels,'vessel_seg_closest-distance_dil.nii.gz']);
%         distance_vol = in_distance.vol;
% 
%         for i=1:3
%             indices{i} = [0:1:size(distance_vol,i)-1];
%         end
%         [X,Y,Z] = meshgrid(indices{2},indices{1},indices{3});
%         vv = inv(in_distance.vox2ras)*v;
%         vv = vv';
% 
%         distance = interp3(X,Y,Z,distance_vol,vv(:,2),vv(:,1),vv(:,3)); 
% 
%         % Diameter of closest vessel
%         in_diameter = load_nifti([in_vessels,'vessel_seg_closest-diameter_dil.nii.gz']);
%         diameter_vol = in_diameter.vol;    
%         diameter = interp3(X,Y,Z,diameter_vol,vv(:,2),vv(:,1),vv(:,3),'nearest'); 