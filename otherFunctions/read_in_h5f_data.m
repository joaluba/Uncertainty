function DATA=read_in_h5f_data(start,source,stop,noise,SNR)

stepsize=5;
if start<stop
    v_head=start:stepsize:stop;
elseif start>stop
    v_head_l=[start:stepsize:360];
    v_head_r=stepsize:stepsize:stop;
    v_head=[v_head_l v_head_r];
end

v_angles_test=zeros(size(v_head));

%calculating the angles which have to be simulated
for j=1:length(v_head)
    src_pos=source-v_head(j);
    if src_pos<=0
        src_pos=360+src_pos;
    end
    v_angles_test(j)=src_pos;
end



DATA=zeros(2,length(v_angles_test),23,1551877);
for i=1:length(v_angles_test)
    
    if v_angles_test(i)>180
        v_angles_test(i)= -(360-v_angles_test(i));
    end;
    if noise==0
        DATA(1,i,:,:)=h5read(['TIMIT_MELSPEC_',num2str(v_angles_test(i))],['/data_',num2str(v_angles_test(i))]);
        DATA(2,i,:,:)=h5read(['TIMIT_MELSPEC_',num2str(-v_angles_test(i))],['/data_',num2str(-v_angles_test(i))]);
    elseif strcmp(noise,'diff_ss')
        DATA(1,i,:,:)=h5read(['TIMIT_MELSPEC_SNR',num2str(SNR),'ang',num2str(v_angles_test(i))],['/data_',num2str(v_angles_test(i))]);
        DATA(2,i,:,:)=h5read(['TIMIT_MELSPEC_SNR',num2str(SNR),'ang',num2str(-v_angles_test(i))],['/data_',num2str(-v_angles_test(i))]);
    end
end

end


