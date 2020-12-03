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
Xrlm(CC.PixelIdxList{li(2)}) = 1; % second largest connected contour area
Xrlm = imdilate(Xrlm,ones(5,5,5));
Xrlm = imresize3(Xrlm,size(labelmap),'nearest');
labelmap(Xrlm==1 & labelmap==0) = 4;
