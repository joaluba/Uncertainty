function [G_R G_L v_DataPointOut]=applyDirectivityGain(v_DataPointIn,az,s_type)
%Function to apply gain depending on the direction of arrival
%INPUT:  v_DataPointIn    -data point consisting of two identical
%                          concatinated data points simulating binaural input where the source is in
%                          the center
%        az               -direction from which the source is coming
%                          (0° -center, 270° right side, 180° behind center, 90°
%                          left side etc.)
%        s_type           - string containing the name of the directivity
%                           pattern we want to use (maybe it can be split
%                           to left and right?)
%
%OUTPUT: v_DataPointOut   -data point where an appropriate gain is applied
%                          to both "parts" of the concatenated data point.
%                          This simulates the binaural input.
%        G_L              -gain by which the left part of a pattern was
%                          multiplied
%        G_R              -gain by which the right part of a pattern was
%                          multiplied


D=length(v_DataPointIn);

[G_R, G_L]=pickGain(az,s_type);
L=v_DataPointIn(1:D/2);
R=v_DataPointIn(D/2+1:end);
v_DataPoint_L=L*G_L;
v_DataPoint_R=R*G_R;

v_DataPointOut=[v_DataPoint_L; v_DataPoint_R];


end
