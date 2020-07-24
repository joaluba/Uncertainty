function m_B = B_matrix(m_labels, m_Y,m_W, M)
% Function to compute a B matrix - matrix showing the relationship between
% the input and the hidden layer i.e. which hidden unit corresponds to which
% class (and with which probability).
% INPUT:     m_labels      - matrix with labels for all data points in m_Y
%           m_Y           - data set
%           m_W           - weights learned in the training process
%           M             - number of data points used to compute B (in the
%                           same time its the number of labels we need to
%                           obtain a good classification performance %          
% OUTPUT:    m_B           - B matrix (KxH)
%
% Author: Joanna Luberadzka


%H-number of hidden neurons
%K-number of classes (input neurons)
%D-number of dimensions

[H,D]=size(m_W)
[N,K]=size(m_labels)


m_B=zeros(K,H);
[vVal, vClass]=max(m_labels,[],2); %vClass is a vector which sais to which class belongs each data point



%For each class k we pick M data points, of which we know that they come
%from class k (because we have the labels). We pick them randomly (from all 
%data points labeled as this class k)Then we compute activity (v_s) for each 
%of these picked data points. We average the activities over all M data points 
%and this is how we get one row of the B matrix (row number k).

for k=1:K
    %find indices of all patterns of class k
    k
    v_pattern_idx= find(vClass==k);
    v_SumOfMPoints=zeros(1,H);
    m=0;
    while m<M
        %randomly choose one index
        rand_idx = datasample(v_pattern_idx,1);
        
        %take data point corresponding to the rand_idx
         v_Y = m_Y(rand_idx,:)';
        v_sTrain = computeActivitiesSoftMax(v_Y,m_W,'log_lin'); %this vector has size (1xH)
        v_SumOfMPoints=v_SumOfMPoints+v_sTrain';
        m=m+1;
        
    end
    m_B(k,:) =(1/M).*v_SumOfMPoints;
end



end

