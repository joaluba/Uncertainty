clc
clear 
close all


SNR=[-10 -5 0 5];

parfor l=1:length(SNR)
    create_test_h5f(SNR(l))
end
