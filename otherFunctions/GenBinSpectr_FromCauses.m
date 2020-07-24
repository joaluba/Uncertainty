function [m_out, m_labelsOut , m_ThetasOptimal]= GenBinSpectr_FromCauses(sGenParam)
%This is a function to generate binaural noisy data points (spectrograms) based on
%generative fields.
% ---Generative Parameters:---
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

shift=0.1;

%sth is wrong here (with ls probably)
% dirString = strcat (sGenParam.dirName,'*.mat');
% theFilesTemp = ls('-1',dirString);
% theFileNames = strsplit (theFilesTemp,'\n');

theFileNames=load('filenames.mat');
theFileNames=theFileNames.theFileNames;
NrClasses = size (theFileNames,2);
NrClasses = NrClasses - 1;



if nargout>2
%% Compute Thetas Optimal
for i=1:NrClasses
    % pick one of the generative waveforms
    inName = theFileNames{i};
    v_class_waveform = load(inName,'-mat');
    v_class_waveform=v_class_waveform.v_phoneme_temp_norm;
    %directionality information
    if strcmp(sGenParam.directionInfo,'only_gain')
        [G_R, G_L]=pickGain(sGenParam.angle,'cardio');
        v_wavefrom_L=v_class_waveform*G_L;
        v_wavefrom_R=v_class_waveform*G_R;
    elseif strcmp(sGenParam.directionInfo,'hrtf')
        [v_HRIR_left, v_HRIR_right] = pick_HRIR(sGenParam.angle);
        v_wavefrom_L=conv(v_class_waveform,v_HRIR_left);
        v_wavefrom_R=conv(v_class_waveform,v_HRIR_right);
    end
    %compute spectrograms of left and right waveform
    [ ~ ,~,m_spectrogram_L] = ComputeLogSpectrogram(v_wavefrom_L,25,32,64);
    [ ~ ,~,m_spectrogram_R] = ComputeLogSpectrogram(v_wavefrom_R,25,32,64);
    [f t]=size(m_spectrogram_L);
    D=f*t;
    vDataPoint_L=reshape(m_spectrogram_L,D,1);
    vDataPoint_R=reshape(m_spectrogram_R,D,1);
    vDataPoint=[vDataPoint_L ; vDataPoint_R];
    %scale so that it only has values between zero and one
    minC = min(vDataPoint);%min value in the image
    maxC = max(vDataPoint);%max value in the image
    if ((maxC-minC) ~= 0)
        vDataPoint = double ( (vDataPoint-minC) / (maxC-minC) );
    else
        vDataPoint = zeros(w,h);
    end
    %shift so that it doesn't contain zeros
    vDataPoint = vDataPoint+shift;
    % normalize with offset
    vDataPoint=vDataPoint./sum(vDataPoint);
    vDataPoint= (sGenParam.A-2*D)*vDataPoint +1;
    m_ThetasOptimal(i,:)=vDataPoint;
end

end


%% Generate data points
m_labelsOut = zeros(sGenParam.N,length(sGenParam.classes_train));

for n=1:sGenParam.N;
    
    %randomly pick one of the generative waveforms
    rand_class_nr=datasample(sGenParam.classes_test,1);
    
    attempts=0;
    try
    inName = theFileNames{sGenParam.classes_train(rand_class_nr)};
    catch
        if attempts<10
            attempts=attempts+1
        else error(lasterror)
        end
    end
    
    v_class_wavefrom = load(inName,'-mat');
    v_class_wavefrom=v_class_wavefrom.v_phoneme_temp_norm;
    
    if strcmp(sGenParam.noise,'no')
    v_class_wavefrom_L=v_class_wavefrom;
    v_class_wavefrom_R=v_class_wavefrom;
    elseif strcmp(sGenParam.noise,'white')
    v_class_wavefrom_L=v_class_wavefrom+0.01*randn(1,length(v_class_wavefrom));
    v_class_wavefrom_R=v_class_wavefrom+0.01*randn(1,length(v_class_wavefrom));
    elseif strcmp(sGenParam.noise,'babble')
    v_class_wavefrom_L;
    v_class_wavefrom_R;
    end
    
    
    %directionality information
    if strcmp(sGenParam.directionInfo,'only_gain')
        
        [G_R, G_L]=pickGain(sGenParam.angle,'cardio');
        v_wavefrom_L=v_class_wavefrom_L*G_L;
        v_wavefrom_R=v_class_wavefrom_R*G_R;
        
        
    elseif strcmp(sGenParam.directionInfo,'hrtf')
        
        [v_HRIR_left, v_HRIR_right] = pick_HRIR(sGenParam.angle);
        
