function v_probNoiseModel = Poiss_DataPoint (v_Y, m_W) 
% Function to compute the probability of a data point (for a poisson
% probability distributuion) with parameters m_W
% INPUT:       v_Y             - data point
%              W               - matrix with weights
% OUTPUT:      P_NoiseModel    - probability of getting a data point from a given class
%
% Author: Joanna Luberadzka

[H,D]=size(m_W);

    vPoiss=zeros(H,D);
    for h=1:H
        for d=1:D
            vPoiss(h,d)=((m_W(h,d).^v_Y(d))*(exp(-m_W(h,d))))./gamma(v_Y(d)+1); 
        end
    end
    
    v_probNoiseModel=prod(vPoiss,2);
    
   
end
