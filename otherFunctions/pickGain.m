function [G_R G_L]=pickGain(az,s_type)


az=az*(pi/180);

%We assume ear is set at an angle of 60° to the side
az_R=az-40*(pi/180);
az_L=az+40*(pi/180);


switch s_type
    
    case 'eight'
        
        G_R=abs(cos(az_R));
        G_L=abs(cos(az_L));
        
    case 'cardio'
        
        G_R=abs(1/2*(1+cos(az_R)));
        G_L=abs(1/2*(1+cos(az_L)));
        
    case  'supercardio_1'
        G_R=abs(1/4*(1+3*cos(az_R)));
        G_L=abs(1/4*(1+3*cos(az_L)));
        
        
    case 'supercardio_2'
        
        G_R=abs(0.37+0.63*cos(az_R));
        G_L=abs(0.37+0.63*cos(az_L));
        
end
end
