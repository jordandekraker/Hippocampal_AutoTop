function overlayplot(img,overlay,slices,outprefix,alpha)
% slices: must contain nx3 slice numbers with 0s at all locations except
% the desired slice direction. n is the number of slices.
if ~exist('alpha','var')
    alpha = 1;
end

cmap = 'parula';

sz = size(img);

%%
for s = 1:size(slices,1)
    
    if slices(s,1) == 0
        sagSlice = 1:sz(1);
    else
        sagSlice = slices(s,1);
    end
    if slices(s,2) == 0
        corSlice = 1:sz(2);
    else
        corSlice = slices(s,2);
    end
    if slices(s,3) == 0
        axSlice = 1:sz(3);
    else
        axSlice = slices(s,3);
    end
    
    %%
    
    alpha3d = zeros(sz);
    alpha3d(overlay~=0) = alpha;
    
    % set 95% colourmap window
    t = sort(img(:));
    t(isnan(t)) = [];
    window = [t(round(length(t)*.05)) t(round(length(t)*.95))];
    
    figure;
    imagesc(squeeze(img(sagSlice,corSlice,axSlice))');
    colormap('gray');
    caxis(window);
    set(gca,'ydir','normal');
    axis equal tight off;
    saveas(gcf,sprintf('%s_slice_%03d_img.png',outprefix,s));
    
    % figure with overlay
    f1 = figure;
    h1 = axes;
    t2 = imagesc(squeeze(img(sagSlice,corSlice,axSlice))');
    colormap(h1,'gray');
    caxis(window);
    set(h1,'ydir','normal');
    axis equal tight off;
    h2 = axes;
    ap = imagesc(squeeze(overlay(sagSlice,corSlice,axSlice))',...
        'alphadata',squeeze(alpha3d(sagSlice,corSlice,axSlice))');
    caxis(h2,[min(overlay(:)) max(overlay(:))]);
    set(h2,'color','none','visible','off')
    colormap(h2,cmap);
    set(h2,'ydir','normal');
    linkaxes([h1 h2]);
    axis equal tight off;
    saveas(gcf,sprintf('%s_slice_%03d_overlay.png',outprefix,s));
end
