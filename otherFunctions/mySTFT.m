function [matSTFT, vFreq] = mySTFT(matFrames, SamplingRate, FFTLength, vAnalysisWindow)
%% function to compute Short time fourier transform of the signal
%INPUT:
% matFrames          contains the overlapping signal frames which have been generated using the function
%                    myWindowing.m
% SamplingRate       sampling rate in Hz
% FFTLength          number of samplings points for the discrete Fourier transform (DFT)
% vAnalysisWindow    a vector which contains an analysis window (This vector should have the same length
%                    as the blocks contained in matFrames)
% OUTPUT:
% matSTFT            a matrix which stores the complex short-time spectra in each row / column
% vFreq              a vector which contains the frequency axis (in units of Hertz) corresponding to the
%                    computed spectra

vFreq = SamplingRate/2*linspace(0,1,FFTLength/2+1);%frequency vector

matSTFT=zeros(FFTLength/2+1,size(matFrames,2));
for i=1:size(matFrames,2);
    v_block=matFrames(:,i);
    v_block_win=v_block.*vAnalysisWindow;
    v_fft= fft(v_block_win,FFTLength);
    matSTFT(:,i)=v_fft(1:round(length(v_fft)/2)+1); % half of the spectrum stored in each column
    
end
end



