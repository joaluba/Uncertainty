function h5f_files(c_fileList_htk,angle,SNR)

[ble remain]= strtok(fliplr(c_fileList_htk{1}),'/');
[ble dir]= strtok(remain,'/');dir=fliplr(dir);

p=[dir,'SNR',num2str(SNR)]
if~exist(p,'file')
    mkdir(p)
end



    h5create([dir,'SNR',num2str(SNR),'/TIMIT_MELSPEC_SNR',num2str(SNR),'ang',num2str(angle)],['/data_L',num2str(angle)],[23 Inf],'chunk',[23 1]);
    h5create([dir,'SNR',num2str(SNR),'/TIMIT_MELSPEC_SNR',num2str(SNR),'ang',num2str(angle)],['/data_R',num2str(angle)],[23 Inf],'chunk',[23 1]);



% if angle==0
%     h5create([dir,'SNR',num2str(SNR),'/TIMIT_MELSPEC_SNR',num2str(SNR),'angL',num2str(angle)],['/data_',num2str(angle)],[23 Inf],'chunk',[23 1]);
%     h5create([dir,'SNR',num2str(SNR),'/TIMIT_MELSPEC_SNR',num2str(SNR),'angR',num2str(-angle)],['/data_',num2str(-angle)],[23 Inf],'chunk',[23 1]);
% else
%     h5create([dir,'SNR',num2str(SNR),'/TIMIT_MELSPEC_SNR',num2str(SNR),'ang',num2str(angle)],['/data_',num2str(angle)],[23 Inf],'chunk',[23 1]);
%     h5create([dir,'SNR',num2str(SNR),'/TIMIT_MELSPEC_SNR',num2str(SNR),'ang',num2str(-angle)],['/data_',num2str(-angle)],[23 Inf],'chunk',[23 1]);
% end

startPoint1 = 1;
startPoint2 = 1;
for k=1:length(c_fileList_htk)
    
    [melFeatures1,frameInfo1] = load_htk(c_fileList_htk{k,1},0,1);
    [melFeatures2,frameInfo2] = load_htk(c_fileList_htk{k,2},0,1);
    
        h5write([dir,'SNR',num2str(SNR),'/TIMIT_MELSPEC_SNR',num2str(SNR),'ang',num2str(angle)],['/data_L',num2str(angle)],melFeatures1,[1 startPoint1], size(melFeatures1));
        h5write([dir,'SNR',num2str(SNR),'/TIMIT_MELSPEC_SNR',num2str(SNR),'ang',num2str(angle)],['/data_R',num2str(angle)],melFeatures2,[1 startPoint2], size(melFeatures2));
        
%     if angle==0
%         h5write([dir,'SNR',num2str(SNR),'/TIMIT_MELSPEC_SNR',num2str(SNR),'angL',num2str(angle)],['/data_',num2str(angle)],melFeatures1,[1 startPoint1], size(melFeatures1));
%         h5write([dir,'SNR',num2str(SNR),'/TIMIT_MELSPEC_SNR',num2str(SNR),'angR',num2str(angle)],['/data_',num2str(angle)],melFeatures2,[1 startPoint2], size(melFeatures2));
%     else
%         h5write([dir,'SNR',num2str(SNR),'/TIMIT_MELSPEC_SNR',num2str(SNR),'ang',num2str(angle)],['/data_',num2str(angle)],melFeatures1,[1 startPoint1], size(melFeatures1));
%         h5write([dir,'SNR',num2str(SNR),'/TIMIT_MELSPEC_SNR',num2str(SNR),'ang',num2str(angle)],['/data_',num2str(angle)],melFeatures2,[1 startPoint2], size(melFeatures2));
%     end
%     
    startPoint1 = startPoint1 + frameInfo1.nSamples;
    startPoint2 = startPoint2 + frameInfo2.nSamples;
end