%in frequency domain
%LEFT SIDE
nx = length(v_class_wavefrom_L);nh = length(v_HRIR_left);nfft = 2^nextpow2(nx+nh-1);
xzp = [v_class_wavefrom_L, zeros(1,nfft-nx)];hzp = [v_HRIR_left', zeros(1,nfft-nh)];
X=fft(xzp);H=fft(hzp);
Y = H .* X;format bank;
y = real(ifft(Y));
v_wavefrom_L = y(1:nx+nh-1);
%RIGHT SIDE
nx = length(v_class_wavefrom_R);nh = length(v_HRIR_right);nfft = 2^nextpow2(nx+nh-1);
xzp = [v_class_wavefrom_R, zeros(1,nfft-nx)];hzp = [v_HRIR_right', zeros(1,nfft-nh)];
X=fft(xzp);H=fft(hzp);
Y = H .* X;format bank;
y = real(ifft(Y));
v_wavefrom_R = y(1:nx+nh-1);


%         %in time domain)
%         v_wavefrom_L=conv(v_class_wavefrom_L,v_HRIR_left);
%         v_wavefrom_R=conv(v_class_wavefrom_R,v_HRIR_right);
        
    end
    
    %compute spectrograms of left and right waveform
    [ ~ ,~,m_spectrogram_L] = ComputeLogSpectrogram(v_wavefrom_L,25,32,64);
    [ ~ ,~,m_spectrogram_R] = ComputeLogSpectrogram(v_wavefrom_R,25,32,64);

%     [ ~ ,~,m_spectrogram_L] = ComputeSpectrogram(v_wavefrom_L,25,32,64);
%     [ ~ ,~,m_spectrogram_R] = ComputeSpectrogram(v_wavefrom_R,25,32,64);
    
    %dimensions 
    [f t]=size(m_spectrogram_L);
    D=f*t;
    if n==1
     m_out = zeros(sGenParam.N,2*D);
    end
    
    vDataPoint_L=reshape(m_spectrogram_L,D,1);
    vDataPoint_R=reshape(m_spectrogram_R,D,1);
    vDataPoint=[vDataPoint_L ; vDataPoint_R];
    
    %scale so that it only has values between zero and one
    minC = min(vDataPoint);%min value in the image
    maxC = max(vDataPoint);%max value in the image
    
    
    if ((maxC-minC) ~= 0)
        vDataPoint = double ( (vDataPoint-minC) / (maxC-minC) );
    else
        vDataPoint = zeros(w,h);
    end
    
    
    % shift so that it doesn't contain zeros
    vDataPoint = vDataPoint+shift;
    
    
    %add poisson noise to the generative field
    vDataPoint =poissrnd(vDataPoint);%poisson noise
    

    % normalize with offset
    vDataPoint=vDataPoint./sum(vDataPoint);
    vDataPoint= (sGenParam.A-2*D)*vDataPoint +1;
    
    

    
    %store a vector with data point as one row of the final matrix
    m_out(n,:) = vDataPoint;
    
    % create matrix with labels --> each row e.g. 0 1 0 0;0 0 0 1 etc.
    m_labelsOut(n,rand_class_nr) = 1;
    
    
end

end






