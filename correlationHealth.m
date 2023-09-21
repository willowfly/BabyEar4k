close all; clearvars; clc;
b = BabyEar4k();
L_abnormal = sum( b.resMerge(:,1:3),2 )>0;
R_abnormal = sum( b.resMerge(:,4:6),2 )>0;
abEars = (L_abnormal+R_abnormal)>0; % babies having at least one abnormal ear

% gender: a vector of 1926*1, 1 for male and 0 for females
g = table2array( b.health(:,2) );  gender = zeros(length(g),1);
for ii = 1:length(g)
    if(strcmp(g{ii},'male')) gender(ii) = 1; end
end
crossTab = zeros(2,2);
for ii = 1:length(gender)
    tmp = crossTab( gender(ii)+1, abEars(ii)+1 );
    crossTab( gender(ii)+1, abEars(ii)+1 ) =  tmp + 1;
end
fprintf(1, 'Analyzing corrlation between ear deformities and gender\n');
fprintf(1, '\t\t\t Ears (normal) \t Ears (abnormal) \n');
fprintf(1, 'Gender (female) \t %5d \t\t   %5d \n',crossTab(1,1),crossTab(1,2));
fprintf(1, 'gender (male)   \t %5d \t\t   %5d \n',crossTab(2,1),crossTab(2,2));
[p,chi2] = chi2test(crossTab);
fprintf('chi-square test: chi2 = %8.3f, p = %10.8f\n',chi2,p);
fprintf('------------------------------------------------------------------------\n');

% influence of gestational age
gestational_age = table2array(b.health(:,5));
age_normal = gestational_age( abEars==0 );
age_abnormal = gestational_age( abEars>0 );
fprintf(1, 'Analyzing corrlation between ear deformities and gestational_age\n');
fprintf(1, 'For the   normal group (n=%4d): the gestation_age is %5.2f (%4.2f) weeks\n', ...
    length(age_normal), mean(age_normal), std(age_normal));
fprintf(1, 'For the abnormal group (n=%4d): the gestation_age is %5.2f (%4.2f) weeks\n', ...
    length(age_abnormal), mean(age_abnormal), std(age_abnormal));
[h,p,c] = ttest2(age_normal,age_abnormal);
fprintf('According to student t test, p = %d\n',p);
fprintf('------------------------------------------------------------------------\n');

% influence of baby weight
weight = table2array(b.health(:,4));
weight_normal = weight( abEars==0 );
weight_abnormal = weight( abEars>0 );
fprintf(1, 'Analyzing corrlation between ear deformities and baby weight\n');
fprintf(1, 'For the   normal group (n=%4d): the weight is %4.1f (%4.1f) grams\n', ...
    length(weight_normal), mean(weight_normal), std(weight_normal));
fprintf(1, 'For the abnormal group (n=%4d): the weight is %4.1f (%4.1f) grams\n', ...
    length(weight_abnormal), mean(weight_abnormal), std(weight_abnormal));
[h,p,c] = ttest2(weight_normal,weight_abnormal);
fprintf('According to student t test, p = %d\n',p);
fprintf('------------------------------------------------------------------------\n');

% influence of mother's age
mother_age = table2array(b.health(:,7));
age_normal = mother_age( abEars==0 );
age_abnormal = mother_age( abEars>0 );
fprintf(1, 'Analyzing corrlation between ear deformities and mother age\n');
fprintf(1, 'For the   normal group (n=%4d): the mother age is %5.2f (%4.2f) years\n', ...
    length(age_normal), mean(age_normal), std(age_normal));
fprintf(1, 'For the abnormal group (n=%4d): the mother age is %5.2f (%4.2f) years\n', ...
    length(age_abnormal), mean(age_abnormal), std(age_abnormal));
[h,p,c] = ttest2(age_normal,age_abnormal);
fprintf('According to student t test, p = %d\n',p);
fprintf('------------------------------------------------------------------------\n');