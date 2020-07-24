function [m_out m_thetasOptimal] = GenerateBinauralData_FromData(m_DataIn,  A, angle)
% This is a function to generate noisy patterns based on the existing data set, which can then be used to train or to test
% the classifier.
%
%
% Steps performed in the function:
%       a)Read in gen.fields from a matrix with data
%       b)Scale gen.fields so that they contain values between 0 and 1
%       c)Apply gain depending on the angle
%       d)Shift gen.fields so that they dont contain zeros
%       e)Normalize gen.fields with norm. constant A (the bigger the
%       constant A is, the less noise we will see in the later generated
%       data points)
%       f)Generate data points using gen.fields as mean of the poisson




% ----INPUT:----
% m_DataIn              matrix containing data we want to use
% A                     normalization constant
% angle                 direction of arrival angle
% s_type                type of the polar pattern used for calculating gain
%                       for both parts of a pattern
% ----OUTPUT:----
% out                   Nx(w*h) matrix where in each row there is one created
%                       noisy pattern
%                       indicates which label is "active" (for example 0 1 0 0)
% G_L                   gain by which the left part of a pattern was
%                       multiplied
% G_R                   gain by which the right part of a pattern was
%                       multiplied






%% generate data points

[N,D]=size(m_DataIn);
m_out = zeros(N,2*D);

NrDataPoints=N;

for n=1:NrDataPoints;%over the number of created patterns
    
    
    %use the generative field
    v_DataPoint_gen =m_DataIn(n,:);
    
    % BINAURAL DATA ----> concatenate 2 patterns
    
    v_DataPoint = [v_DataPoint_gen v_DataPoint_gen]';
    
    if n<11
        m_thetasOptimal(n,:)=v_DataPoint;
    end
    %    SCALE so that gen.field contains values between zeros and ones
    
    minC = min(v_DataPoint);%min value in the image
    maxC = max(v_DataPoint);%max value in the image
    
    %for MNIST this is not really needed because they are already scaled like that
    if ((maxC-minC) ~= 0)
        v_DataPoint = double ( (v_DataPoint-minC) / (maxC-minC) );
    else
        v_DataPoint = zeros(size(v_DataPoint));
    end
    
    % COMPUTE LEFT AND RIGHT PATTERN
    
    
    % GAIN depending on the angle (DOA) and type of the polar pattern
    [G_R, G_L, v_DataPoint]=applyDirectivityGain(v_DataPoint,angle,'cardio');
    
    
    
    % shift so that it doesn't contain zeros
    v_DataPoint = v_DataPoint+0.1;
    
    
    %add poisson noise to the generative field
    v_DataPoint = poissrnd(v_DataPoint);%poisson noise
    
    % normalize with offset(does the same as function normalizeMatrixOffset.m)
    v_DataPoint=v_DataPoint./sum(v_DataPoint);
    v_DataPoint= (A-2*D)*v_DataPoint +1;
    
    %store a vector with data point as one row of the final matrix
    m_out(n,:) = v_DataPoint;
    
    
end



