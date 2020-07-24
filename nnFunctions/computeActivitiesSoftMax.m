function [v_S] = computeActivitiesSoftMax(v_Y, m_W, type)
% This is a function to compute activities of the downstream processing
% neurons using the Soft-Max function.
%
% INPUT:      v_Y            - column vector of input neurons's activity
%             m_W            - weight matrix (of size HxD)
%             s_type         - what type of calculation:
%                               *'logarithmic'
%                               *'linear'
%                               *'log_lin'
%
% OUTPUT:     v_S            - column vector of output neurons's activity
% 
% Author: Joanna Luberadzka



switch type
    
    case 'logarithmic' % -----> logarithmic for all values
        
        vI=log(m_W)*v_Y;
        
    case 'log_lin'  % -----> linear for W(h,d)<1
        
        [H D]=size(m_W);
        mI=zeros(H,D);
        vI=zeros(1,D);
        v_S=zeros(H,1);
        for h=1:H
            for d=1:D
                if m_W(h,d)>=1
                    mI(h,d)=(log(m_W(h,d))+1)*v_Y(d);
                elseif m_W(h,d)<1
                    mI(h,d)=m_W(h,d)*v_Y(d);
                end
            end
        end
        vI=sum(mI,2);
        
    case 'linear' %------> linear for all values
        
        vI=m_W*y;
        
end

% Correct for overflow, otherwise - numerical error!

for h=1:H
    
    if max(vI)<-740
        bl=-740-min(vI);
    elseif  max(vI)>700
        bl=700-max(vI);
    else
        bl=0;
    end
    
    vI=vI+bl;
    
    
    % COMPUTE ACTIVITIES ---> Soft-max function
        v_S(h)=exp(vI(h))./sum(exp(vI));
end


end
