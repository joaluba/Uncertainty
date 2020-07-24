function v_mixed =add_noise(v_signal,v_noise,SNR)
P_sig=mean(v_signal.^2);
P_noise=mean(v_noise.^2);
G=P_sig/(10^(SNR/10));
v_noise_add=sqrt(G/P_noise)*v_noise;
v_mixed=v_signal+v_noise_add;
end

