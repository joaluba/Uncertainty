function [m_Data_out, m_Labels_out] = create_data_points_train(nr_slices,SNR,sTrainingParam)
% This is a function to create a data set which consists of desired feature
% vectors. Feature vectors cn contain different number of MFCC frames.
% ----INPUT:----
% nr_slices - number of slices which will be contained in 1 data point
% m_Data_in - matrix with originally extracted features
% m_Labels_in - matrix with original labels
% ----OUTPUT:----
% m_Data_out  - matrix with new feature vectors
% m_Labels_in - matrix with new labels (the label is always taken from the
%               central frame)
%
% Author: Joanna Luberadzka

if ~mod(nr_slices,2)
    error('nr of slices has to be odd!')
end

F=23;
T=1535743;
angle=0;

% m_Data_out=zeros(sTrainingParam.NperNoise,nr_slices*F*2);
count=1;
t=randi(T,sTrainingParam.NperNoise,1);
for n=1:sTrainingParam.NperNoise
    if t(n)-(nr_slices-1)/2>0 && t(n)+(nr_slices-1)/2<T
        feat_vec_L=reshape(h5read(['TRAIN_TIMIT_MELSPEC_SNR',num2str(SNR),'ang',num2str(angle)],  ['/data_',num2str(angle)], [1 t(n)-((nr_slices-1)/2)], [F,nr_slices]),nr_slices*F,1);
        
        feat_vec_L=feat_vec_L./sum(feat_vec_L);
        feat_vec_L= (sTrainingParam.A-length(feat_vec_L))*feat_vec_L +1;
        
        m_Data_out(count,:)=[feat_vec_L' feat_vec_L'];
        
        v_labels(count)=h5read('TIMIT_mel_frame','/label', [3 t(n)], [1 1]);
        c_Classes={'b','d','g','p','t','k','dx','bcl','dcl','gcl','pcl','tcl','kcl','jh','ch',...
            's','sh','z','zh','f','th','v','dh','m','em','n','nx','ng','en','l','el','r','w',...
            'y','hh','hv','iy','ih','eh','ey','ae','aa','aw','ay','ah','ao','oy','ow','uh','uw',...
            'er','axr','ax','ix','h#','q'};
        
        count=count+1;
    end
    

end

            m_Labels_out=binaryLabels(v_labels,c_Classes);
            m_Labels_out=m_Labels_out';
end

