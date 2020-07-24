function m_ClassProb = testNeuralNetwork(m_Y, m_B, m_W)
%Function to test the neural network - based on the knowledge from the
%training (weights and B-matrix) , for a data point we compute the
%probabilities that it comes from each class.
%INPUT:   m_Y   - matrix with test data set
%         m_B   - B matrix (relation between hidden and input layer)
%         m_W   - weights learned during training (hidden units)
%OUTPUT:  m_ClassProb   - result of the classification task: with which
%         probability a given data point belongs to which class
%
% Author: Joanna Luberadzka



% Formula 36 in the Keck's paper was rewritten - we take exp(log(..)) of
% what is inside the sum and this is what we get:

[K,H] =size(m_B);

m_ClassProb=zeros(size(m_Y,1),K);
explog=zeros(H,K);

for n=1:size(m_Y,1)
    
    v_Y = (m_Y(n,:))';
    
    vI=log(m_W)*v_Y;
    
    %if the spread is bigger than a range, get rid of the smallest values
    
    [val_min, idx_min]=min(vI);
    
    while abs(max(vI)-val_min)>=1440
        vI(idx_min)=[];
        [val_min, idx_min]=min(vI);
        
    end
    
    
    if max(vI)<-740
        bl=-740-min(vI);
    elseif  max(vI)>700
        bl=700-max(vI);
    else
        bl=0;
    end
    
    vI=vI+bl;
    
    
for k=1:K
    for h=1:length(vI)
            explog(h,k)=m_B(k,h)* exp( vI(h));
    end
end

m_ClassProb(n,:)=sum(explog)./sum(sum(explog));

end



end
