%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%  RUN AND REDUCED RESOLUTION VALIDATION  %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization of the Matrix of Results
close all;
clc;
clear all;
NumAlgs = 4; % total 19 methods
NumIndexes = 5; % total 5 index Q_EXP,Q_avg_EXP,SAM_EXP,ERGAS_EXP,SCC_GT_EXP
% load 'classic_test_ml.mat';
% ml_set = data;
% ml_max = max(max(max(max(ml_set))))
% [num, h, w, b] = size(ml_set);
load 'keras_test_ms.mat';
mlu_set = data;
mlu_max = max(max(max(max(mlu_set))))
[num, h, w, b] = size(mlu_set);
load 'keras_test_pan.mat';
pl_set = data;
pl_max = max(max(max(max(pl_set))))
load 'keras_pnn_gt.mat';
m_set = data;
m_max = max(max(max(max(m_set))))
sensor = 'WV2';
im_tag = 'WV2';
ratio = 4;
Qblocks_size = 32;% Quality Index Blocks
flag_cut_bounds = 1;
dim_cut = 11;% Cut Final Image
printEPS = 0;% Print Eps
thvalues = 0;% Threshold values out of dynamic range
L = 11;% Radiometric Resolution
set_MatrixResults = zeros(num,NumAlgs,NumIndexes);
% set_c1=zeros(num, h*ratio, w*ratio, b);
% set_c2=zeros(num, h*ratio, w*ratio, b);
% set_c3=zeros(num, h*ratio, w*ratio, b);
% set_c4=zeros(num, h*ratio, w*ratio, b);
set_c1=zeros(num, h, w, b);
set_c2=zeros(num, h, w, b);
set_c3=zeros(num, h, w, b);
set_c4=zeros(num, h, w, b);

for i = 1 : num
    MatrixResults = zeros(NumAlgs,NumIndexes);

%     I_MS_LR = ml_set(i,:,:,:);
%     I_MS_LR = squeeze(I_MS_LR);

    I_MS = mlu_set(i,:,:,:);
    I_MS = squeeze(I_MS);

    I_PAN = pl_set(i,:,:,:);
    I_PAN = squeeze(I_PAN);

    I_GT = m_set(i,:,:,:);
    I_GT = squeeze(I_GT);

