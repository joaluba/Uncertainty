clc
clear 
close all

% Uncertainty as a function of angle using phoneme classification 
% (full data base with 56 phonemes)
%
% Author: Joanna Luberadzka
%  
% addpath(genpath('/user/fk5/ifp/agmediphys/wuau6202/MATLAB/Projects/UNCERTAINTY/'));
addpath(genpath('/home/joanna/UNCERTAINTY'))
addpath(genpath('/media/joanna/daten/user/joanna/Data/TIMIT/Uncertainty_Data/'))



%% TRAINING PART 
% Training the probabilistic unsupervised classifier with a data set consisting 
% of concatenated MEL spectrum. The signals used to obtain TRAINING data
% are anechoic and do not contain HRIR information at all. 

ID=['TIMIT_conv_manySNRs2',num2str(datestr(now,'-dd-mmm-yyyy'))];

% training parameters 
sTrainingParam=struct('datatype','spectral_slices', 'NperNoise',150000,'A',1000,'epsilon',0.1,...
    'H', 1000,'M',1000,'display', 0); 
[m_B, m_W]= training_spectrograms(sTrainingParam);

% %no-training condition: 
% sTrainingParam=struct('datatype','spectral_slices','N',500000,'A',700,'epsilon',0.1,...
%     'H', 1000,'M',1000,'display', 0); 
% [m_B, m_W]= training_spectrograms(sTrainingParam);



% save training data  
stTrainingData.m_B = m_B; stTrainingData.m_W = m_W; stTrainingData.Param= sTrainingParam;
train_filename=['/media/joanna/daten/user/joanna/Data/TIMIT/Uncertainty_Data/TrainResults/',ID, '_traindata.mat' ];
save(train_filename,'stTrainingData');




%% TESTING PART & UNCERTAINTY CURVES 
% Testing the probabilistic unsupervised classifier with a data set consisting 
% of concatenated MEL spectrum. The signals used to obtain TEST data
% are convolved with HRIRs. (Half of a data point (left part) comes from a
% signal convolved with left HRIR for a given azimuth and right part of a
% data point comes from a signal convolved with right HRIR for a given azimuth. 

% The classifier is tested for all possible azimuth angles. For each angle 
% the average classification uncertainty (as entropy and BVSB) is computed.
% Test data for each azimuth is randomly picked from a set of features. 



% Nrtrials=1;
% 
% for i=1:Nrtrials
%     
% 
%  ID=['nowe',num2str(datestr(now,'-dd-mmm-yyyy'))];
% 
% 
% % load weights
% % hold off W_cd & B_ck obtained in training 
% stTrainingData= load(['TIMIT_anecho_A700N500k-06-Sep-2016_traindata.mat' ],'-mat');
% 
% stTrainingData=stTrainingData.stTrainingData;
% 
% 
% a=30000;
% % test parameters
% sTestingParam=struct('datatype','spectral_slices','N',500,'A',700,'epsilon',0.1,...
% 'noise',0,'display',0,'position',[90 180] ,'gen_each_time', 1, 'frames', 'conseq'); %cons
%       
% [stCurves, stDOA_estimated, stDiff ]= estimate_DOA(stTrainingData,sTestingParam,Nrtrials);
% 
% stTESTDOA.DOA_estimated{i}=stDOA_estimated;
% stTESTDOA.Diff{i}=stDiff;
% stTESTDOA.Curves{i}=stCurves;
% stTESTDOA.TrainingData=stTrainingData;
% stTESTDOA.TestingParam=sTestingParam;
% % stTESTDOA.Param(i)=source_pos(i);
% 
% end
% 
% % hold off
% % close(writerObj); % Saves the movie.
% 
% test_filename=['../Uncertainty_Data/TestResults/', ID, '_test.mat' ];
% save(test_filename,'stTESTDOA');

