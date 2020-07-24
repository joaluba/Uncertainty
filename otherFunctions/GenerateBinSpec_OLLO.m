function [m_YOut_train, m_labels_train]=GenerateBinSpec_OLLO(sTrainingParam)
% ---Training Parameters:---
% N
% A 
% epsilon
% classes_train
% classes_test
% H
% dirName   or  data, labels for real data
% M
% angle 
% directionInfo
% noise
% display 




for n=1:sTrainingParam.N
    
%rand_n=randi(length(train_OLLO));

%load a data point
datapoint=squeeze(train_OLLO(n,:,:));
%load left and right HRIRs
[v_HRIR_left, v_HRIR_right] = pick_HRIR(sGenParam.angle);
%resample HRIRs to the sampling rate of 
%compute left spectrogram 
sTrainingParam.angle

%compute right spectrogram






% multiply with HRTFs from Hendrik's hrtf base
% concatenate 
% reshape
% normalize     
end











end