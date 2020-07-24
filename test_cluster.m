% clc
% clear 
% close all

% Author: Joanna Luberadzka
%  
% addpath(genpath());
% addpath(genpath('/home/joanna/UNCERTAINTY'))


% datapath='/media/joanna/daten/user/joanna/Data/TIMIT';
datapath='/user/fk5/ifp/agmediphys/wuau6202/MATLAB/Projects/UNCERTAINTY/';
addpath(genpath(datapath))

%% PRODUCING UNCERTAINTY CURVES 

tic 

load(['TIMIT_anecho_A700N500k-06-Sep-2016_traindata.mat' ],'-mat');

SNR=[-Inf -10 -5 0 5];
Nrtrials=10;

sname='hundred';

for s=1:length(SNR)
    
    if SNR(s)<20
        n_cond=0;
    else
        n_cond='diff_ss';
    end
       
% %Read in data sets 270:5:90
% tic
% DATA=read_in_h5f_data(270,330,90,n_cond,SNR(s));
% t=toc;


%% OPTION 1 - random data points 

for i=1:Nrtrials

% test parameters
sParamTest=struct('datatype','spectral_slices','N',1000,'A',700,'epsilon',0.1,...
'noise',n_cond,'SNR',SNR(s),'display',0,'position',[270 330 90] ,'gen_each_time', 1, 'frames', 'rand')%,'DATA',DATA);
 
[v_Entropy,v_BVSB, ~, v_Error]=test_for_each_angle(stTrainingData.m_B,stTrainingData.m_W,sParamTest)

% sParamTest=rmfield(sParamTest,'DATA');

sTEST_RESULTS.Nt=Nrtrials;
sTEST_RESULTS.test_param{i}=sParamTest;
sTEST_RESULTS.entropy{i}=v_Entropy;
sTEST_RESULTS.BVSB{i}=v_BVSB;
sTEST_RESULTS.error{i}=v_Error;
end
ID=([sname,'_case1_SNR', num2str(sParamTest.SNR), 'N', num2str(sParamTest.N)]);
test_filename=[datapath,'/Uncertainty_Data/TestResults/', ID, '_test.mat' ];
save(test_filename,'sTEST_RESULTS','-v7.3' );

end