%     %% EXP
% 
%     [Q_avg_EXP, SAM_EXP, ERGAS_EXP, SCC_GT_EXP, Q_EXP] = indexes_evaluation(I_MS,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);
% 
%     % if size(I_GT,3) == 4    
%     %     showImage4(I_MS,printEPS,3,flag_cut_bounds,dim_cut,thvalues,L);    
%     % else
%     %     showImage8(I_MS,printEPS,3,flag_cut_bounds,dim_cut,thvalues,L);
%     % end
%     Z=I_MS;
%     FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
%     xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
%     MatrixResults(1,:) = [Q_EXP,Q_avg_EXP,SAM_EXP,ERGAS_EXP,SCC_GT_EXP];

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Component Substitution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% BDSD

    cd BDSD
    t2=tic;

    I_BDSD = BDSD(I_MS,I_PAN,ratio,size(I_MS,1),sensor);
    set_c1(i, :, :,:)=I_BDSD;

    time_BDSD = toc(t2);
    fprintf('Elaboration time BDSD: %.2f [sec]\n',time_BDSD);
    cd ..

    [Q_avg_BDSD, SAM_BDSD, ERGAS_BDSD, SCC_GT_BDSD, Q_BDSD] = indexes_evaluation(I_BDSD,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

%     if size(I_GT,3) == 4
%         showImage4(I_BDSD,printEPS,7,flag_cut_bounds,dim_cut,thvalues,L);    
%     else
%         showImage8(I_BDSD,printEPS,7,flag_cut_bounds,dim_cut,thvalues,L);
%     end
%     Z=I_BDSD;
%     FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
%     xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
    MatrixResults(1,:) = [Q_BDSD,Q_avg_BDSD,SAM_BDSD,ERGAS_BDSD,SCC_GT_BDSD];



    %% PRACS

    cd PRACS
    t2=tic;
    I_PRACS = PRACS(I_MS,I_PAN,ratio);
    set_c2(i, :, :,:)=I_PRACS;
    time_PRACS = toc(t2);
    fprintf('Elaboration time PRACS: %.2f [sec]\n',time_PRACS);
    cd ..

    [Q_avg_PRACS, SAM_PRACS, ERGAS_PRACS, SCC_GT_PRACS, Q_PRACS] = indexes_evaluation(I_PRACS,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

%     if size(I_GT,3) == 4
%         showImage4(I_PRACS,printEPS,10,flag_cut_bounds,dim_cut,thvalues,L);
%     else
%         showImage8(I_PRACS,printEPS,10,flag_cut_bounds,dim_cut,thvalues,L);
%     end
%     Z=I_PRACS;
%     FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
%     xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
    MatrixResults(2,:) = [Q_PRACS,Q_avg_PRACS,SAM_PRACS,ERGAS_PRACS,SCC_GT_PRACS];


    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MultiResolution Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% ATWT

    cd Wavelet
    t2=tic;
    I_ATWT = ATWT(I_MS,I_PAN,ratio);
    set_c3(i, :, :,:)=I_ATWT;
    time_ATWT = toc(t2);
    fprintf('Elaboration time ATWT: %.2f [sec]\n',time_ATWT);
    cd ..

    [Q_avg_ATWT, SAM_ATWT, ERGAS_ATWT, SCC_GT_ATWT, Q_ATWT] = indexes_evaluation(I_ATWT,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

%     if size(I_GT,3) == 4
%         showImage4(I_ATWT,printEPS,14,flag_cut_bounds,dim_cut,thvalues,L);
%     else
%         showImage8(I_ATWT,printEPS,14,flag_cut_bounds,dim_cut,thvalues,L);
%     end
%     Z=I_ATWT;
%     FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
%     xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
    MatrixResults(3,:) = [Q_ATWT,Q_avg_ATWT,SAM_ATWT,ERGAS_ATWT,SCC_GT_ATWT];


    %% MTF-GLP-HPM

    cd GLP
    t2=tic;
    I_MTF_GLP_HPM = MTF_GLP_HPM(I_PAN,I_MS,sensor,im_tag,ratio);
    set_c4(i, :, :,:)=I_MTF_GLP_HPM;
    time_MTF_GLP_HPM = toc(t2);
    fprintf('Elaboration time MTF-GLP-HPM: %.2f [sec]\n',time_MTF_GLP_HPM);
    cd ..

    [Q_avg_MTF_GLP_HPM, SAM_MTF_GLP_HPM, ERGAS_MTF_GLP_HPM, SCC_GT_MTF_GLP_HPM, Q_MTF_GLP_HPM] = indexes_evaluation(I_MTF_GLP_HPM,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

%     if size(I_GT,3) == 4    
%         showImage4(I_MTF_GLP_HPM,printEPS,20,flag_cut_bounds,dim_cut,thvalues,L);    
%     else
%         showImage8(I_MTF_GLP_HPM,printEPS,20,flag_cut_bounds,dim_cut,thvalues,L);
%     end
%     Z=I_MTF_GLP_HPM;
%     FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
%     xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
    MatrixResults(4,:) = [Q_MTF_GLP_HPM,Q_avg_MTF_GLP_HPM,SAM_MTF_GLP_HPM,ERGAS_MTF_GLP_HPM,SCC_GT_MTF_GLP_HPM];


    set_MatrixResults(i, :, :)=MatrixResults(:,:);
end
    %% Print in LATEX

    if size(I_GT,3) == 4
        for i = 1:num
            MatrixResults = set_MatrixResults(i,:, :);
            MatrixResults = squeeze(MatrixResults);
            matrix2latex(MatrixResults,'reduced_Dataset.tex', 'rowLabels',[{'EXP'},{'BDSD'},{'PRACS'},{'ATWT'},{'MTF-GLP-HPM'}],'columnLabels',[{'Q4'},{'Q'},{'SAM'},{'ERGAS'},{'SCC'}],'alignment','c','format', '%.4f');
        end
    else
        for i = 1:num
            MatrixResults = set_MatrixResults(i,:, :);
            MatrixResults = squeeze(MatrixResults);
            matrix2latex(MatrixResults,'reduced_Dataset.tex', 'rowLabels',[{'BDSD'},{'PRACS'},{'ATWT'},{'MTF-GLP-HPM'}],'columnLabels',[{'Q8'},{'Q'},{'SAM'},{'ERGAS'},{'SCC'}],'alignment','c','format', '%.4f'); 
        end
    end

mean_MatrixResults = mean(set_MatrixResults, 1);
mean_MatrixResults = squeeze(mean_MatrixResults);
matrix2latex(MatrixResults,'reduced_Dataset.tex', 'rowLabels',[{'BDSD'},{'PRACS'},{'ATWT'},{'MTF-GLP-HPM'}],'columnLabels',[{'Q8'},{'Q'},{'SAM'},{'ERGAS'},{'SCC'}],'alignment','c','format', '%.4f'); 
c1='BDSD_output.mat';
c2='PRACS_output.mat';
c3='ATWT_output.mat';
c4='MTF-GLP-HPM_output.mat';
save(c1,'set_c1');
save(c2,'set_c2');
save(c3,'set_c3');
save(c4,'set_c4');
max(max(max(max(set_c1))))
max(max(max(max(set_c2))))
max(max(max(max(set_c3))))
max(max(max(max(set_c4))))