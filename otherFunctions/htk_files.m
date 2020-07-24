function c_fileList_htk=htk_files(fileList,angle)

[ble remain]= strtok(fliplr(fileList{1}),'/');
[ble dir]= strtok(remain,'/');dir=fliplr(dir);

%% 2. Create directory with htk files computed based on previously create wav files
% if angle==0
    p_wav1=[dir,'speechdata_wav_L',num2str(angle),'/'];
    p_wav2=[dir,'speechdata_wav_R',num2str(angle),'/'];
    list_name1=[dir,'list_L', num2str(angle),'.slist'];
    list_name2=[dir ,'list_R', num2str(angle),'.slist'];
% else
%     p_wav1=[dir,'speechdata_wav_',num2str(angle),'/'];
%     p_wav2=[dir,'speechdata_wav_',num2str(-angle),'/'];
%     list_name1=[dir,'list_', num2str(angle),'.slist'];
%     list_name2=[dir ,'list_', num2str(-angle),'.slist'];
% end

p_htk1=strrep(p_wav1,'wav','htk');system(['mkdir ', p_htk1]);
p_htk2=strrep(p_wav2,'wav','htk');system(['mkdir ', p_htk2]);

c_fileList_htk=strrep(fileList, 'wav', 'htk');
system(['touch ', list_name1]);
system(['touch ', list_name2]);

fileID = fopen(list_name1,'w');
for k=1:length(fileList)
    fprintf(fileID,'%s %s \n',fileList{k,1},c_fileList_htk{k,1});
    % system(['HCopy -C /home/joanna/Data/TIMIT/config ', c_fileList_wav{i},' ',c_fileList_htk{i}])
end
fclose(fileID);
[a b]= system(['HCopy -C ',dir,'conf_file -S ', list_name1]);

fileID = fopen(list_name2,'w');
for k=1:length(fileList)
    fprintf(fileID,'%s %s \n',fileList{k,2},c_fileList_htk{k,2});
    % system(['HCopy -C /home/joanna/Data/TIMIT/config ', c_fileList_wav{i},' ',c_fileList_htk{i}])
end
fclose(fileID);
system(['HCopy -C ',dir,'conf_file -S ', list_name2]);




end