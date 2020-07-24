function vG=compute_noise_gains(vSNR,v_signal,v_noise)
% fs=8000;
% %load hrir
% hrir= loadHRIR('Anechoic', 80, 0, 0,'in-ear');
% hrir=hrir.data;
% 
% %downsample hrir to fs of the original signals
% [P_hrir,Q_hrir] = rat(fs/48000);
% hrir=resample(hrir, P_hrir,Q_hrir);
% hrir=hrir(1:256,:)';
% 
% %convolution in frequency domain (to make it faster)
% v_signal_left=convtime(v_signal(1,:)',hrir(1,:)');
% v_signal_right=convtime(v_signal(2,:)',hrir(2,:)');
P_sig=sum(mean(v_signal.^2));
% P_sig_minus=mean(v_signal_right.^2);
% P_sig=P_sig_plus+P_sig_minus;
mean(v_noise.^2)
P_noise=sum(mean(v_noise.^2));

for g=1:length(vSNR)
    if vSNR(g)==Inf
        vG(g)=0;
    else
        G=P_sig/(10^(vSNR(g)/10));
        vG(g)=sqrt(G/P_noise);
    end
end
end
