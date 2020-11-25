%author: Ali Khan
%date: 2020-11-25

function [V, F] = remove_vertices(V, F, inds)
    
    
    for iter = 1:length(inds)
        i = inds(iter);
        %remove the vertex
        V(i,:) = [];
        %remove it from any faces it is connected to:
        F(unique([find(F(:,1)==i);find(F(:,2)==i);find(F(:,3)==i)]),:)=[];
        
        %by removing that index, any indices above need to be decremented
        %including those we are set to remove
        F(F>i) = F(F>i) - 1;
        inds(inds>i) = inds(inds>i) -1;
    end

end
