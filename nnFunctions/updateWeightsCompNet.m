function [m_W , v_W_av,  v_deltaW_av]= updateWeightsCompNet(v_Y,m_W,v_S,eps)
% Function, which provides the unsupervised learning of the weight-matrix W
%
% INPUT:   v_Y   - Data input vector (1xD row vector)
%          m_W      - current weight matrix of the Neural Network (HxD Matrix)
%          v_S   - current activity pattern of output layer (Hx1 column vector)
%          eps    - learning rate
%
% OUTPUT: m_W      - updated weight matrix (HxD)
%         v_W_av   - averaged across dimensions weigths for each class (Hx1)
%         v_deltaW_av   - averaged acrossdimensions weight updates for each class (Hx1)
%
% Author: Joanna Luberadzka




% D: Number of Input Neurons
% H: Number of Hidden (output) neurons


% Update W
[H D]=size(m_W);

deltaW=zeros(size(m_W));

for h=1:H
    for d=1:D
        deltaW(h,d)= eps*(v_S(h)*v_Y(d) - v_S(h)*m_W(h,d));% How close are the old weights to the actual data?
        m_W(h,d) = m_W(h,d) + deltaW(h,d); %each element in the matrix is separately updated
        
    end
end


%Average weights
v_W_av=sum(m_W,2);
%Average delta W
% deltaW_av=sum(deltaW,2);
A=120;
v_deltaW_av=zeros(H,1);
for h=1:H
v_deltaW_av(h)=eps*v_S(h)*(A-v_W_av(h));
end

