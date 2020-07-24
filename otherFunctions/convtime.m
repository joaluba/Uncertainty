function v_signal= convtime(v_signal,hrir)
            nx = length(v_signal);nh = length(hrir);nfft = 2^nextpow2(nx+nh-1);
            xzp = [v_signal', zeros(1,nfft-nx)];hzp = [hrir', zeros(1,nfft-nh)];
            X=fft(xzp);H=fft(hzp);
            Y = H .* X;format bank;
            y = real(ifft(Y));
            v_signal = y(1:nx+nh-1)';
end
