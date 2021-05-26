function plot_foldunfold_rgb(img,FV,smooth,plt_title)

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
    img(all(img==0,3)) = nan;
    img = inpaintn(img);
    
    smoothKernel = fspecial('gaussian',[25 25],3);
    for rgb = 1:3
    img(:,:,rgb) = imfilter(img(:,:,rgb),smoothKernel,'symmetric');
    end
end
img = img/max(img(:));

%% plot!
% figure('units','normalized','outerposition',[0 0 1 1]);
figure;
subplot(1,2,1);
p = patch('Faces',FV.faces,'Vertices',FV.vertices,'FaceVertexCData',reshape(img,[size(img,1)*size(img,2),3]));
p.FaceColor = 'flat';
p.LineStyle = 'none';
material dull;
axis equal off;
% colormap('jet');
light;
title(plt_title);
subplot(1,2,2);
imagesc(img);
axis equal tight off;
% colormap('jet');
% set(gca,'YDir','normal')
% drawnow;
end