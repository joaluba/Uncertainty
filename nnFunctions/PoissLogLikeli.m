function LogLikelihood = PoissLogLikeli(m_Y, m_W)
% Function to compute the likelihood of the Poisson distribution given
% parameters W and data set Y
% INPUT:              m_Y               - matrix with data
%                     m_W               - matrix with currently calculated weights
% OUTPUT:             LogLikelyhood     - log likelyhood for the Poisson distribution for the
%                                         data set m_Y given parameters m_W
%
% Author: Joanna Luberadzka


[H,D]=size(m_W);
N=size(m_Y,1);
likeli_point=zeros(N,1);



for n=1:N
    yVec = (m_Y(n,:))';    
    logPoiss=zeros(D,1);
    for h=1:H
        for d=1:D
            logPoiss(d)=yVec(d)*log(m_W(h,d))-m_W(h,d)-log(yVec(d));% log(factorial(yVec(d)))
        end
    end
    %sum across all dimensions
    likeli_point(n)=sum(logPoiss);
end

%sum across all data points 
LogLikelihood=sum(likeli_point);


end

