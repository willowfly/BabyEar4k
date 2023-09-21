close all; clearvars; clc;
b = BabyEar4k();
% correlation analysis of the left and right ear
L_abnormal = sum( b.resMerge(:,1:3),2 )>0;
R_abnormal = sum( b.resMerge(:,4:6),2 )>0;
crossTab = zeros(2,2);
for ii = 1:length(L_abnormal)
    tmp = crossTab( L_abnormal(ii)+1, R_abnormal(ii)+1 );
    crossTab( L_abnormal(ii)+1, R_abnormal(ii)+1 ) =  tmp + 1;
end
fprintf(1, 'Analyzing normal-abnormal correlation between left and right ear\n');
fprintf(1, '\t\t\t Right (normal) \t Right (abnormal) \n');
fprintf(1, 'Left (normal) \t %5d \t\t   %5d \n',crossTab(1,1),crossTab(1,2));
fprintf(1, 'Left (normal) \t %5d \t\t   %5d \n',crossTab(2,1),crossTab(2,2));
[p,chi2] = chi2test(crossTab);
fprintf('chi-square test: chi2 = %8.3f, p = %10.8f\n',chi2,p);
fprintf('------------------------------------------------------------------------\n');

Ltype = b.resMerge(:,1);
Rtype = b.resMerge(:,4);
crossTab = zeros(8,8);
for ii = 1:length(Ltype)
    tmp = crossTab( Ltype(ii)+1, Rtype(ii)+1 );
    crossTab( Ltype(ii)+1, Rtype(ii)+1 ) =  tmp + 1;
end

% calculate C: the geometrical average of conditional probability
C = 0*crossTab; 
for ii = 1:size(crossTab,1)
    for jj = 1:size(crossTab,2)
        C(ii,jj) = sqrt( crossTab(ii,jj).^2/sum(crossTab(ii,:))/sum(crossTab(:,jj)));
    end
end
C(isnan(C))=0;
fprintf(1,'Analysing subtypes correlation between left and right ear\n');
format short;
crossTab
C
% plot the C matrix
map = ones(11,3);
map(:,1) = 1:-0.1:0;
map(:,2) = 1:-0.1:0;
imagesc(sqrt(C),[-0.05,1.05]); colormap(map); colorbar;
set(gca,'xtick',[],'ytick',[]);
xlabel('Right ear subtypes'); ylabel('Left ear subtypes');
title( 'geometrical average of conditional probability' );
