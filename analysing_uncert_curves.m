clc
clear
close all

addpath(genpath('../Uncertainty_Data/'));

sname='500Conv_train';
SNR=[Inf 5 0 -5 -10];
Nrtrials=20
Nrtrialsfull=500;
ax=[-90:5:90];
scase={'case2'}%, 'case2', 'case3'}
for c=1:length(scase)
    for s=1:length(SNR)
        
        matfilename= [sname,'_', scase{c}, '_SNR',num2str(SNR(s)),'N1000_test.mat'];
        load(matfilename);
        DOAentropy=zeros(Nrtrials,2);
        
        %% PLOT some of the obtained entropy curves
        for n=1:Nrtrials
            figure(c*100+s*10+1)
            subplot(3,2,1)
            plot(ax,sTEST_RESULTS.entropy{n});
            [a b]=min(sTEST_RESULTS.entropy{n});
            DOAentropy(n,:)=[a b]
            hold on
            plot(ax(b),a,'*k')
            title([sname,' ', scase{c}, ' SNR',num2str(SNR(s)),' N1000 Entropy'])
            hold all
            
            subplot(3,2,3)
            plot(ax,smooth(sTEST_RESULTS.entropy{n},10,'sgolay'))
            [a b]=min(smooth(sTEST_RESULTS.entropy{n},10,'sgolay'));
            DOAentropy_sgolay(n,:)=[a b];
            hold on
            plot(ax(b),a,'*k')
            title([sname,' ', scase{c}, ' SNR',num2str(SNR(s)),' N1000 Entropy smoothed (s.g.)'])
            hold all
            
            %         figure(s*10+3)
            %         subplot(2,1,1)
            subplot(3,2,5)
            plot(ax,smooth(sTEST_RESULTS.entropy{n},10))
            [a b]=min(smooth(sTEST_RESULTS.entropy{n},10));
            DOAentropy_movav(n,:)=[a b];
            hold on
            plot(ax(b),a,'*k')
            title([sname,' ', scase{c}, ' SNR',num2str(SNR(s)),' N1000 Entropy smoothed (m.av.)'])
            hold all
            
            %         subplot(3,2,5)
            %         plot(sTEST_RESULTS.BVSB{n});
            %         [a b]=min(sTEST_RESULTS.BVSB{n});
            %         hold on
            %         plot(b,a,'*k')
            %         title(['pilot case1 SNR',num2str(SNR(s)),'N1000 BVSB'])
            %         hold all
            %
            %         subplot(3,2,6)
            %         plot(smooth(sTEST_RESULTS.BVSB{n},10,'sgolay'))
            %         [a b]=min(smooth(sTEST_RESULTS.BVSB{n},10,'sgolay'));
            %         hold on
            %         plot(b,a,'*k')
            %         title(['pilot case1 SNR',num2str(SNR(s)),'N1000 Smoothed BVSB'])
            %         hold all
            %
        end
        
        %% ESTIMATE DOA BASED ON MINIMUM
        for n=1:Nrtrialsfull
            [a b]=min(sTEST_RESULTS.entropy{n});
            DOAentropy(n,:)=[a b]

            
            [a b]=min(smooth(sTEST_RESULTS.entropy{n},10,'sgolay'));
            DOAentropy_sgolay(n,:)=[a b];
            
            [a b]=min(smooth(sTEST_RESULTS.entropy{n},10));
            DOAentropy_movav(n,:)=[a b];
        end
        
        
        %% ESTIMATION MEASURES
        
            Measures_entropy(1)=median(ax(DOAentropy(:,2)));
            Measures_entropy(2)=sqrt((1/length(DOAentropy(:,2)))*(sum((-30-ax(DOAentropy(:,2))).^2)));
            Measures_entropy(3)=length(   find(ax(DOAentropy(:,2))+30<=5) )./length(DOAentropy(:,2));
            
            Measures_entropy_sgolay(1)=median(ax(DOAentropy_sgolay(:,2)));
            Measures_entropy_sgolay(2)=sqrt((1/length(DOAentropy_sgolay(:,2)))*(sum((-30-ax(DOAentropy_sgolay(:,2))).^2))) ;
            Measures_entropy_sgolay(3)=length(   find(ax(DOAentropy_sgolay(:,2))+30<=5)   )./length(DOAentropy_sgolay(:,2));
            
            Measures_entropy_movav(1)=median(ax(DOAentropy_movav(:,2)));
            Measures_entropy_movav(2)=sqrt((1/length(DOAentropy_movav(:,2)))*(sum((-30-ax(DOAentropy_movav(:,2))).^2))) ;
            Measures_entropy_movav(3)=length(   find( ax(DOAentropy_movav(:,2))+30<=5)   )./length(DOAentropy_movav(:,2));

        
        
        
        
        
        
        %% PLOT ESTIMATION RESULTS
        figure(c*100+s*10+1)
        Nrtrialsfull=500;
        subplot(3,2,2)
        hist(ax(DOAentropy(:,2)),-90:5:90)
        axis([-90 90 0 Nrtrialsfull])
        axi=gca;
        set(axi,'XTick',[-90 -30 0 30 90])
        title(['MEDIAN=',num2str(Measures_entropy(1)),'°; RMSE=',num2str(Measures_entropy(2)),'; GA=',num2str(Measures_entropy(3)*100),'%'])
        
        subplot(3,2,4)
        hist(ax(DOAentropy_sgolay(:,2)),-90:5:90)
        axis([-90 90 0 Nrtrialsfull])
        axi=gca;
        set(axi,'XTick',[-90 -30 0 30 90])
        title(['MEDIAN=',num2str(Measures_entropy_movav(1)),'°; RMSE=',num2str(Measures_entropy_movav(2)),'; GA=',num2str(Measures_entropy_movav(3)*100),'%'])
        
        subplot(3,2,6)
        hist(ax(DOAentropy_movav(:,2)),-90:5:90)
        axis([-90 90 0 Nrtrialsfull])
        axi=gca;
        set(axi,'XTick',[-90 -30 0 30 90])
        title(['MEDIAN=',num2str(Measures_entropy_sgolay(1)),'°; RMSE=',num2str(Measures_entropy_sgolay(2)),'; GA=',num2str(Measures_entropy_sgolay(3)*100),'%'])

        
    end
end

