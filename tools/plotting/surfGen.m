subs = ls('/kohlerlab/Jordan/Yushkevich_exvivoMRI/Unfolding/*/laplace.mat');
subs = strsplit(subs)';
subs(end) = [];

outdir = '../exVivo_visualize/';

for s = 1:length(subs)

%% remove old weird cropping
load(subs{s});
i = strfind(subs{s},'/');
fID = subs{s}(i(end-1)+1:i(end)-1);
rm = find(Laplace_AP==0 | Laplace_PD==0 | Laplace_IO==0 | Laplace_AP>1 | Laplace_PD>1 | Laplace_IO>1 | isnan(Laplace_AP) | isnan(Laplace_PD) |isnan(Laplace_IO));
Laplace_AP(rm)=[]; Laplace_PD(rm)=[]; Laplace_IO(rm)=[]; idxgm(rm)=[];

lbl = zeros(sz);
lbl(idxgm) = 1;
labelmap = zeros(origsz);
labelmap(cropping==1) = lbl;
idxgm = find(labelmap==1);

[i_L,j_L,k_L]=ind2sub(origsz,idxgm);
APsamp = [1:APres]/(APres+1);
PDsamp = [1:PDres]/(PDres+1);
IOsamp = [1:IOres]/(IOres+1);
[v,u,w] = meshgrid(PDsamp,APsamp,IOsamp); % have to switch AP and PD because matlab sucks
Vuvw = [u(:),v(:),w(:)];

%% interpolate between unfolded and native space

interp='linear';
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
Vmid = reshape(Vmid,[APres*PDres,3]);

% save
mkdir([outdir fID]);
v = Vmid;
v(:,[1 2 3]) = v(:,[2 1 3]);
v(:,1) = v(:,1).*origheader.hdr.dime.pixdim(2) + origheader.hdr.hist.srow_x(end);
v(:,2) = v(:,2).*origheader.hdr.dime.pixdim(3) + origheader.hdr.hist.srow_y(end);
v(:,3) = v(:,3).*origheader.hdr.dime.pixdim(4) + origheader.hdr.hist.srow_z(end);
vtkwrite([outdir fID '/midSurf.vtk'],'polydata','triangle',v(:,1),v(:,2),v(:,3),F);

% plot
load('misc/BigBrain_ManualSubfieldsUnfolded.mat');
subfields_avg = imresize(subfields_avg,0.5,'nearest');
load('../Hippocampal_AutoTop/misc/itkColours.mat');
itkColours = itkColours/255;
itkColours = [0 0 0; itkColours];
p = patch('Faces',F,'Vertices',v,'FaceVertexCData',subfields_avg(:));
p.FaceColor = 'flat';
p.LineStyle = 'none';
axis equal tight off;
material dull;
light;
caxis([0 8]); colormap(itkColours);
saveas(gcf,[outdir fID '/midsurf.png']);
close;

%% try vieweing surface over different resolutions (3DSlicer)

origimg = ['/kohlerlab/Jordan/Yushkevich_exvivoMRI/specimens/' fID '/axis_align/rigid/' fID '_axisalign_img.nii.gz'];
img = load_untouch_nii(origimg);
img.img(img.img<200) = 200; % clean up background
save_untouch_nii(img,[outdir fID '/img_res-0.2.nii.gz']);
for res = [0.3 0.7 1 2 3]
    system(['flirt -in ' outdir fID '/img_res-0.2.nii.gz -ref ' origimg ' '...
        '-applyisoxfm ' num2str(res) ' -out ' outdir fID '/img_res-' num2str(res) '.nii.gz']);
end

end