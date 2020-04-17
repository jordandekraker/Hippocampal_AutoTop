function out = im2col3(I_pad,sz_filt)
%IM2COL3 Summary of this function goes here
%   Detailed explanation goes here
p_a=floor(sz_filt(1)/2);
p_b=floor(sz_filt(2)/2);
p_c=floor(sz_filt(3)/2);

sz_I_pad=size(I_pad);
A=sz_I_pad(1);
B=sz_I_pad(2);
C=sz_I_pad(3);

i_f=A-2*p_a;
j_f=B-2*p_b;
k_f=C-2*p_c;

col_i=1;
for k=1:k_f
    for i=1:i_f
        for j=1:j_f
            i_e=i+2*p_a;
            j_e=j+2*p_b;
            k_e=k+2*p_c;
            extract=I_pad(i:i_e,j:j_e,k:k_e);
            out(:,col_i)=extract(:);
            col_i=col_i+1;
        end
    end
end


end

