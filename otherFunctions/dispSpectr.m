function out = dispSpectr(R, normalizedA, horizonalA) 

if (~exist('normalizedA'))
    normalizedA = 0;
end

if (~exist('horizonalA'))
    horizonalA = 0;
end

if (~isreal(R))
    R = real(R);
end

[k D] = size(R);

D_lr=D/2;

R_left=R(:,1:D_lr);
R_right=R(:,D_lr+1:end);
 
f = 23;
t= 5;

rangeTempMax = max(R(:));
rangeTempMin = min(R(:));

output_left = zeros(f+1,t+1);
output_right = zeros(f+1,t+1);
output= zeros(f+1,2*(t+1));
for kCounter=1:k;
    
  output_left(1:f,1:t) = reshape(R_left(kCounter,:),f,t);
  output_right(1:f,1:t) = reshape(R_right(kCounter,:),f,t);
  output=[output_left output_right];
%   colormap(gray(256))
  axis ij
  axis square
  axis on
  grid off
  if (horizonalA==1)
    subplot(1,k+1,kCounter+1);        % line
  end
  if (horizonalA==2)
      if (kCounter < k/2+1)           % two lines
            subplot(2,k/2+1,kCounter+1);
      else
            subplot(2,k/2+1,kCounter+2);
      end
  end
  if (horizonalA==0)
    if ( mod(k,sqrt(k))==0 )
        subplot(floor(sqrt(k)),floor(sqrt(k)),kCounter);     % square
    else
        subplot(floor(sqrt(k))+1,floor(sqrt(k))+1,kCounter);     % square
    end
  end
  
%   
%   H= pcolor(output);
imagesc(output)
  

  A = gca;  
%  get(H)
%  get(A)
%   set(H,'LineStyle','none');
%   set(A,'XTick',[]);
%   set(A,'YTick',[]);
%   set(A,'LineWidth',1);
  
  grid off
end;



axis ij
axis square
%axis off


 
 