function [ v_Entropy,v_BVSB, v_angles_test, v_Error]=test_for_each_angle(m_B,m_W,sParamTest)

%This is a function used to perform the testing procedure for different
%angles and then to compute the average uncertainty (entropy,bvsb,classification error)  for
%each azimuth. Data points are also generated within the function.

% for creating testing-video
% fid = figure;
% if sParamTest.display
%     writerObj = VideoWriter('testing_slide.avi'); % Name it.
%     writerObj.FrameRate = 60; % How many frames per second.
%     open(writerObj);
% end

% head positions during test
stepsize=5;
if sParamTest.position(1)<sParamTest.position(3)
    v_head=sParamTest.position(1):stepsize: sParamTest.position(3);
elseif  sParamTest.position(1)>sParamTest.position(3)
v_head_l=[sParamTest.position(1):stepsize:360];
v_head_r=stepsize:stepsize:sParamTest.position(3);
v_head=[v_head_l v_head_r];
end


% allocate variables
v_BVSB=zeros(size(v_head));
v_Entropy=zeros(size(v_head));
%v_Error=zeros(size(v_head));
% m_correct_probab=zeros(sParamTest.N,size(m_B,1));
% c_correct_probab =cell(length(v_head));
v_angles_test=zeros(size(v_head));

%calculating the angles which have to be simulated
for j=1:length(v_head)
    src_pos=sParamTest.position(2)-v_head(j);
    if src_pos<=0
        src_pos=360+src_pos;
    end
    v_angles_test(j)=src_pos;
end

    
for kk=1:length(v_angles_test)

    % .....................create N data points......................
    
        %  sParamTest.angle=v_angles_test(j);
        
        if strcmp('images',sParamTest.datatype)
            if sParamTest.display
                [m_YOut_test, m_labels_test,m_thetasOptimal,ratio ] = GenBinImages_FromCauses(sParamTest.dirName, sParamTest.N, sParamTest.A, sParamTest.classes_train,sParamTest.classes_test, sParamTest.angle);
            else
                [m_YOut_test, m_labels_test,~] = GenBinImages_FromCauses(sParamTest.dirName, sParamTest.N, sParamTest.A, sParamTest.classes_train,sParamTest.classes_test, sParamTest.angle);
            end
        elseif strcmp('spectrograms',sParamTest.datatype)
            if sParamTest.display
                [m_YOut_test, m_labels_test,m_thetasOptimal ] = GenBinSpectr_FromCauses(sParamTest);
            else
                [m_YOut_test, m_labels_test,~] = GenBinSpectr_FromCauses(sParamTest);
            end
        elseif strcmp('mnist',sParamTest.datatype)
            images_MNIST = loadMNISTImages('train-images.idx3-ubyte');
            labels_MNIST = loadMNISTLabels('train-labels.idx1-ubyte');
            [m_YOut_test_mono, m_labels_test] = choose_class_MNIST(images_MNIST,labels_MNIST, sParamTest.classes_train,sParamTest.classes_test, sParamTest.N);
            [m_YOut_test,m_thetasOptimal] = GenerateBinauralData_FromData(m_YOut_test_mono, sParamTest.A, v_angles_test(kk));
            
        elseif strcmp('spectral_slices',sParamTest.datatype)
            if v_angles_test(kk)>180
                v_angles_test(kk)= -(360-v_angles_test(kk));
            end;
            [m_YOut_test m_labels_test]=GenBinauralData_SpecSlice(sParamTest,v_angles_test(kk),5,kk);
        end
    
    
    % ...................testing neural network....................
    
    %     m_correct_probab(:,:,j) = testNeuralNetwork(m_YOut_test, m_B, m_W); %m_W comes from training
    %     m_correct_probab=max(m_correct_probab,eps);
    m_correct_probab=testNeuralNetwork(m_YOut_test, m_B, m_W); %m_W comes from training
    m_correct_probab=max(m_correct_probab,eps);
    
    %     c_correct_probab{j} = m_correct_probab;
    
    
    
    % ........................uncertainty........................
   
    nr_average=sParamTest.N;
    v_Entropy_test=zeros(sParamTest.N,1);
    v_BVSB_test=zeros(sParamTest.N,1);
    for n=1:sParamTest.N
        v_Entropy_test(n)=-(sum(log(m_correct_probab(n,:)).*m_correct_probab(n,:))); % v_Entropy=-(sum(log(v_sTest).*v_sTest));
        v_sorted=sort(m_correct_probab(n,:));
        v_BVSB_test(n)=v_sorted(end)-v_sorted(end-1);
        if isnan(v_Entropy_test(n))
            v_Entropy_test(n)=0;
            nr_average=nr_average - 1;
        end
    end
    
    if nr_average==0
        v_Entropy(kk)=0;
    else
        v_Entropy(kk)=1/nr_average*(sum(v_Entropy_test));
    end
    v_BVSB(kk)=-mean(v_BVSB_test);

    %................ Classification error .....................
    
        [v_max, v_MAP_correct]=max(m_correct_probab,[],2);% result of the classification
        [v_max, v_MAP_labels]=max(m_labels_test ,[],1);%labels in integer form (which class)
        v_Error(j)=length(find(v_MAP_correct~=v_MAP_labels'))/length(v_MAP_labels);
    
    
end

% v_Error=0;

% close(writerObj); % Saves the movie.
end





