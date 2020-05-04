function [smoothedvals] = vtksmooth(vertices,nbrs,vals,niter)
% smooth scalar using surface geometry (across neighbors)
%
% vals is vector with nverts members
% niter is number of iterations (smoothing steps)
%
funcname = 'vtksmooth';

surf.coords = vertices;
surf.nbrs   = nbrs;
surf.nverts = size(vertices,1);

smoothedvals = [];

% if(nargin ~= 3)
%     fprintf('USAGE: [smoothedvals] = %s(surf,vals,niter) \n',funcname);
%     return
% end

vals      = [0;vals]; % create dummy vertex with index 1, value 0
maxnbrs   = size(surf.nbrs,2);
surf.nbrs = [ones(maxnbrs,1)';surf.nbrs + 1]; % nbrs contains zeros, change to 1
num_nbrs  = sum(surf.nbrs>1,2)+1; % including vertex and its neighbors

for iter=1:niter
    tmp  = [vals, vals(surf.nbrs(:,:))]; % sum values from vertex and its neighbors
    vals = sum(tmp,2)./num_nbrs;
end

smoothedvals = vals(2:end);

