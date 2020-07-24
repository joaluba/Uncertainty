function [stCurves, stDOA_estimated, stDiff]= estimate_DOA(stTrainingData,sTestingParam,Nrtrials)


head_pos=sTestingParam.position(1);
source_pos=sTestingParam.position(2);

for t =1 : Nrtrials
    
%rotate and test for all the angles, starting from the current head position
[v_Entropy,v_BVSB, ~, ~]=test_for_each_angle(stTrainingData.m_B,stTrainingData.m_W,sTestingParam);



%% Estimate the DOA from the Entropy curve

% Smooth entropy curve 
% v_Entropy_smooth1=smooth(v_Entropy,10);
v_Entropy_smooth1=moving_av_circ(v_Entropy,10);
v_Entropy_smooth2=smooth(v_Entropy,10,'sgolay');
v_BVSB_smooth=moving_av_circ(v_BVSB,10);

v_Symmetry=symmetry_meas(v_Entropy_smooth1);

%Store curves

stCurves.entropy{t}=v_Entropy;
stCurves.entropy_smooth1{t}=v_Entropy_smooth1;
stCurves.entropy_smooth2{t}=v_Entropy_smooth2;
stCurves.symmetry{t}=v_Symmetry;
stCurves.bvsb{t}=v_BVSB;
stCurves.bvsb_smooth{t}=v_BVSB_smooth;
% stCurves.error{t}=v_Error;
% stCurves.ratio{t}=v_Ratio;
%Estimate the DOA & compute the difference
[min_B min_B_idx]=min(v_BVSB);   
[min_E min_E_idx]=min(v_Entropy);        
[min_Es1 min_Es1_idx]=min(v_Entropy_smooth1);
[min_Es2 min_Es2_idx]=min(v_Entropy_smooth2);
[min_Bs min_Bs_idx]=min(v_BVSB_smooth); 
[min_S min_S_idx]=min(v_Symmetry);

val=head_pos+5*(min_E_idx-1);if val>360 val=val-360; end;
stDOA_estimated.entropy(t)= val;
stDiff.entropy(t)=source_pos-val;

val=head_pos+5*(min_Es1_idx-1);if val>360 val=val-360; end;
stDOA_estimated.entropy_smooth1(t)= val;
stDiff.entropy_smooth1(t)=source_pos-val;

val=head_pos+5*(min_Es2_idx-1);if val>360 val=val-360; end;
stDOA_estimated.entropy_smooth2(t)= val;
stDiff.entropy_smooth2(t)=source_pos-val;

val=head_pos+5*(min_S_idx-1);if val>360 val=val-360; end;
stDOA_estimated.symmetry(t)= val;
stDiff.symmetry(t)=source_pos-val;

val=head_pos+5*(min_B_idx-1);if val>360 val=val-360; end;
stDOA_estimated.bvsb(t)= val;
stDiff.bvsb(t)=source_pos-val;

val=head_pos+5*(min_Bs_idx-1);if val>360 val=val-360; end;
stDOA_estimated.bvsb_smooth(t)= val;
stDiff.bvsb_smooth(t)=source_pos-val;


% % %Plot different measures used to estimate DOA
% figure(1);
% plot(v_Entropy_smooth,'b')
% hold all
% xlabel('unknown azimuth')
% ylabel('smoothed Entropy')
% figure(2)
% plot(v_Entropy,'g')
% hold all
% xlabel('unknown azimuth')
% ylabel('Symmetry')
% figure(3)
% plot(v_Symmetry,'g')
% hold all
% xlabel('unknown azimuth')
% ylabel('Symmetry')

end

end




