function plot_foldunfold(img,FV,smooth,plt_title)

% plots unfolded features or labels in unfolded and native space (with
% smoothing, windowing, and outlier removal)

if ~exist('smooth','var')
    smooth = false;
end
if ~exist('plt_title','var')
    plt_title = '';
end

if smooth % TODO: set adjustable input parameters
    img(isoutlier(img(:))) = nan;
    img = inpaintn(img);
    smoothKernel = fspecial('gaussian',[25 25],3);
    img = imfilter(img,smoothKernel,'symmetric');
end

% set 95% colourmap window
t = sort(img(:));
t(isnan(t)) = [];
window = [t(round(length(t)*.05)) t(round(length(t)*.95))];

%% plot!
figure('units','normalized','outerposition',[0 0 1 1]);

subplot(1,2,1);
p = patch('Faces',FV.faces,'Vertices',FV.vertices,'FaceVertexCData',img(:));
p.FaceColor = 'flat';
p.LineStyle = 'none';
axis equal tight;
% colormap('jet');
light;
caxis(window);
subplot(1,2,2);
imagesc(img');
title(plt_title);
axis equal tight;
% colormap('jet');
set(gca,'YDir','normal')
caxis(window);
colorbar;
% drawnow;
end