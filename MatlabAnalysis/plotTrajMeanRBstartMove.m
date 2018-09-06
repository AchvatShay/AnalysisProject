function plotTrajMeanRBstartMove(labelsLUT, clrs, trajData, labels, ...
    mvStartInd, toneTime, afterToneInd, viewparams, labelsFontSz)

classes = unique(labels);
for ci = 1:length(classes)
    meansTrajs(:, :, ci) = mean(trajData(:,:,labels==classes(ci)),3);
    plot3(meansTrajs(1,:, ci), meansTrajs(2,:, ci), meansTrajs(3,:, ci),'Color', clrs(ci, :), 'LineWidth',5);
    hold all;
end
placeTimePointsOnTraj(clrs, meansTrajs, mvStartInd, toneTime, afterToneInd);
for ci = 1:length(classes)
    plot3(meansTrajs(1,:, ci), meansTrajs(2,:, ci), meansTrajs(3,:, ci),'Color', clrs(ci, :), 'LineWidth',5);
    hold all;
end
if ~all(viewparams==0)
    view(viewparams);
end
a=get(gcf,'Children');
setAxisFontSz(a(end), labelsFontSz);
xlabel('\psi_1', 'FontSize',labelsFontSz);ylabel('\psi_2', 'FontSize',labelsFontSz);
zlabel('\psi_3', 'FontSize',labelsFontSz);

axis tight
grid on;

l=legend(cat(2, labelsLUT ,{'Start','Tone'}),'Location','northeastoutside');
set(l, 'FontSize',labelsFontSz);
end


% this is the older version, will erase it after being sure the new one
% works
% plot3(noMean(1,:), noMean(2,:), noMean(3,:),'b', 'LineWidth',5);
% hold all;
% plot3(yesMean(1,:), yesMean(2,:), yesMean(3,:),'r', 'LineWidth',5);
% hold all;


% if ~isempty(omMean) && all(~isnan(omMean(:)))
%     plot3(omMean(1,:), omMean(2,:), omMean(3,:),'k', 'LineWidth',5);
% end
% placeTimePointsOnTrajNotDynamicVersion(meansTrajs, mvStartInd, toneTime, afterToneInd);

% yesMean = mean(trajData(:,:,labels==1),3);
% noMean = mean(trajData(:,:,labels==0),3);
% omMean = mean(trajData(:,:,labels==2),3);
%
% plottraj(yesMean, noMean, omMean, toneTime, mvStartInd, afterToneInd, labelsFontSz);
% if ~all(viewparams==0)
%     view(viewparams);
% end
% a=get(gcf,'Children');
% setAxisFontSz(a(end), labelsFontSz);
%
%
% end
% function plottraj(yesMean, noMean, omMean, toneTime, mvStartInd, afterToneInd, labelsFontSz)
%
% plot3(noMean(1,:), noMean(2,:), noMean(3,:),'b', 'LineWidth',5);
% hold all;
% plot3(yesMean(1,:), yesMean(2,:), yesMean(3,:),'r', 'LineWidth',5);
% hold all;
%
%
% if ~isempty(omMean) && all(~isnan(omMean(:)))
%     plot3(omMean(1,:), omMean(2,:), omMean(3,:),'k', 'LineWidth',5);
% end
% placeTimePointsOnTraj(yesMean, noMean, omMean, mvStartInd, toneTime, afterToneInd);
%
%
%
%
%
%
% xlabel('\psi_1', 'FontSize',labelsFontSz);ylabel('\psi_2', 'FontSize',labelsFontSz);
% zlabel('\psi_3', 'FontSize',labelsFontSz);
%
% axis tight
% grid on;
%
% if any(isnan(omMean))
%     l=legend('Success','Failure','Start','Tone', 'Location','northeastoutside');
% else
%     l=legend('Success','Failure','Omissions' ,'Start','Tone','Location','northeastoutside');
% end
% set(l, 'FontSize',labelsFontSz);
% end