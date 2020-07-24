function create_test_h5f(c_File_List,SNR)
% This is a script to create 72 H5files, where in each H5file the mel
% spectrum of a speech material convolved with 1 of the HRIR is stored.
% The wav files chosen from a TIMIT data base are first convolved with a
% a HRIR for a given angle.
% Then they are converted to htk features using htk toolbox and the set
% of htk files is converted to the H5F:
%
% wav * HRIR (+ noise)  ----> dir with .wav ---> dir with .htk ---> H5F
%
% For 1 SNR condition, all angles 

sNoise.filename='binaural_anechoic_diffuse_icra_16k.wav';

for angle=0:5:150;
    % wav * HRIR (+ noise)  ----> dir with .wav 
    c_fileList_wav=conv_files_hrir(c_File_List,angle,sNoise,SNR);
    % dir with .wav ---> dir with .htk
    c_fileList_htk=htk_files(c_fileList_wav,angle);
    % dir with .htk ---> H5F
    h5f_files(c_fileList_htk,angle, SNR);
    system(['rm -r ', '/media/joanna/daten/user/joanna/Data/TIMIT/speechdata_wav_*']);
    system(['rm -r ', '/media/joanna/daten/user/joanna/Data/TIMIT/speechdata_htk_*']);
end
end

