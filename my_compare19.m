%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%  RUN AND REDUCED RESOLUTION VALIDATION  %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization of the Matrix of Results
close all;
clc;
clear all;
NumAlgs = 19; % total 19 methods
NumIndexes = 5; % total 5 index Q_EXP,Q_avg_EXP,SAM_EXP,ERGAS_EXP,SCC_GT_EXP
load 'classic_ml.mat';
ml_set = data;
[num, h, w, b] = size(ml_set);
load 'classic_mlu.mat';
mlu_set = data;
load 'classic_pl.mat';
pl_set = data;
load 'classic_m';
m_set = data;
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
set_c1=zeros(num, h*ratio, w*ratio, b);
set_c2=zeros(num, h*ratio, w*ratio, b);
set_c3=zeros(num, h*ratio, w*ratio, b);
set_c4=zeros(num, h*ratio, w*ratio, b);

for i = 1 : num
    MatrixResults = zeros(NumAlgs,NumIndexes);

    I_MS_LR = ml_set(i,:,:,:);
    I_MS_LR = squeeze(I_MS_LR);

    I_MS = mlu_set(i,:,:,:);
    I_MS = squeeze(I_MS);

    I_PAN = pl_set(i,:,:,:);
    I_PAN = squeeze(I_PAN);

    I_GT = m_set(i,:,:,:);
    I_GT = squeeze(I_GT);

    %% EXP

    [Q_avg_EXP, SAM_EXP, ERGAS_EXP, SCC_GT_EXP, Q_EXP] = indexes_evaluation(I_MS,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

    % if size(I_GT,3) == 4    
    %     showImage4(I_MS,printEPS,3,flag_cut_bounds,dim_cut,thvalues,L);    
    % else
    %     showImage8(I_MS,printEPS,3,flag_cut_bounds,dim_cut,thvalues,L);
    % end
    Z=I_MS;
    FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
    xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
    MatrixResults(1,:) = [Q_EXP,Q_avg_EXP,SAM_EXP,ERGAS_EXP,SCC_GT_EXP];

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Component Substitution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% PCA

cd PCA
t2=tic;
I_PCA = PCA(I_MS,I_PAN);
time_PCA=toc(t2);
fprintf('Elaboration time PCA: %.2f [sec]\n',time_PCA);
cd ..

[Q_avg_PCA, SAM_PCA, ERGAS_PCA, SCC_GT_PCA, Q_PCA] = indexes_evaluation(I_PCA,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4    
%     showImage4(I_PCA,printEPS,4,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_PCA,printEPS,4,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_PCA;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(2,:) = [Q_PCA,Q_avg_PCA,SAM_PCA,ERGAS_PCA,SCC_GT_PCA];

%% IHS

cd IHS
t2=tic;
I_IHS = IHS(I_MS,I_PAN);
time_IHS=toc(t2);
fprintf('Elaboration time IHS: %.2f [sec]\n',time_IHS);
cd ..

[Q_avg_IHS, SAM_IHS, ERGAS_IHS, SCC_GT_IHS, Q_IHS] = indexes_evaluation(I_IHS,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4
%     showImage4(I_IHS,printEPS,5,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_IHS,printEPS,5,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_IHS;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(3,:) = [Q_IHS,Q_avg_IHS,SAM_IHS,ERGAS_IHS,SCC_GT_IHS];

%% Brovey

cd Brovey
t2=tic;
I_Brovey = Brovey(I_MS,I_PAN);
time_Brovey=toc(t2);
fprintf('Elaboration time Brovey: %.2f [sec]\n',time_Brovey);
cd ..

[Q_avg_Brovey, SAM_Brovey, ERGAS_Brovey, SCC_GT_Brovey, Q_Brovey] = indexes_evaluation(I_Brovey,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4
%     showImage4(I_Brovey,printEPS,6,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_Brovey,printEPS,6,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_Brovey;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(4,:) = [Q_Brovey,Q_avg_Brovey,SAM_Brovey,ERGAS_Brovey,SCC_GT_Brovey];

%% BDSD

cd BDSD
t2=tic;

I_BDSD = BDSD(I_MS,I_PAN,ratio,size(I_MS,1),sensor);

time_BDSD = toc(t2);
fprintf('Elaboration time BDSD: %.2f [sec]\n',time_BDSD);
cd ..

[Q_avg_BDSD, SAM_BDSD, ERGAS_BDSD, SCC_GT_BDSD, Q_BDSD] = indexes_evaluation(I_BDSD,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4
%     showImage4(I_BDSD,printEPS,7,flag_cut_bounds,dim_cut,thvalues,L);    
% else
%     showImage8(I_BDSD,printEPS,7,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_BDSD;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(5,:) = [Q_BDSD,Q_avg_BDSD,SAM_BDSD,ERGAS_BDSD,SCC_GT_BDSD];

%% GS

cd GS
t2=tic;
I_GS = GS(I_MS,I_PAN);
time_GS = toc(t2);
fprintf('Elaboration time GS: %.2f [sec]\n',time_GS);
cd ..

[Q_avg_GS, SAM_GS, ERGAS_GS, SCC_GT_GS, Q_GS] = indexes_evaluation(I_GS,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4   
%     showImage4(I_GS,printEPS,8,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_GS,printEPS,8,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_GS;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(6,:) = [Q_GS,Q_avg_GS,SAM_GS,ERGAS_GS,SCC_GT_GS];

%% GSA

cd GS
t2=tic;
I_GSA = GSA(I_MS,I_PAN,I_MS_LR,ratio);
tempo_GSA = toc(t2);
fprintf('Elaboration time GSA: %.2f [sec]\n',tempo_GSA);
cd ..

[Q_avg_GSA, SAM_GSA, ERGAS_GSA, SCC_GT_GSA, Q_GSA] = indexes_evaluation(I_GSA,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4
%     showImage4(I_GSA,printEPS,9,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_GSA,printEPS,9,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_GSA;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(7,:) = [Q_GSA,Q_avg_GSA,SAM_GSA,ERGAS_GSA,SCC_GT_GSA];

%% PRACS

cd PRACS
t2=tic;
I_PRACS = PRACS(I_MS,I_PAN,ratio);
time_PRACS = toc(t2);
fprintf('Elaboration time PRACS: %.2f [sec]\n',time_PRACS);
cd ..

[Q_avg_PRACS, SAM_PRACS, ERGAS_PRACS, SCC_GT_PRACS, Q_PRACS] = indexes_evaluation(I_PRACS,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4
%     showImage4(I_PRACS,printEPS,10,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_PRACS,printEPS,10,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_PRACS;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(8,:) = [Q_PRACS,Q_avg_PRACS,SAM_PRACS,ERGAS_PRACS,SCC_GT_PRACS];


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MultiResolution Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% HPF

cd HPF
t2=tic;
I_HPF = HPF(I_MS,I_PAN,ratio);
time_HPF = toc(t2);
fprintf('Elaboration time HPF: %.2f [sec]\n',time_HPF);
cd ..

[Q_avg_HPF, SAM_HPF, ERGAS_HPF, SCC_GT_HPF, Q_HPF] = indexes_evaluation(I_HPF,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4
%     showImage4(I_HPF,printEPS,11,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_HPF,printEPS,11,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_HPF;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(9,:) = [Q_HPF,Q_avg_HPF,SAM_HPF,ERGAS_HPF,SCC_GT_HPF];

%% SFIM

cd SFIM
t2=tic;
I_SFIM = SFIM(I_MS,I_PAN,ratio);
time_SFIM = toc(t2);
fprintf('Elaboration time SFIM: %.2f [sec]\n',time_SFIM);
cd ..

[Q_avg_SFIM, SAM_SFIM, ERGAS_SFIM, SCC_GT_SFIM, Q_SFIM] = indexes_evaluation(I_SFIM,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4
%     showImage4(I_SFIM,printEPS,12,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_SFIM,printEPS,12,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_SFIM;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(10,:) = [Q_SFIM,Q_avg_SFIM,SAM_SFIM,ERGAS_SFIM,SCC_GT_SFIM];

%% Indusion

cd Indusion
t2=tic;
I_Indusion = Indusion(I_PAN,I_MS_LR,ratio);
time_Indusion = toc(t2);
fprintf('Elaboration time Indusion: %.2f [sec]\n',time_Indusion);
cd ..

[Q_avg_Indusion, SAM_Indusion, ERGAS_Indusion, SCC_GT_Indusion, Q_Indusion] = indexes_evaluation(I_Indusion,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4
%     showImage4(I_Indusion,printEPS,13,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_Indusion,printEPS,13,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_Indusion;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(11,:) = [Q_Indusion,Q_avg_Indusion,SAM_Indusion,ERGAS_Indusion,SCC_GT_Indusion];

%% ATWT

cd Wavelet
t2=tic;
I_ATWT = ATWT(I_MS,I_PAN,ratio);
time_ATWT = toc(t2);
fprintf('Elaboration time ATWT: %.2f [sec]\n',time_ATWT);
cd ..

[Q_avg_ATWT, SAM_ATWT, ERGAS_ATWT, SCC_GT_ATWT, Q_ATWT] = indexes_evaluation(I_ATWT,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4
%     showImage4(I_ATWT,printEPS,14,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_ATWT,printEPS,14,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_ATWT;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(12,:) = [Q_ATWT,Q_avg_ATWT,SAM_ATWT,ERGAS_ATWT,SCC_GT_ATWT];

%% AWLP

cd Wavelet
t2=tic;
I_AWLP = AWLP(I_MS,I_PAN,ratio);
time_AWLP = toc(t2);
fprintf('Elaboration time AWLP: %.2f [sec]\n',time_AWLP);
cd ..

[Q_avg_AWLP, SAM_AWLP, ERGAS_AWLP, SCC_GT_AWLP, Q_AWLP] = indexes_evaluation(I_AWLP,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4
%     showImage4(I_AWLP,printEPS,15,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_AWLP,printEPS,15,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_AWLP;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(13,:) = [Q_AWLP,Q_avg_AWLP,SAM_AWLP,ERGAS_AWLP,SCC_GT_AWLP];

%% ATWT-M2

cd Wavelet
t2=tic;

I_ATWTM2 = ATWT_M2(I_MS,I_PAN,ratio);

time_ATWTM2 = toc(t2);
fprintf('Elaboration time ATWT-M2: %.2f [sec]\n',time_ATWTM2);
cd ..

[Q_avg_ATWTM2, SAM_ATWTM2, ERGAS_ATWTM2, SCC_GT_ATWTM2, Q_ATWTM2] = indexes_evaluation(I_ATWTM2,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4   
%     showImage4(I_ATWTM2,printEPS,16,flag_cut_bounds,dim_cut,thvalues,L);    
% else
%     showImage8(I_ATWTM2,printEPS,16,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_ATWTM2;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(14,:) = [Q_ATWTM2,Q_avg_ATWTM2,SAM_ATWTM2,ERGAS_ATWTM2,SCC_GT_ATWTM2];

%% ATWT-M3

cd Wavelet
t2=tic;

I_ATWTM3 = ATWT_M3(I_MS,I_PAN,ratio);

time_ATWTM3 = toc(t2);
fprintf('Elaboration time ATWT-M3: %.2f [sec]\n',time_ATWTM3);
cd ..

[Q_avg_ATWTM3, SAM_ATWTM3, ERGAS_ATWTM3, SCC_GT_ATWTM3, Q_ATWTM3] = indexes_evaluation(I_ATWTM3,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4   
%     showImage4(I_ATWTM3,printEPS,17,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_ATWTM3,printEPS,17,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_ATWTM3;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(15,:) = [Q_ATWTM3,Q_avg_ATWTM3,SAM_ATWTM3,ERGAS_ATWTM3,SCC_GT_ATWTM3];

%% MTF-GLP

cd GLP
t2=tic;
I_MTF_GLP = MTF_GLP(I_PAN,I_MS,sensor,im_tag,ratio);
% I_MTF_GLP = MTF_GLP_ECB(I_MS,I_PAN,ratio,[9 9],2.5,sensor,im_tag);
% I_MTF_GLP = MTF_GLP_CBD(I_MS,I_PAN,ratio,[55 55],-Inf,sensor,im_tag);
time_MTF_GLP = toc(t2);
fprintf('Elaboration time MTF-GLP: %.2f [sec]\n',time_MTF_GLP);
cd ..

[Q_avg_MTF_GLP, SAM_MTF_GLP, ERGAS_MTF_GLP, SCC_GT_MTF_GLP, Q_MTF_GLP] = indexes_evaluation(I_MTF_GLP,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4
%     showImage4(I_MTF_GLP,printEPS,18,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_MTF_GLP,printEPS,18,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_MTF_GLP;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(16,:) = [Q_MTF_GLP,Q_avg_MTF_GLP,SAM_MTF_GLP,ERGAS_MTF_GLP,SCC_GT_MTF_GLP];

%% MTF-GLP-HPM-PP

cd GLP
t2=tic;
I_MTF_GLP_HPM_PP = MTF_GLP_HPM_PP(I_PAN,I_MS_LR,sensor,im_tag,ratio);
time_MTF_GLP_HPM_PP = toc(t2);
fprintf('Elaboration time MTF-GLP-HPM-PP: %.2f [sec]\n',time_MTF_GLP_HPM_PP);
cd ..

[Q_avg_MTF_GLP_HPM_PP, SAM_MTF_GLP_HPM_PP, ERGAS_MTF_GLP_HPM_PP, SCC_GT_MTF_GLP_HPM_PP, Q_MTF_GLP_HPM_PP] = indexes_evaluation(I_MTF_GLP_HPM_PP,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);
    
% if size(I_GT,3) == 4
%     showImage4(I_MTF_GLP_HPM_PP,printEPS,19,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_MTF_GLP_HPM_PP,printEPS,19,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_MTF_GLP_HPM_PP;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(17,:) = [Q_MTF_GLP_HPM_PP,Q_avg_MTF_GLP_HPM_PP,SAM_MTF_GLP_HPM_PP,ERGAS_MTF_GLP_HPM_PP,SCC_GT_MTF_GLP_HPM_PP];

%% MTF-GLP-HPM

cd GLP
t2=tic;
I_MTF_GLP_HPM = MTF_GLP_HPM(I_PAN,I_MS,sensor,im_tag,ratio);
time_MTF_GLP_HPM = toc(t2);
fprintf('Elaboration time MTF-GLP-HPM: %.2f [sec]\n',time_MTF_GLP_HPM);
cd ..

[Q_avg_MTF_GLP_HPM, SAM_MTF_GLP_HPM, ERGAS_MTF_GLP_HPM, SCC_GT_MTF_GLP_HPM, Q_MTF_GLP_HPM] = indexes_evaluation(I_MTF_GLP_HPM,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4    
%     showImage4(I_MTF_GLP_HPM,printEPS,20,flag_cut_bounds,dim_cut,thvalues,L);    
% else
%     showImage8(I_MTF_GLP_HPM,printEPS,20,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_MTF_GLP_HPM;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(18,:) = [Q_MTF_GLP_HPM,Q_avg_MTF_GLP_HPM,SAM_MTF_GLP_HPM,ERGAS_MTF_GLP_HPM,SCC_GT_MTF_GLP_HPM];

%% MTF-GLP-CBD

cd GS
t2=tic;

I_MTF_GLP_CBD = GS2_GLP(I_MS,I_PAN,ratio,sensor,im_tag);

time_MTF_GLP_CBD = toc(t2);
fprintf('Elaboration time MTF-GLP-CBD: %.2f [sec]\n',time_MTF_GLP_CBD);
cd ..

[Q_avg_MTF_GLP_CBD, SAM_MTF_GLP_CBD, ERGAS_MTF_GLP_CBD, SCC_GT_MTF_GLP_CBD, Q_MTF_GLP_CBD] = indexes_evaluation(I_MTF_GLP_CBD,I_GT,ratio,L,Qblocks_size,flag_cut_bounds,dim_cut,thvalues);

% if size(I_GT,3) == 4
%     showImage4(I_MTF_GLP_CBD,printEPS,21,flag_cut_bounds,dim_cut,thvalues,L);
% else
%     showImage8(I_MTF_GLP_CBD,printEPS,21,flag_cut_bounds,dim_cut,thvalues,L);
% end
Z=I_MTF_GLP_CBD;
FalseColorf(:,:,1)=Z(:,:,4);FalseColorf(:,:,2)=Z(:,:,3);FalseColorf(:,:,3)=Z(:,:,2);
xf=imadjust(FalseColorf/1000,stretchlim(FalseColorf/1000),[]);figure,imshow(xf);
MatrixResults(19,:) = [Q_MTF_GLP_CBD,Q_avg_MTF_GLP_CBD,SAM_MTF_GLP_CBD,ERGAS_MTF_GLP_CBD,SCC_GT_MTF_GLP_CBD];


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
% c1='BDSD.mat';
% c2='PRACS.mat';
% c3='ATWT.mat';
% c4='MTF-GLP-HPM.mat';
% save(c1,'set_c1');
% save(c2,'set_c2');
% save(c3,'set_c3');
% save(c4,'set_c4');