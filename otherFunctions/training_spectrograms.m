function [m_B, m_W]= training_spectrograms(sTrainingParam)
% This is a function to perform training of the neural network for a given
% set of parameters and given generative fields. Depending on the type of
% data used, the sTrainingParam contains different fields (there are some
% common parameters which have to be specified always like A,H, eps, etc.)
% ----OUTPUT:----
% m_B  - B_matrix(mapping from middle to output layer)
% m_W  - weights (mapping from input to middle layer)
%
% Author: Joanna Luberadzkas


%Generate training set
   if strcmp('images',sTrainingParam.datatype)
       [m_YOut_train, m_labels_train,~ ] = GenBinImages_FromCauses(sTrainingParam.dirName, sTrainingParam.N, sTrainingParam.A, sTrainingParam.classes_train,sTrainingParam.classes_test, sTrainingParam.angle);
   elseif strcmp('spectrograms',sTrainingParam.datatype)
       [m_YOut_train, m_labels_train,~ ] = GenBinSpectr_FromCauses(sTrainingParam);
       
   elseif strcmp('mnist',sTrainingParam.datatype) 
       images_MNIST = loadMNISTImages('train-images.idx3-ubyte');
       labels_MNIST = loadMNISTLabels('train-labels.idx1-ubyte');
       [m_YOut_train_mono, m_labels_train] = choose_class_MNIST(images_MNIST,labels_MNIST, sTrainingParam.classes_train,sTrainingParam.classes_test, sTrainingParam.N);
       [m_YOut_train] = GenerateBinauralData_FromData(m_YOut_train_mono, sTrainingParam.A, sTrainingParam.angle);
       
   elseif strcmp('OLLO_spectrograms',sTrainingParam.datatype)
       %for these data only directionInfo of type hrtf defined
       [m_YOut_train, m_labels_train] =GenerateBinSpec_OLLO(sTrainingParam);
       
   elseif strcmp('spectral_slices',sTrainingParam.datatype)
%        m_data_h5=h5read('/Uncertainty_Data/TrainData/TIMIT_mel_frame', '/data');
%        m_labels_h5=h5read('/Uncertainty_Data/TrainData/TIMIT_mel_frame', '/label');
%        c_Classes={'b','d','g','p','t','k','dx','bcl','dcl','gcl','pcl','tcl','kcl','jh','ch',...
%            's','sh','z','zh','f','th','v','dh','m','em','n','nx','ng','en','l','el','r','w',...
%            'y','hh','hv','iy','ih','eh','ey','ae','aa','aw','ay','ah','ao','oy','ow','uh','uw',...
%            'er','axr','ax','ix','h#','q'};
%       [m_data_mono, m_labels_train] = create_data_points_train(5,m_data_h5,m_labels_h5, sTrainingParam);
%       %change the labels to binary labels
%       m_labels_train=binaryLabels(m_labels_train(3,:),c_Classes);
%       m_YOut_train=[m_data_mono;m_data_mono]';
m_YOut_train=[];
m_labels_train=[];
SNR=[-10 -5 0 5 Inf];
  for s=1:length(SNR)
      [m_YOut_train_tmp, m_labels_train_tmp] = create_data_points_train(5,SNR(s),sTrainingParam);
      m_YOut_train=[m_YOut_train; m_YOut_train_tmp];
      m_labels_train=[m_labels_train m_labels_train_tmp];
   end   
   end
   
sTrainingParam.N=size(m_YOut_train,1);
% Initialize weights
v_m=sum(m_YOut_train)/sTrainingParam.N;
v_v=sum(bsxfun(@minus,m_YOut_train,v_m).^2)/sTrainingParam.N;
for h=1:sTrainingParam.H
    m_W(h,:)=v_m + 2*v_v.*rand(length(v_v),1)'; 
end

% % no training condition
% m_W=zeros(sTrainingParam.H,size(m_YOut_train,2));
% for h=1:sTrainingParam.H
%     D=size(m_YOut_train,2);
%     v_W=abs(randn(1,D));
%     v_W=v_W./sum(v_W);
%     v_W= (sTrainingParam.A-D)*v_W +1;
%     m_W(h,:)=v_W;
% end



%Compute weights
[m_W, ~, ~]=trainNeuralNetwork(m_W,m_YOut_train,sTrainingParam.epsilon,sTrainingParam.display);
% [m_W, m_DeltaW_av, m_W_av, v_LogLikelihood]=trainNeuralNetwork(m_W,m_YOut_train,epsilon);

% save('m_W.mat','m_W');
% load('m_W.mat');

%Compute B_matrix
m_B = B_matrix(m_labels_train', m_YOut_train, m_W,sTrainingParam.M);

