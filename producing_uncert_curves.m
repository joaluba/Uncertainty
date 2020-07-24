

% datapath='/media/joanna/daten/user/joanna/Data/TIMIT';
% addpath(genpath('/home/joanna/UNCERTAINTY'))

datapath='/user/fk5/ifp/agmediphys/wuau6202/MATLAB/Projects/UNCERTAINTY/';


addpath(genpath(datapath))

%% PRODUCING UNCERTAINTY CURVES 
load(['TIMIT_conv_manySNRs2-18-Jan-2017_traindata.mat' ],'-mat');
SNR=[-10 -5 0 5 Inf];
Nrtrials=20;
sname='NewSNR20_';

for s=1:length(SNR)

% %% OPTION 1 - random data points 
% 
% for i=1:Nrtrials
% 
% % test parameters
% sParamTest=struct('datatype','spectral_slices','N',1000,'A',700,'epsilon',0.1,...
% 'noise',n_cond,'SNR',SNR(s),'display',0,'position',[270 330 90] ,'gen_each_time', 1, 'frames', 'rand','DATA',DATA);
%  
% [v_Entropy,v_BVSB, ~, v_Error]=test_for_each_angle(stTrainingData.m_B,stTrainingData.m_W,sParamTest)
% 
% sParamTest=rmfield(sParamTest,'DATA');
% 
% sTEST_RESULTS.Nt=Nrtrials;
% sTEST_RESULTS.test_param{i}=sParamTest;
% sTEST_RESULTS.entropy{i}=v_Entropy;
% sTEST_RESULTS.BVSB{i}=v_BVSB;
% sTEST_RESULTS.error{i}=v_Error;
% en
% ID=([sname,'_case1_SNR', num2str(sParamTest.SNR), 'N', num2str(sParamTest.N)]);
% test_filename=[datapath,'/Uncertainty_Data/TestResults/', ID, '_test.mat' ];
% save(test_filename,'sTEST_RESULTS','-v7.3' );

%% OPTION 2 - consecutive sequences through all angles (head rotation while listening)

for i=1:Nrtrials
    
% test parameters
sParamTest=struct('datatype','spectral_slices','N',1000,'A',1000,'epsilon',0.1,...
'noise','diff_ss','SNR',SNR(s),'display',0,'position',[270 330 90]  ,'gen_each_time', 1, 'frames', 'conseq','startat', randi(1400000))%,'DATA',DATA);

[v_Entropy,v_BVSB, ~, v_Error]=test_for_each_angle(stTrainingData.m_B,stTrainingData.m_W,sParamTest)

% sParamTest=rmfield(sParamTest,'DATA');

sTEST_RESULTS.Nt=Nrtrials;
sTEST_RESULTS.test_param{i}=sParamTest;
sTEST_RESULTS.entropy{i}=v_Entropy;
sTEST_RESULTS.BVSB{i}=v_BVSB;
sTEST_RESULTS.error{i}=v_Error;
end
ID=([sname,'_case2_SNR', num2str(sParamTest.SNR), 'N', num2str(sParamTest.N)]);
test_filename=[datapath,'/Uncertainty_Data/TestResults/', ID, '_test.mat' ];
save(test_filename,'sTEST_RESULTS','-v7.3' );

%% OPTION 3 - for each angle the same sequence 

% for i=1:Nrtrials
%     
%     
% % test parameters
% sParamTest=struct('datatype','spectral_slices','N',1000,'A',700,'epsilon',0.1,...
% 'noise',n_cond,'SNR',SNR(s),'display',0,'position',[270 330 90] ,'gen_each_time', 0, 'frames', 'conseq','startat', randi(1551877),'DATA',DATA);
%  
% [v_Entropy,v_BVSB, ~, v_Error]=test_for_each_angle(stTrainingData.m_B,stTrainingData.m_W,sParamTest)
% 
% sParamTest=rmfield(sParamTest,'DATA');
% 
% sTEST_RESULTS.Nt=Nrtrials;
% sTEST_RESULTS.test_param{i}=sParamTest;
% sTEST_RESULTS.entropy{i}=v_Entropy;
% sTEST_RESULTS.BVSB{i}=v_BVSB;
% sTEST_RESULTS.error{i}=v_Error;
% end
% ID=([sname,'_case3_SNR', num2str(sParamTest.SNR), 'N', num2str(sParamTest.N)]);
% test_filename=[datapath,'/Uncertainty_Data/TestResults/', ID, '_test.mat' ];
% save(test_filename,'sTEST_RESULTS','-v7.3' );

end

