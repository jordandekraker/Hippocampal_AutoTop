function [LP, iter_change] = laplace_iters(fg,source,sink,init,maxiters,sz)

change_threshold = 10^(-3);

%filter set-up (26 nearest neighbours)
% hl=ones(3,3,3);
% hl = hl/26; hl(2,2,2) = 0;
% filter set-up (6 NN) (safer, especially in cases of coronal non-oblique
% where dark band is more likely to 'leak' across diagonals
hl=zeros(3,3,3);
hl(2,:,:) = 1; 
hl(:,2,:) = 1; 
hl(:,:,2) = 1; 
hl(2,2,2) = 0;
hl = hl/sum(hl(:)); 


elems = 1: sz(1)*sz(2)*sz(3);

%set up all requisite variables
vel = nan(sz);
vel(fg)=init;
vel(source)=0;
vel(sink)=1;
bg = (setdiff(elems,sort([fg;source;sink])))'; % bg in indices
vel(bg)=0; %must be insulated after filtering
iter_change = zeros(1,maxiters);
insulate_correction = zeros(sz); 
insulate_correction([fg;source;sink]) = 1;
insulate_correction = imfilter(insulate_correction,hl,'replicate','conv');

% apply filter
iters = 0;
while iters < maxiters %max iterations
    iters = iters+1;
    
    velup = imfilter(vel,hl,'replicate','conv'); %apply averaging filter
    
    %insulate the grey matter so gradient doesn't pass between folds -
    %inspired by ndnanfilter
    velup = velup./insulate_correction;
    velup(bg) = 0;
    velup(source) = 0;
    velup(sink) = 1;
    
    %stopping condition
    iter_change(iters) = nansum(abs(vel(fg)-velup(fg))); %compute change from last iteration
    vel = velup;
    if iter_change(iters)<change_threshold
        break
    end
end
vel = vel./max(vel(:));
vel(~fg) = nan;
LP = vel;
end