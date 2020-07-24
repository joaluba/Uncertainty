function [m_W,varargout]=trainNeuralNetwork(m_W,m_YTrain,eps,display)
%It is a function to perform training of the Neural Network.

%Usage : [m_W, m_DeltaW_av, m_W_av,v_LogLikelihood]=trainNeuralNetwork(m_W,m_YTrain,eps)

%INPUT:  m_W              -initial weights 
%        m_YTrain         -training set
%        eps              -learning rate
%        disp             -0 or 1 - indicates if the training has to be
%                          displayed or not
%OUTPUT: m_W              -learned weights
%        m_DeltaW_av      -matrix containing evolution of the weight-updates for each class
%        m_W_av           -matrix containing evolution of the weights for each class
%        v_LogLikelihood  -vector contatinig evolution of the log likelyhood
%
% Author: Joanna Luberadzka

        
%Dimensions:
[H, D] = size(m_W);

 if display
fid = figure;
writerObj = VideoWriter('training_gain.avi'); % Name it.
writerObj.FrameRate = 60; % How many frames per second.
open(writerObj); 
 end

%% ----------------------------- Training ---------------------------------
h1 = waitbar(0,'TRAINING');

v_sTrain = zeros(H,1);
v_MAP_train=zeros(size(m_YTrain,1),1);
v_Entropy_train=zeros(size(m_YTrain,1),1);
m_DeltaW_av= zeros(H,size(m_YTrain,1));
m_W_av= zeros(H,size(m_YTrain,1));
v_LogLikelihood =zeros(size(m_YTrain,1),1);
S_B.matrix=zeros(H,H);
S_B.howmany=zeros(H,size(m_YTrain,1));

for n=1:size(m_YTrain,1)
    
    waitbar(n/size(m_YTrain,1));
    
    v_Y = (m_YTrain(n,:))'; % we can also randomly pick
    
%     %------------- ACTIVATION RULE----------
    v_sTrain = computeActivitiesSoftMax(v_Y,m_W,'log_lin');
    
%     if sum(isnan(v_sTrain))>0
%        v_sTrain = computeActivitiesSoftMax(v_Y,m_W,'log_lin');
%     end
    
    %MAP (which class)
    [val,ind]=max(v_sTrain);
    vMAP_train(n)=ind;%assigned class
    
    %-------------LEARNING WEIGTHS----------
    %In each iteration we calculate the new weight- matrix. Apart of that
    %we also want to track the evolution of the weights and how they
    %converge to the optimum. To do that, in each iteration we also compute
    %the averaged across the number of dimensions change (update) of the
    %weights as well as the averaged across D weights. We do that for each
    %class. 
    
    [m_W ,v_W_av, v_DeltaW_av]= updateWeightsCompNet(v_Y,m_W,v_sTrain,eps); 
                                                                                                                        
    % average delta W for each class to track the convergence of the
    % weights in each class:-----------------

    m_DeltaW_av(:,n)= v_DeltaW_av;
    m_W_av(:,n)=v_W_av;
    
    %------------LOG LIKELYHOOD---------------
    %One way to track the convergence of the weights is to plot how the log
    %-likelihood grows with each itaration (the parameters are reaching the
    %optimal solution). This is however a bit tricky, since there is a
    %factorial in the log-likelyhood and it does not work for the numbers
    %which are not integers (and because we normalize the data, they are
    %not integers anymore) So one way would be to use Gamma function. 
    

    if nargout == 4
    v_LogLikelihood(n) = PoissLogLikeli(m_YTrain, m_W);
    end
   
    
   % displaying the weight vectors (as images)

   if display
%     figure(10);
%     integerTest=~mod(sqrt(D),1);
%    if integerTest==1
%     dispThetasT(m_W);
%    else
%     dispThetasTwo(m_W);
%    end
%     pause(0.01);


%% Set up the movie.


%     figure(10);
    figure(fid); % Makes sure you use your desired frame.
    integerTest=~mod(sqrt(D),1);
   if integerTest==1
    dispSpectr(m_W);
   else
    dispSpectr(m_W);
   end
    pause(0.001);
    
        frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
        writeVideo(writerObj, frame);
   end
   

    
end
close(h1) %closing waitbar

   if display
close(writerObj); % Saves the movie.
   end
   
varargout{1}=m_DeltaW_av;
varargout{2}=m_W_av;
varargout{3}=v_LogLikelihood;

end

