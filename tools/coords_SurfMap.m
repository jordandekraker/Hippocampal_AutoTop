function coords_SurfMap(outprefix)

APres = 256; PDres = 128; IOres = 4;


if ~exist([outprefix 'surf.mat'],'file')
%% load unfolded coords

load([outprefix 'unfold.mat']);

rm = find(Laplace_AP==0 | Laplace_PD==0 | Laplace_IO==0 | Laplace_AP>1 | Laplace_PD>1 | Laplace_IO>1 | isnan(Laplace_AP) | isnan(Laplace_PD) |isnan(Laplace_IO));
Laplace_AP(rm)=[]; Laplace_PD(rm)=[]; Laplace_IO(rm)=[]; idxgm(rm)=[];

% smooth gradients?
% s3d = zeros(sz);
% s3d(idxgm) = AP;
% s3d = nanmeanFilter(s3d);
% AP = s3d(idxgm);
% s3d(idxgm) = PD;
% s3d = nanmeanFilter(s3d);
% PD = s3d(idxgm);
% s3d(idxgm) = IO;
% s3d = nanmeanFilter(s3d);
% IO = s3d(idxgm);
% rm = find(isnan(AP) | isnan(PD) | isnan(IO));
% AP(rm)=[]; PD(rm)=[]; IO(rm)=[]; idxgm(rm)=[];

[i_L,j_L,k_L]=ind2sub(sz,idxgm);
APsamp = [1:APres]/(APres+1);
PDsamp = [1:PDres]/(PDres+1);
IOsamp = [1:IOres]/(IOres+1);
[v,u,w] = meshgrid(PDsamp,APsamp,IOsamp); % have to switch AP and PD because matlab sucks
Vuvw = [u(:),v(:),w(:)];

%% interpolate between unfolded and native space

interp='natural';
extrap='nearest';
scattInterp=scatteredInterpolant(Laplace_AP,Laplace_PD,Laplace_IO,i_L,interp,extrap);
x = scattInterp(Vuvw(:,1),Vuvw(:,2),Vuvw(:,3));
scattInterp=scatteredInterpolant(Laplace_AP,Laplace_PD,Laplace_IO,j_L,interp,extrap);
y = scattInterp(Vuvw(:,1),Vuvw(:,2),Vuvw(:,3));
scattInterp=scatteredInterpolant(Laplace_AP,Laplace_PD,Laplace_IO,k_L,interp,extrap);
z = scattInterp(Vuvw(:,1),Vuvw(:,2),Vuvw(:,3));
clear scattInterp
Vxyz = [x(:) y(:) z(:)];

%% get midpoint surface

% get face connectivity
t = [1:(APres*PDres)]';
F = [t,t+1,t+(APres) ; t,t-1,t-(APres)];
F = reshape(F',[3,APres,PDres,2]);
F(:,APres,:,1) = nan;
F(:,1,:,2) = nan;
F(:,:,PDres,1) = nan;
F(:,:,1,2) = nan;
F(isnan(F)) = [];
F=reshape(F,[3,(APres-1)*(PDres-1)*2])';

% get midpoint vertices
Vmid = reshape(Vxyz,[APres,PDres,IOres,3]);
Vmid = squeeze(Vmid(:,:,ceil(IOres/2),:));
% smooth using Cosine Representation
% Vrec = CosineRep_2Dsurf(Vmid,64,0.005); 
% t = ~ismember(round(Vrec),[i_L,j_L,k_L]);
% Vrec(t) = nan;


%% Gyrification Index

for PD=1:PDres-1
    for AP=1:APres-1
        arcPD(AP,PD) = norm(squeeze(squeeze(Vmid(AP,PD,:)-Vmid(AP,PD+1,:))));
        arcAP(AP,PD) = norm(squeeze(squeeze(Vmid(AP,PD,:)-Vmid(AP+1,PD,:))));
    end
end
GI = imresize(arcAP.^2+arcPD.^2,[APres,PDres]);

%% Thickness measures 

voxelsize = origheader.hdr.dime.pixdim(2); %mm, isotropic
threshold = [0.1 4.0]; %min and max thicknesses in mm
stepsize = 0.1;
maxvert = threshold(2)/voxelsize/stepsize;

start = reshape(Vmid,[APres*PDres,3]);
start(isnan(start)) = 0;

% midpoint to outside
Space3d = ones(sz);
Space3d(idxgm) = Laplace_IO;
[dx,dy,dz]=gradient(Space3d);
clear Space3d
streams = stream3(dx,dy,dz,start(:,2),start(:,1),start(:,3),[stepsize,maxvert]); %switch dims 1 and 2 because matlab is dumb
clear dx dy dz
for n = 1:length(streams)
    streamlengths1(n) = stepsize*voxelsize*size(streams{n},1);
end
clear streams

% midpoint to inside
Space3d = ones(sz);
Space3d(idxgm) = -Laplace_IO+1;
[dx,dy,dz]=gradient(Space3d);
clear Space3d
streams = stream3(dx,dy,dz,start(:,2),start(:,1),start(:,3),[stepsize,maxvert]); %switch dims 1 and 2 because matlab is dumb
clear dx dy dz
for n = 1:length(streams)
    streamlengths2(n) = stepsize*voxelsize*size(streams{n},1);
end
clear streams

% combine and delete bad streams
streamlengths = streamlengths1 + streamlengths2;
bad = (streamlengths>=threshold(2) | streamlengths<=threshold(1));
streamlengths(bad) = nan;

streamlengths = reshape(streamlengths,[APres,PDres]);

%% Intensity map

try
    T2w = ls([outprefix 'img.nii.gz']);
    T2w(end) = [];
    T2w = load_untouch_nii(T2w);
    t = round(reshape(Vmid,[APres*PDres,3]));
    for tt = 1:length(t)
        qMap(tt) = T2w.img(t(tt,1),t(tt,2),t(tt,3));
    end
    qMap = reshape(qMap,[APres,PDres]);
catch
    warning('No MRI image found. Skipping quantitative sampling');
end

%% write Vmid .vtk file
v = reshape(Vmid,[APres*PDres,3]);
% apply qform or sform from cropped nifti header
if origheader.hdr.hist.sform_code>0
    sform = [origheader.hdr.hist.srow_x;...
        origheader.hdr.hist.srow_y;...
        origheader.hdr.hist.srow_z;...
        0 0 0 1];
    v = sform*[v'; ones(1,length(v))];
elseif origheader.hdr.hist.qform_code>0
    qform = [origheader.hdr.dime.pixdim(2) 0 0 origheader.hdr.hist.qoffset_x;...
            0 origheader.hdr.dime.pixdim(3) 0 origheader.hdr.hist.qoffset_y;...
            0 0 origheader.hdr.dime.pixdim(4)  origheader.hdr.hist.qoffset_z;...
            0 0 0 1];
    v = qform*[v'; ones(1,length(v))];
else
    warning('could not read nifti qform or sform for transforming .vtk midsurface');
end
vtkwrite([outprefix 'midSurf.vtk'],'polydata','triangle',v(:,1),v(:,2),v(:,3),F);

%% clean up and save

clearvars x y z u v w t i_L j_L k_L  i ii extrap interp
clearvars -except outprefix APres PDres IOres Vxyz Vuvw Vmid Vrec F...
    idxgm img lbl sz GI streamlengths qMap
save([outprefix 'surf.mat']);
end
