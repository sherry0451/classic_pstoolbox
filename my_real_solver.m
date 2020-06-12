%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%  RUN AND FULL RESOLUTION VALIDATION  %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization of the Matrix of Results
close all;
clc;
clear all;
NumAlgs = 4; % total 19 methods
sensor = 'WV2';
im_tag = 'WV2';
ratio = 4;
Qblocks_size = 256;% Quality Index Blocks
flag_cut_bounds = 1;
dim_cut = 11;% Cut Final Image
L = 11;% Radiometric Resolution
% NumIndexes = 5; % total 5 index Q_EXP,Q_avg_EXP,SAM_EXP,ERGAS_EXP,SCC_GT_EXP
% load 'classic_test_ml.mat';
% ml_set = data;
% ml_max = max(max(max(max(ml_set))))
% [num, h, w, b] = size(ml_set);
load 'dp_real_mlu.mat';
mlu_set = data;
mlu_max = max(max(max(max(mlu_set))))
[num, h, w, b] = size(mlu_set);
num = 50;
load 'dp_real_pl.mat';
pl_set = data;
pl_max = max(max(max(max(pl_set))))

set_c1=zeros(num, h, w, b);
set_c2=zeros(num, h, w, b);
set_c3=zeros(num, h, w, b);
set_c4=zeros(num, h, w, b);
for i = 1 : num
    I_MS = mlu_set(i,:,:,:);
    I_MS = squeeze(I_MS);

    I_PAN = pl_set(i,:,:,:);
    I_PAN = squeeze(I_PAN);

%% BDSD

cd BDSD
t2=tic;

I_BDSD = BDSD(I_MS,I_PAN,ratio,Qblocks_size,sensor);
time_BDSD = toc(t2);
set_c1(i, :, :,:)=I_BDSD;
% max(max(max(max(I_BDSD))))
fprintf('Elaboration time BDSD: %.2f [sec]\n',time_BDSD);
cd ..
%% PRACS

cd PRACS
t2=tic;
I_PRACS = PRACS(I_MS,I_PAN,ratio);
time_PRACS = toc(t2);
set_c2(i, :, :,:)=I_PRACS;
% max(max(max(max(I_PRACS))))
fprintf('Elaboration time PRACS: %.2f [sec]\n',time_PRACS);
cd ..
%% ATWT

cd Wavelet
t2=tic;
I_ATWT = ATWT(I_MS,I_PAN,ratio);

time_ATWT = toc(t2);
set_c3(i, :, :,:)=I_ATWT;
% max(max(max(max(I_ATWT))))
fprintf('Elaboration time ATWT: %.2f [sec]\n',time_ATWT);
cd ..
%% MTF-GLP-HPM

cd GLP
t2=tic;
I_MTF_GLP_HPM = MTF_GLP_HPM(I_PAN,I_MS,sensor,im_tag,ratio);
tempo_MTF_GLP_HPM = toc(t2);
set_c4(i, :, :,:)=I_MTF_GLP_HPM;
% max(max(max(max(I_MTF_GLP_HPM))))
fprintf('Elaboration time MTF-GLP-HPM: %.2f [sec]\n',tempo_MTF_GLP_HPM);
cd ..

end

%%
c1='BDSD_real_output.mat';
c2='PRACS_real_output.mat';
c3='ATWT_real_output.mat';
c4='MTF-GLP-HPM_real_output.mat';
save(c1,'set_c1');
save(c2,'set_c2');
save(c3,'set_c3');
save(c4,'set_c4');
max(max(max(max(set_c1))))
max(max(max(max(set_c2))))
max(max(max(max(set_c3))))
max(max(max(max(set_c4))))