function c_fileList_wav= conv_files_hrir(c_fileList,angle,sNoise,SNR)
% A script to convolve the files from a given directory with 
% HRIRs and to add noise corresponding to given SNR.

[ble remain]= strtok(fliplr(c_fileList{1}),'/');
[ble dir]= strtok(remain,'/');dir=fliplr(dir);

c_fileList_wav={};
counter=0;
for k=1:length(c_fileList)
    %load if it is a wav file
    wav_name=c_fileList{k};
    if strcmp(wav_name(end-3:end),'.wav') || strcmp(wav_name(end-3:end),'.WAV')
        counter=counter+1;
        
        [v_signal, fs]=audioread(c_fileList{k});
        
        %load hrir
        hrir= loadHRIR('Anechoic', 80, 0, angle,'in-ear');
        hrir=hrir.data;
        
        %downsample hrir to fs of the original signals
        [P_hrir,Q_hrir] = rat(fs/48000);
        hrir=resample(hrir, P_hrir,Q_hrir);
        hrir=hrir(1:256,:);
        %convolution in frequency domain (to make it faster)
        v_signal=[convtime(v_signal,hrir(:,1)) convtime(v_signal,hrir(:,2))];
        %noise
        [v_noise_o, fs2]=audioread(sNoise.filename);
        %downsample noise
        [P_noise,Q_noise] = rat(fs/fs2);
        v_noise=resample(v_noise_o, P_noise,Q_noise);
        %pick random start point of the noise file
        start=randi(length(v_noise)-length(v_signal));
        %cut the noise to the length of the signal
        v_noise=v_noise(start+1:start+length(v_signal),:);
        %scale the noise
        if counter==1
            G=compute_noise_gains(SNR,v_signal,v_noise)
        end
        v_noise2add=G*v_noise;
        
        %noise is calibrated on the left ear always!
        v_signal_noise= v_signal+v_noise2add;
        %cut the additional filter length
        v_signal_noise =v_signal_noise(1:end-256+1,:);
        
        if counter==1
        summm=snr(v_signal, v_noise2add)
        le=snr(v_signal(:,1), v_noise2add(:,1))
        ri=snr(v_signal(:,2), v_noise2add(:,2))
        end
        
        %cut just the name of the file
        name=fliplr(c_fileList{k});
        name=strtok(name,'/');
        name=fliplr(name);
        
        %create directory
%         if angle==0        %save the current convolved file
            p1=[dir,'speechdata_wav_L',num2str(angle),'/'];
            p2=[dir,'speechdata_wav_R',num2str(angle),'/'];
%         else
%             p1=[dir,'speechdata_wav_',num2str(angle),'/'];
%             p2=[dir,'speechdata_wav_',num2str(-angle),'/'];
%         end
        
        if counter==1 mkdir(p1);mkdir(p2); end

        audiowrite([p1,num2str(angle),name],v_signal_noise(:,1),fs)
        audiowrite([p2,num2str(angle),name],v_signal_noise(:,2),fs)
        
%         y=[1 200 1000 3000] 
%         if sum(counter==y)
%         audiowrite([dir,'examples/',num2str(SNR),'_',num2str(angle),'_',name],v_signal_noise,fs)
%         end
        
        
        c_fileList_wav(counter,:)={[p1,num2str(angle),name],[p2,num2str(angle),name]};
        
    end
    
end

end
