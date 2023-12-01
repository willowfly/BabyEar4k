classdef BabyEar4k < handle

properties
    folder = './BabyEar4k/';                % folder for the dataset
    imageFolder = './BabyEar4k/images/';    % folder for the images
    Maxid = 2000;                           % maximum id for the babies
    diag                                    % matlab table - the diagnosis
    health                                  % matlab table - health data
    bounding                                % matlab table - bounding information
    quality                                 % matlab table - image quality 
    resExp01                                % expert 01 diagnosis - matrix
    resExp02                                % expert 01 diagnosis - matrix
    resMerge                                % consensus diagnosis - matrix 
    id                                      % a vector contains the IDs
end

methods
    % constructor function
    function obj = BabyEar4k() 
        % read in the results 
        obj.diag = readtable([obj.folder,'diagnosis_result.csv']);
        obj.health = readtable([obj.folder,'health_data.csv']);
        obj.bounding = readtable([obj.folder,'bounding.csv']);
        obj.quality = readtable([obj.folder,'image_quality_assessment.csv']);
        % renew the id, resExp01, resExp02, resMerge properties
        obj.id = table2array(obj.diag(:,1));
        obj.resExp01 = obj.analysisDiagnosisResult(4,5);
        obj.resExp02 = obj.analysisDiagnosisResult(6,7);
        obj.resMerge = obj.analysisDiagnosisResult(8,9);
    end
    
    % get consensus diagnostic results from (L_merge and R_merge)    
    function res = analysisDiagnosisResult(obj,Lid,Rid)
        M = size(obj.diag,1);
        res = zeros(M,6);
        for ii = 1:M
            L = diagnosisStr2num( obj.diag{ii,Lid}{1} ); 
            R = diagnosisStr2num( obj.diag{ii,Rid}{1} ); 
            res(ii,:) = [L,R];
        end
    end
    
    % calculate the average ears 
    function [img,idx] = calculateAverageEar(obj,flag)
        % flag: 1926*2 0-1 matrix indication which images to be averaged
        img = 0; idx = 0;
        for ii = 1:size(obj.diag,1)
            pathL = obj.diag{ii,2}{1};
            pathR = obj.diag{ii,3}{1};
            if flag(ii,1)==1
                im = imread( [obj.folder(1:end-1),pathL] );
                b1 = obj.bounding.left_bound(2*ii-1);
                b2 = obj.bounding.top_bound(2*ii-1);
                b3 = obj.bounding.right_bound(2*ii-1);
                b4 = obj.bounding.bottom_bound(2*ii-1);
                im = rgb2gray(im); im = im([b2:b4],[b1:b3]);
                im = imresize(im,[400,300]);
                img = img+double(im)/255;
            end
            if flag(ii,2)==1
                im = imread( [obj.folder(1:end-1),pathR] ); 
                b1 = obj.bounding.left_bound(2*ii);
                b2 = obj.bounding.top_bound(2*ii);
                b3 = obj.bounding.right_bound(2*ii);
                b4 = obj.bounding.bottom_bound(2*ii);
                im = rgb2gray(im); im = im([b2:b4],[b1:b3]);
                im = imresize(im,[400,300]);
                im = fliplr(im); 
                img = img+double(im)/255;
            end
        end
        idx = sum(flag~=0,'all');
        img = improcess( img/idx );
    end

    function res = analyzeEars(obj)
        M = size(obj.diag,1);
        res = zeros(M,6);
        for ii = 1:M
            L = diagnosisStr2num( obj.diag{ii,8}{1} ); 
            R = diagnosisStr2num( obj.diag{ii,9}{1} ); 
            res(ii,:) = [L,R];
        end
    end
    
    
    function s = imSize(obj)
        s = zeros(2*size(obj.diag,1),2);
        for ii = 1:size(obj.diag,1)
            L = obj.res(ii,2:4);
            R = obj.res(ii,5:7);
            pathL = obj.diag{ii,2};
            pathR = obj.diag{ii,3};
            im1 = imread([obj.folder(1:end-1),pathL]);
            [a,b,c] = size(im1);
            s(2*ii-1,:) = [a,b];
            im2 = imread([obj.folder(1:end-1),pathR]);
            [a,b,c] = size(im2);
            s(2*ii,:) = [a,b];
        end
    end
    
    function res = getRes(obj)
        res = zeros( size(obj.diag,1), 6 );
        Lres = obj.diag.L_merge;
        Rres = obj.diag.R_merge;
        for kk = 1:size(obj.diag,1)
            L = diagnosisStr2num(Lres{kk});
            R = diagnosisStr2num(Rres{kk});
            res(kk,:) = [L R];
        end 
    end 

end

end

% some public functions

% string to number
function res = diagnosisStr2num(str)
    tmp = regexp(str,'+','split');
    res = [0 0 0];
    res(1) = str2num( tmp{1} );
    res(2) = str2num( tmp{2} );
    res(3) = str2num( tmp{3} );
end

% image adjusting
function img = improcess(img)
    mi = min(min(img));
    ma = max(max(img));
    img = (img-mi)/(ma-mi);
    img = img.^3;
end