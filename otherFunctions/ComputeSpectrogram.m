function [vTime Frequencies matSTFTAmplitudeSquared] = ComputeSpectrogram(vSignal, FrameShift,FrameLength,N)
%Function to compute spectrogtams of an input signal
%INPUT:
%vSignal                  input signal
%OUTPUT:
%vTime                    time instances
%Frequencies              center frequencies of frequency bins
%matSpectrograms          matrix containing spectrograms

%% splitting into frames, STFT
% FrameShift=10;
% FrameLength=32;
SamplingRate=16000;
% N=FrameLength*0.001*SamplingRate;
[matFrames, vTime]= myWindowing(vSignal, SamplingRate, FrameLength, FrameShift);
vAnalysisWindow= hann(FrameLength*0.001*SamplingRate, 'periodic');
[matSTFT, Frequencies] = mySTFT(matFrames, SamplingRate, N, vAnalysisWindow);
matSTFT=matSTFT(2:end,:);


% %% squared magnitude of DFT coefficients
% matSTFTAmplitudeSquared=log(max(abs(matSTFT).^2,10^(-50)));
matSTFTAmplitudeSquared=abs(matSTFT.^2);

end


