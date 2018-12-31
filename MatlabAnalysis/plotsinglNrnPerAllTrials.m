function plotsinglNrnPerAllTrials(titlestr, mA, MA, roiNames, currnrnind, x, xlimmin, t, m, M, X, histbehave, generalProperty)
figure;htop = subplot(2,1,1);
x_size = size(x);
imagesc(t, 1:x_size(1), x(:,:));
set(gca,'CLim',[m,M]);
colormap jet;ylabel('Trials #','FontSize',10);
placeToneTime(0, 3);xlim([xlimmin,t(end)])

title(['Neuron #' num2str(roiNames(currnrnind)) ' ' titlestr],'FontSize',generalProperty.visualization_labelsFontSize);
c=colorbar;
set(c,'Position',[0.9214    0.5048    0.0397    0.4238]);
set(htop,'Position',[0.1300    0.5071    0.7750    0.4179]);
set(gca, 'YTick', unique([1 get(gca, 'YTick')]))

hmid=subplot(4,1,3);
plot(t,mean(X(currnrnind,:,:),3), 'LineWidth',3, 'Color','k');
ylabel('Average','FontSize',10)
set(gca, 'YLim', [mA MA]);
ticks=get(gca,'YTick');
if length(ticks) > 3
    set(gca,'YTick',ticks(1:3:end));
end
placeToneTime(0, 2);
set(gca, 'Box','off');
set(gca, 'XTick',[]);
set(hmid, 'Position', [0.1300    0.3291    0.7750    0.1066]);
xlim([xlimmin,t(end)])
xa=get(gca, 'XAxis');
set(xa,'Visible', 'off')
subplot(4,1,4);
lh=plotBehaveHist(t, histbehave, 0, generalProperty.Events2plot);
set(lh, 'Visible','off');
xlabel('Time [sec]','FontSize',10);
xlim([xlimmin,t(end)])
% mysave(gcf, fullfile(outputPath, [outputstr num2str(roiNames(currnrnind))]));