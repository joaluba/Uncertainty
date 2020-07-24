v_theta=[5:5:360]*(pi/180);
zeros_source=zeros(length(v_head),1);
zeros_head=zeros(length(v_head),1);
zeros_simulation_head=zeros(length(v_head),1);
zeros_simulation_source=zeros(length(v_head),1);

v_Entropy_scaled=(v_Entropy-min(v_Entropy))./(max(v_Entropy)-min(v_Entropy))


zeros_source(sParamTest.position(2)/stepsize)=0.8;
zeros_head(v_head(j)/stepsize)=0.8;

zeros_entropy(v_head(j)/stepsize)=v_Entropy_scaled(j);

zeros_simulation_head(end)=0.8;
zeros_simulation_source(v_angles_test(j)/stepsize)=0.8;

if strcmp(sParamTest.datatype,'images') 
f=10;
t=10;
elseif strcmp(sParamTest.datatype,'spectrograms')&& strcmp(sParamTest.directionInfo,'hrtf')
f=32;
t=10;
elseif strcmp(sParamTest.datatype,'spectrograms')&& strcmp(sParamTest.directionInfo,'only_gain')
f=32;
t=9;
elseif strcmp(sParamTest.datatype,'mnist') 
f=28;
t=28;
elseif strcmp(sParamTest.datatype,'spectral_slices') 
f=23;
t=5;
end




m_W_prep=[];

nr_pics=size(m_W,1)
if nr_pics>10
    nr_pics=10
end

for i=1:nr_pics;
m_W_i=reshape(m_W(i,:),f,t*2);
m_W_prep=[m_W_prep zeros(f,1) m_W_i];
end
m_W_highrow=m_W_prep(:,1:length(m_W_prep)/2);
m_W_lowrow=m_W_prep(:,length(m_W_prep)/2+1:end);
m_W_plot=[m_W_highrow; zeros(1,size(m_W_highrow,2)); m_W_lowrow];

% m_Th_prep=[];
% for i=1:size(m_thetasOptimal,1);
% m_Th_i=reshape(m_thetasOptimal(i,:),f,t*2);
% m_Th_prep=[m_Th_prep zeros(f,1) m_Th_i];
% end
% m_Th_highrow=m_Th_prep(:,1:length(m_Th_prep)/2);
% m_Th_lowrow=m_Th_prep(:,length(m_Th_prep)/2+1:end);
% m_Th_plot=[m_Th_highrow; zeros(1,size(m_Th_highrow,2)); m_Th_lowrow];


for n=1:sParamTest.N
    
    
%%PLOT 1    
%     figure(fid);
%     subplot(2,3,1)
%     h1=polar(v_theta,zeros_head');
%     hold on
%     h2=polar(v_theta,zeros_source');
%     hold on
%     h3=polar(v_theta,zeros_entropy');
%     view([90 -90])
%     set(h1,'color','c','linewidth',3);
%     set(h2,'color','r','linewidth',3);
%     set(h3,'color','m','linewidth',2);
%     title('AGENT')
%     %     legend('Head', 'Source','Entropy')
%     subplot(2,3,5)
%     imagesc(reshape(m_YOut_test(n,:),f,t*2))
%     subplot(2,3,3)
%     imagesc(m_W_plot)
%     subplot(2,3,4)
%     imagesc(m_B)
%     subplot(2,3,2)
%     h4=polar(v_theta,zeros_simulation_head');
%     view([90 -90])
%     hold on
%     h5=polar(v_theta,zeros_simulation_source');
%     set(h4,'color','c','linewidth',3);
%     set(h5,'color','r','linewidth',3);
%     title('SIMULATION')
%     pause(0.1)
%     subplot(2,3,6)
%     imagesc(m_Th_plot)
    
% PLOT 2
    figure(fid);
    subplot(2,2,1)
    h1=polar(v_theta,zeros_head');
    hold on
    h2=polar(v_theta,zeros_source');
    hold on
    h3=polar(v_theta,zeros_entropy');
    view([90 -90])
    set(h1,'color','c','linewidth',4);
    set(h2,'color','k','linewidth',4);
    set(h3,'color','m','linewidth',2);
    title('AGENT')
    subplot(2,2,2)
    h4=polar(v_theta,zeros_simulation_head');
    view([90 -90])
    hold on
    h5=polar(v_theta,zeros_simulation_source');
    hold on
%     run('plotcardio.m');
%     gr=polar(v_theta,vvGR);
%     hold on
%     gl=polar(v_theta,vvGL);
    set(h4,'color','c','linewidth',4);
    set(h5,'color','k','linewidth',4);
%     set(gr,'color','r','linewidth',2);
%         set(gl,'color','b','linewidth',2);
    title('SIMULATION')
    subplot(2,2,4)
%     h6=plot(5:5:360, v_Entropy)
%     xlabel('rotation angle lambda')
%     title('ENTROPY CURVE')
%     set(h6,'color','m','linewidth',2);
    imagesc(m_Th_plot)
    title('GENERATIVE PHONEME PATTERNS FOR A GIVEN DOA')
    subplot(2,2,3)
%     imagesc(reshape(m_YOut_test(n,:),f,t*2))
%     title('INPUT DATA')
    h6=plot(5:5:360, v_Entropy)
    xlabel('rotation angle lambda')
    title('ENTROPY CURVE')
    set(h6,'color','m','linewidth',2);


        frame = getframe(gcf); % 'gcf' can handle if you zoom in to take a movie.
        writeVideo(writerObj, frame);
        
        clf
end




