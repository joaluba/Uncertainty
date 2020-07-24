function [m_data_binaural m_Labels_out]=GenBinauralData_SpecSlice(sParamTest,angle,nr_slices,nr)

        c_Classes={'b','d','g','p','t','k','dx','bcl','dcl','gcl','pcl','tcl','kcl','jh','ch',...
            's','sh','z','zh','f','th','v','dh','m','em','n','nx','ng','en','l','el','r','w',...
            'y','hh','hv','iy','ih','eh','ey','ae','aa','aw','ay','ah','ao','oy','ow','uh','uw',...
            'er','axr','ax','ix','h#','q'};
%Angle has to be in the range : -180:5:180 (angles of the source position)
%             m_data_h5_L=h5read(['/Uncertainty_Data/TestData/TIMIT_MELSPEC_',num2str(angle)],  ['/data_',num2str(angle)]); 
%             m_data_h5_R=h5read(['/Uncertainty_Data/TestData/TIMIT_MELSPEC_',num2str(-angle)],  ['/data_',num2str(-angle)]); 
%             
%             [F,T]=size(m_data_h5_R);

F=23;
T=1551800;%1551877;

    % for each angle completely random data points
    if sParamTest.gen_each_time==1 && strcmp(sParamTest.frames,'rand')
    t=randi(T,sParamTest.N,1);
    % consecutive sequences through all angles (head rotation while listening)
    elseif sParamTest.gen_each_time==1 && strcmp(sParamTest.frames,'conseq')
    start=sParamTest.startat;
    t=start+(nr-1)*sParamTest.N:1:start+nr*sParamTest.N;
    % for each angle the same sequence
    elseif sParamTest.gen_each_time==0 && strcmp(sParamTest.frames,'conseq')
    start=sParamTest.startat;
    t=start:1:start+ sParamTest.N;
    end

m_data_binaural=zeros(sParamTest.N,nr_slices*F*2);
count=1;
for n=1:sParamTest.N

    if t(n)-(nr_slices-1)/2>0 && t(n)+(nr_slices-1)/2<T  
    if sParamTest.noise==0
    feat_vec_L=reshape(h5read(['TIMIT_MELSPEC_',num2str(angle)],  ['/data_',num2str(angle)], [1 t(n)-((nr_slices-1)/2)], [F,nr_slices]),nr_slices*F,1); 
    feat_vec_R=reshape(h5read(['TIMIT_MELSPEC_',num2str(-angle)],  ['/data_',num2str(-angle)], [1 t(n)-((nr_slices-1)/2)], [F,nr_slices]),nr_slices*F,1); 
    elseif strcmp(sParamTest.noise,'diff_ss')
%     feat_vec_L=reshape(h5read(['TIMIT_MELSPEC_SNR',num2str(sParamTest.SNR),'ang',num2str(angle)],  ['/data_',num2str(angle)], [1 t(n)-((nr_slices-1)/2)], [F,nr_slices]),nr_slices*F,1); 
%     feat_vec_R=reshape(h5read(['TIMIT_MELSPEC_SNR',num2str(sParamTest.SNR),'ang',num2str(-angle)],  ['/data_',num2str(-angle)], [1 t(n)-((nr_slices-1)/2)], [F,nr_slices]),nr_slices*F,1);
  
if angle>=0
feat_vec_L=reshape(h5read(['TIMIT_MELSPEC_SNR',num2str(sParamTest.SNR),'ang',num2str(angle)],  ['/data_L',num2str(angle)], [1 t(n)-((nr_slices-1)/2)], [F,nr_slices]),nr_slices*F,1); 
feat_vec_R=reshape(h5read(['TIMIT_MELSPEC_SNR',num2str(sParamTest.SNR),'ang',num2str(angle)],  ['/data_R',num2str(angle)], [1 t(n)-((nr_slices-1)/2)], [F,nr_slices]),nr_slices*F,1);
else
feat_vec_R=reshape(h5read(['TIMIT_MELSPEC_SNR',num2str(sParamTest.SNR),'ang',num2str(-angle)],  ['/data_L',num2str(-angle)], [1 t(n)-((nr_slices-1)/2)], [F,nr_slices]),nr_slices*F,1); 
feat_vec_L=reshape(h5read(['TIMIT_MELSPEC_SNR',num2str(sParamTest.SNR),'ang',num2str(-angle)],  ['/data_R',num2str(-angle)], [1 t(n)-((nr_slices-1)/2)], [F,nr_slices]),nr_slices*F,1);
end
    end
    

    
        % normalize with offset
        feat_vec_L=feat_vec_L./sum(feat_vec_L);
        feat_vec_L= (sParamTest.A-length(feat_vec_L))*feat_vec_L +1;
        
        feat_vec_R=feat_vec_R./sum(feat_vec_R);
        feat_vec_R= (sParamTest.A-length(feat_vec_R))*feat_vec_R +1;
        
        m_data_binaural(count,:)=[feat_vec_L' feat_vec_R'];
        
        %labels
        v_labels(count)=h5read('TIMIT_mel_frame','/label', [3 t(n)], [1 1]);

        count=count+1;
        


    end
    

end

    
            m_Labels_out=binaryLabels(v_labels,c_Classes);
            m_Labels_out=m_Labels_out';
end

            
