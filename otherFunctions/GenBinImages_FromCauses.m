function [m_out, m_labelsOut, m_thetasOptimal] = GenBinImages_FromCauses(dirName, N, A, v_classes_train,v_classes_test, angle)

% This is a function to generate noisy patterns based on the basic set of
% patterns (templates, classes), which can then be used to train or to test
% the classifier.
%
%
% Steps performed in the function:
%       a)Read in gen.fields from .tiff file
%       b)Scale gen.fields so that they contain values between 0 and 1
%       c)Apply gain depending on the angle
%       d)Shift gen.fields so that they dont contain zeros
%       e)Normalize gen.fields with norm. constant A (the bigger the
%       constant A is, the less noise we will see in the later generated
%       data points)
%       f)Generate data points using gen.fields as mean of the poisson




% ----INPUT:----
% dirName               name of the directory where the basic patterns are stored
%                       (they are *.tiff files)
% N                     number of patterns (data points) to be generated
% A                     normalization constant
% angle                 direction of arrival angle
% s_type                type of the polar pattern used for calculating gain
%                       for both parts of a pattern
% v_classes             classes from which data will be
%                       generated. Note that they will be used as indices ,
%                       so class number cannot be zero!
% ----OUTPUT:----
% out                   Nx(w*h) matrix where in each row there is one created
%                       noisy pattern
% labelsOut             NxNrClasses matrix where each row is a vector which
%                       indicates which label is "active" (for example 0 1 0 0)
% thetasOptimal         NrClassesx(w*h) matrix, where each row is one
%                       of the normalized templates (basic patterns)
% G_L                   gain by which the left part of a pattern was
%                       multiplied
% G_R                   gain by which the right part of a pattern was
%                       multiplied



shift=0.1;
%% read in data



if ispc
    dirString = strcat (dirName,'*.tiff');
    theFilesTemp = ls(dirString);
    NrClasses = size(theFilesTemp,1);
    for ii = 1:NrClasses
        theFileNames{ii} = [dirName theFilesTemp(ii,:)];
    end
else
    
    
    dirString = strcat (dirName,'*.tiff');
    %     dirString = strcat (dirName,'*.mat');
    
    %     dirString = strcat (dirName);
    theFilesTemp = ls('-1',dirString);
    theFileNames = strsplit (theFilesTemp);
    theFileNames = strrep(theFileNames, '/n', '');
    NrClasses = size (theFileNames,2);
    NrClasses = NrClasses - 1; %number of templates
end;


%% prepare generative fields

for class_nr=1:length(v_classes_train);
    
    
    % read a grayscale image from the file specified by the string inName
    inName = theFileNames{v_classes_train(class_nr)};
    %     outMessage = strcat('Opening file: ',inName);
    %     disp (outMessage);
    
    
    % Shapes:
    m_Class = imread(inName,'tiff');
    
    %         m_Class = load(inName,'-mat');
    %         m_Class=m_Class.spectrogram;
    inName = theFileNames{class_nr};
    %     outMessage = strcat('Opening file: ',inName);
    %     disp (outMessage);
 
    m_Class = imread(inName,'tiff');
    [w h] = size(m_Class);% size of the image
    D=w*h;
    
    % put a class template into a vector
    v_GenField = reshape(m_Class,1,D)';
    v_GenField = im2double(v_GenField);
    
    % BINAURAL DATA ----> concatenate 2 patterns
    v_GenField_B = [v_GenField ; v_GenField];
    
    % SCALE so that gen.field contains values between zeros and ones
    minC = min(v_GenField_B);%min value in the image
    maxC = max(v_GenField_B);%max value in the image
    
    if ((maxC-minC) ~= 0)
        v_GenField_B = double ( (v_GenField_B-minC) / (maxC-minC) );
    else
        v_GenField_B = zeros(w,h);
    end
    
    
    % DIRECTION depending on the angle (DOA) and type of the polar pattern
    
    [G_R, G_L, v_GenField_B]=applyDirectivityGain(v_GenField_B,angle,'cardio');
    
    % SHIFT so that it doesn't contain zeros
    v_GenField_B = v_GenField_B+shift;
    
%     % NORMALIZE with offset(does the same as function normalizeMatrixOffset.m)
%         v_GenField_B=v_GenField_B./sum(v_GenField_B);
%         v_GenField_B= (A-D)*v_GenField_B +1;
    % ---> This form of normalization continues
    % to scale the activity of an unnormalized input unit by the
    % total activity sum(y_d) but it introduces an offset corresponding
    % to having some spontaneous background activity in the input layer
    
    
    % matrix where each row is a templete for one of the classes
    m_thetasOptimal(class_nr,:) = v_GenField_B;
    
    
    
end

% figure;
% dispSpectr(m_thetasOptimal)

%% generate data points

m_labelsOut = zeros(N,length(v_classes_test));
m_out = zeros(N,2*D);
ratio=0
for n=1:N;%over the number of created patterns
    
    %randomly choose one class
    rnd_class= datasample(v_classes_test,1);
    
    %use the generative field
    v_DataPoint_gen =m_thetasOptimal(rnd_class,:);
    
    %ratio between symbol and background
    v_idx_shape=find(v_DataPoint_gen>shift);
    v_idx_back=find(v_DataPoint_gen<=shift);
    
    
    
    %add poisson noise to the generative field
    v_DataPoint_noise = poissrnd(v_DataPoint_gen);%poisson noise
    
    %     %shift so that it doesn't contain zeros
    %     v_DataPoint_noise = v_DataPoint_noise+0.01;
    
    %normalization
    v_DataPoint_noise_norm=v_DataPoint_noise./sum(v_DataPoint_noise);
    v_DataPoint_noise_norm= (A-2*D)*v_DataPoint_noise_norm +1;
    
    
    %store a vector with data point as one row of the final matrix
    m_out(n,:) = v_DataPoint_noise_norm;
    
    shape=sum(v_DataPoint_noise_norm(v_idx_shape));
    backgr=sum(v_DataPoint_noise_norm(v_idx_back));
    ratio=ratio+(shape/backgr);
    
    % create matrix with labels --> each row e.g. 0 1 0 0;0 0 0 1 etc.
    m_labelsOut(n,rnd_class) = 1;
    
    
end

ratio=ratio/N;





