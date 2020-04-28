function [smooDists] = CreateSmoothDistanceMaps(Vxyz,rsFactor)

%create smooth distance maps
X=Vxyz(:,:,:,1);
Y=Vxyz(:,:,:,2);
Z=Vxyz(:,:,:,3);
% downsample (save memory, and will smooth after anyway)
X = imresize(X,rsFactor);
Y = imresize(Y,rsFactor);
Z = imresize(Z,rsFactor);

%calculate the distance maps
sz_block=size(X);
%distance_u=zeros(sz_block(1)-1,sz_block(2)-1,sz_block(3)-1);
distance_u=NaN(sz_block);
distance_v=distance_u;
distance_w=distance_u;
for wi=1:(sz_block(3))
    for vi=1:(sz_block(2))
        for ui=1:(sz_block(1))
            X_c=X(ui,vi,wi);
            Y_c=Y(ui,vi,wi);
            Z_c=Z(ui,vi,wi);
            if(ui~=sz_block(1))
                Xp1_c=X(ui+1,vi,wi);
                Yp1_c=Y(ui+1,vi,wi);
                Zp1_c=Z(ui+1,vi,wi);
                diff_X=Xp1_c-X_c;
                diff_Y=Yp1_c-Y_c;
                diff_Z=Zp1_c-Z_c;
                distance_u(ui,vi,wi)=sqrt(diff_X*diff_X+diff_Y*diff_Y+diff_Z*diff_Z);
            else
                Xp1_c=X(ui-1,vi,wi);
                Yp1_c=Y(ui-1,vi,wi);
                Zp1_c=Z(ui-1,vi,wi);
                diff_X=Xp1_c-X_c;
                diff_Y=Yp1_c-Y_c;
                diff_Z=Zp1_c-Z_c;
                distance_u(ui,vi,wi)=sqrt(diff_X*diff_X+diff_Y*diff_Y+diff_Z*diff_Z);
            end
            if(vi~=sz_block(2))
                Xp1_c=X(ui,vi+1,wi);
                Yp1_c=Y(ui,vi+1,wi);
                Zp1_c=Z(ui,vi+1,wi);
                diff_X=Xp1_c-X_c;
                diff_Y=Yp1_c-Y_c;
                diff_Z=Zp1_c-Z_c;
                distance_v(ui,vi,wi)=sqrt(diff_X*diff_X+diff_Y*diff_Y+diff_Z*diff_Z);
            else
                Xp1_c=X(ui,vi-1,wi);
                Yp1_c=Y(ui,vi-1,wi);
                Zp1_c=Z(ui,vi-1,wi);
                diff_X=Xp1_c-X_c;
                diff_Y=Yp1_c-Y_c;
                diff_Z=Zp1_c-Z_c;
                distance_v(ui,vi,wi)=sqrt(diff_X*diff_X+diff_Y*diff_Y+diff_Z*diff_Z);
            end
            if(wi~=sz_block(3))
                Xp1_c=X(ui,vi,wi+1);
                Yp1_c=Y(ui,vi,wi+1);
                Zp1_c=Z(ui,vi,wi+1);
                diff_X=Xp1_c-X_c;
                diff_Y=Yp1_c-Y_c;
                diff_Z=Zp1_c-Z_c;
                distance_w(ui,vi,wi)=sqrt(diff_X*diff_X+diff_Y*diff_Y+diff_Z*diff_Z);
            else
                Xp1_c=X(ui,vi,wi-1);
                Yp1_c=Y(ui,vi,wi-1);
                Zp1_c=Z(ui,vi,wi-1);
                diff_X=Xp1_c-X_c;
                diff_Y=Yp1_c-Y_c;
                diff_Z=Zp1_c-Z_c;
                distance_w(ui,vi,wi)=sqrt(diff_X*diff_X+diff_Y*diff_Y+diff_Z*diff_Z);
            end
        end
    end
end

% smooth out the distance maps
sz_filt_uv=25;
sz_filt_w=3;
sigma_uv=4.0*rsFactor;
sigma_w=0.75*rsFactor;

ind_filter_uv=-floor(sz_filt_uv/2):floor(sz_filt_uv/2);
ind_filter_w=-floor(sz_filt_w/2):floor(sz_filt_w/2);
[P Q R]=meshgrid(ind_filter_uv,ind_filter_uv,ind_filter_w);
h=exp(-(P.^2 + Q.^2) / (2*sigma_uv*sigma_uv)-R.^2/(2*sigma_w*sigma_w));

distance_u=smoo3(distance_u,h,sz_filt_uv,sz_filt_w);
distance_v=smoo3(distance_v,h,sz_filt_uv,sz_filt_w);
distance_w=smoo3(distance_w,h,sz_filt_uv,sz_filt_w);

%make a mask
%mask=isnan(distance_u)==1;
mask=isnan(X)==1;


%cumulate the sums and make u=0.5,v=0.5,w=0.5 the origin of tilde space
distance_sum_u=cumsum(distance_u,1,'omitnan');
distance_sum_v=cumsum(distance_v,2,'omitnan');
distance_sum_w=cumsum(distance_w,3,'omitnan');

clear smoo_distance_u smoo_distance_v smoo_distance_w;
clear distance_u distance_v distance_w

halfu=floor(sz_block(1)/2);
halfv=floor(sz_block(2)/2);
halfw=floor(sz_block(3)/2);

s_u_half=distance_sum_u(halfu,:,:);
s_v_half=distance_sum_v(:,halfv,:);
s_w_half=distance_sum_w(:,:,halfw);

sz_dis_sum=size(distance_sum_u);
for i=1:sz_dis_sum(1)
    for j=1:sz_dis_sum(2)
        for k=1:sz_dis_sum(3)
            distance_sum_u_t(i,j,k)=distance_sum_u(i,j,k)-s_u_half(1,j,k);
            distance_sum_v_t(i,j,k)=distance_sum_v(i,j,k)-s_v_half(i,1,k);
            distance_sum_w_t(i,j,k)=distance_sum_w(i,j,k)-s_w_half(i,j,1);
        end
    end
end

clear distance_sum_u distance_sum_v distance_sum_w
clear s_u_half s_v_half s_w_half

%apply mask
smoo_distance_u_mask=distance_sum_u_t;
smoo_distance_v_mask=distance_sum_v_t;
smoo_distance_w_mask=distance_sum_w_t;

clear distance_sum_u_t distance_sum_v_t distance_sum_w_t

smoo_distance_u_mask(mask)=NaN;
smoo_distance_v_mask(mask)=NaN;
smoo_distance_w_mask(mask)=NaN;

smoo_distance_u_mask = imresize3(smoo_distance_u_mask,1/rsFactor);
smoo_distance_v_mask = imresize3(smoo_distance_v_mask,1/rsFactor);
smoo_distance_w_mask = imresize3(smoo_distance_w_mask,1/rsFactor);


smooDists = cat(4,smoo_distance_u_mask,smoo_distance_v_mask,smoo_distance_w_mask);
end