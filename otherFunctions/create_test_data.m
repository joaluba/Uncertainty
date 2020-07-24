% This is a script to create the H5F data for the whole experiment (all
% SNRs,all angles)

addpath(genpath('/home/joanna/UNCERTAINTY'));
s_directory='/media/joanna/daten/user/joanna/Data/TIMIT/speechdata_wav';
c_fileList = getAllFiles(s_directory);

SNR=[5 0 -5 -10];
for l=1:length(SNR)
create_test_h5f(c_fileList, SNR(l));
end

