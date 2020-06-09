function featureview(f,V,F,sigma,outprefix)

f(isoutlier(f(:))) = nan;

% histogram
figure; %('units','normalized','outerposition',[0 0 0.2 0.2]);
hist(f(:),100);
saveas(gcf,[outprefix '_hist.png']);

% clean up and then plot
f = inpaintn(f);
smoothKernel = fspecial('gaussian',[25 25],sigma);
f = imfilter(f,smoothKernel,'symmetric');

% view in 3D
figure;
p = patch('Faces',F,'Vertices',V,'FaceVertexCData',f(:));
p.FaceColor = 'flat';
p.LineStyle = 'none';
axis equal tight off;
material dull;
light;
colorbar;
saveas(gcf,[outprefix '_3Dsurf-sup.png']);
view([0,-90]); 
light('Position',[-1 -1 -1]);
saveas(gcf,[outprefix '_3Dsurf-inf.png']);

% view unfolded
figure;
hold on;
imagesc(f');
set(gca,'ydir','normal');
axis equal tight off;
load('misc/BigBrain_ManualSubfieldsUnfolded.mat');
subfields_avg = imresize(subfields_avg,0.5,'nearest');
imcontour(subfields_avg','w');
caxis([min(f(:)) max(f(:))]);
colorbar;
saveas(gcf,[outprefix '_flat.png']);

