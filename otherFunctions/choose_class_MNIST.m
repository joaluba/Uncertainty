function [ m_images_out, m_labels_out] = choose_class_MNIST(m_images_in,v_labels_in, v_classes_training,v_classes_testing, N)
%Function to choose only some of the classes from MNIST data set
% v_classes_training - a vector which helps to form labels vectors, with all the
% classes that are or were used for training NN
% v_classes_training - a vector containing classes we want to use for
% testing NN 


m_images_in=m_images_in';
[N_all, D]=size(m_images_in);

m_images_out=zeros(N, D);
% m_labels_out=zeros(N,10);
m_labels_out=zeros(N,length(v_classes_training));

for n=1:N
    ifClass=0;
    while ifClass~=1
        rand_idx=randi(length(v_labels_in));
        Class=v_labels_in(rand_idx);
        ifClass=sum(Class==v_classes_testing);
    end
    m_images_out(n,:)=m_images_in(rand_idx,:);
    for i=1:length(v_classes_training)
        if Class==v_classes_training(i)
            m_labels_out(n,i)=1;
        end
    end
    
    end
        
%     m_labels_out(n,Class+1)=1;

end

