function p = plotTrajMC(trajData, labels, dim, labelsFontSz)
if ~exist('labelsFontSz','var')
    labelsFontSz = 14;
end
map=colormap('jet');
labels1=labels+1;
labelsR=round(size(map,1)*(labels1)/(max(labels1)));
for k = 1:length(labels)
    if dim==2
      p(k) = plot(squeeze(trajData(1,:,k)), squeeze(trajData(2,:,k)),  'Color',map(labelsR(k),:));
    else
   p(k) = plot3(squeeze(trajData(1,:,k)), squeeze(trajData(2,:,k)), squeeze(trajData(3,:,k)),  'Color',map(labelsR(k),:));
    end
   hold on;
end
% yesMean(1,:) = mean(squeeze(trajData(1,:,labels==1)),2);
% yesMean(2,:) = mean(squeeze(trajData(2,:,labels==1)),2);
% yesMean(3,:) =  mean(squeeze(trajData(3,:,labels==1)),2);
% 
% noMean(1,:) = mean(squeeze(trajData(1,:,labels==0)),2);
% noMean(2,:) = mean(squeeze(trajData(2,:,labels==0)),2);
% noMean(3,:) =  mean(squeeze(trajData(3,:,labels==0)),2);
% %  plot3(yesMean(1,:), yesMean(2,:), yesMean(3,:), 'Color', 'm','LineWidth',4);
% t=linspace(0,12,size(yesMean,2));
%   plot(yesMean(1,find(t<=4)), yesMean(2,find(t<=4)),  'Color', 'm','LineWidth',4);   hold on;
%   plot(yesMean(1,find(t>=4 & t<5)), yesMean(2,find(t>=4 & t<5)),  'Color', 'k','LineWidth',4);   hold on;
%   plot(yesMean(1,find(t>=5&t<7)), yesMean(2,find(t>=5&t<7)),  'Color', 'm','LineWidth',4);   hold on;
%   plot(yesMean(1,find(t>=7&t<9)), yesMean(2,find(t>=7&t<9)),  'Color', 'k','LineWidth',4);   hold on;
%   plot(yesMean(1,find(t>=9&t<11)), yesMean(2,find(t>=9&t<11)),  'Color', 'm','LineWidth',4);   hold on;
% 
% 
%  plot(noMean(1,find(t<=4)), noMean(2,find(t<=4)),  'Color', 'c','LineWidth',4);   hold on;
%   plot(noMean(1,find(t>=4 & t<5)), noMean(2,find(t>=4 & t<5)),  'Color', 'g','LineWidth',4);   hold on;
%   plot(noMean(1,find(t>=5&t<7)), noMean(2,find(t>=5&t<7)),  'Color', 'c','LineWidth',4);   hold on;
%   plot(noMean(1,find(t>=7&t<9)), noMean(2,find(t>=7&t<9)),  'Color', 'g','LineWidth',4);   hold on;
%   plot(noMean(1,find(t>=9&t<11)), noMean(2,find(t>=9&t<11)),  'Color', 'c','LineWidth',4);   hold on;
% 
% %     plot(noMean(1,:), noMean(2,:), 'Color', 'c','LineWidth',4);
% %         plot3(noMean(1,:), noMean(2,:), noMean(3,:), 'Color', 'c','LineWidth',4);
% 
   hold on;axis tight;
   xlabel('\psi_1', 'FontSize', labelsFontSz);ylabel('\psi_2', 'FontSize', labelsFontSz);zlabel('\psi_3', 'FontSize', labelsFontSz);