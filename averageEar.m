close all; clearvars; clc;
b = BabyEar4k();
% normal ear 
res = b.getRes();

flag_normal = zeros(size(res,1),2);
flag_normal(:,1) = sum(res(:,1:3),2)==0;
flag_normal(:,2) = sum(res(:,4:6),2)==0;
flag_lop = flag_normal*0;
flag_lop(:,1) = res(:,1)==1;
flag_lop(:,2) = res(:,4)==1;
flag_stahl = flag_normal*0;
flag_stahl(:,1) = res(:,1)==2;
flag_stahl(:,2) = res(:,4)==2;

flag{1} = flag_normal;
flag{2} = flag_lop;
flag{3} = flag_stahl;

figure(1); set(gcf,'position',[0,0,900,300])
tiledlayout(1,3,'padding','tight','tilespacing','none');

for kk = 1:3
    [img,idx] = b.calculateAverageEar(flag{kk});
    nexttile(kk);
    imshow(img);;
end 

figure(2); set(gcf,'position',[0,0,900,300])
tiledlayout(1,3,'padding','tight','tilespacing','none');

for kk = 1:3
    [img,idx] = b.calculateAverageEar(flag{kk});
    nexttile(kk);
    imagesc(img.^(1/3)); colormap(hsv);
    axis off;
end 