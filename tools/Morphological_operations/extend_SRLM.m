% extend SRLM over the subiculum

% This portion of the code was used in the original publication, but future
% work will define the (dummy label) SRLM over subiculum separately.

% Finds surfaces (where label 0 and label 1 meet). The largest connected
% surface component is lateral, second largest sits on top of the subiculum
% (and vertical component of the uncus). Relabel this second component with
% a dummy label to be used as source for IO gradient

se = ones(3,3,3);
lbl2 = imresize3(labelmap,3,'nearest');
contour1 = imdilate(lbl2==0,se) & lbl2==1;
CC = bwconncomp(contour1,6);
for c = 1:length(CC.PixelIdxList)
    le(c) = length(CC.PixelIdxList{c});
end
[le,li] = sort(le,'descend');

Xrlm = zeros(size(lbl2));
if length(CC.PixelIdxList) > 1
    for i = 2:length(CC.PixelIdxList)
        Xrlm(CC.PixelIdxList{li(i)}) = 1; % second largest connected contour area
    end
end
Xrlm = imdilate(Xrlm,ones(5,5,5));
Xrlm = imresize3(Xrlm,size(labelmap),'nearest');
labelmap(Xrlm==1 & labelmap==0) = 4;

clear le li CC lbl2 se contour1 Xrlm i