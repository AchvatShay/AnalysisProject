function plotAllNrnsAcrossTrials(outputPath, generalProperty, imagingData, BehaveData)
% extract behavioral data stats
% 1. grab counts per trial
% grabCount = getGrabCounts(eventTimeGrab{end}, findClosestDouble(t, toneTime), findClosestDouble(t, toneTime+2), frameRateRatio{1});
grabCount = getGrabCounts(BehaveData, generalProperty.time2startCountGrabs, generalProperty.time2endCountGrabs, generalProperty.ImagingSamplingRate);
% 2. discard trials with no suc or fail 
tryinginds = find(BehaveData.success | BehaveData.failure);
grabCount = grabCount(tryinginds);
% 3. obtain histograms of behave events
[Sbehave, Fbehave, allbehave] = getHistEvents(BehaveData, generalProperty.Events2plot, tryinginds);
X = imagingData.samples;
X=X(:,:,tryinginds);
[~, igrabs] = sort(grabCount);        
X=X(:,:,igrabs);

faillabels = BehaveData.failure(tryinginds);
faillabels = faillabels(igrabs);
toneTime = generalProperty.ToneTime;
t = linspace(0, generalProperty.Duration, size(X,2)) - toneTime;
xlimmin = generalProperty.visualization_startTime2plot-toneTime;
labelsFontSz = generalProperty.visualization_labelsFontSize;

mA1 = min(mean(mean(X(:,:,faillabels==0),3),1));
MA1 = max(mean(mean(X(:,:,faillabels==0),3),1));
mA2 = min(mean(mean(X(:,:,faillabels==1),3),1));
MA2 = max(mean(mean(X(:,:,faillabels==1),3),1));
mA = min(mA1, mA2);
MA = max(MA1, MA2);
DN = MA-mA;
mA=mA-DN*.1;
MA=MA+DN*.1;

% visualize
%% averaging all trials and neurons, suc and fail in blue and red
figure;
plot(t, mean(mean(X(:, :, faillabels==0),1),3), 'b');
hold all;
plot(t, mean(mean(X(:, :, faillabels==1),1),3), 'r');
xlabel('Time [secs]','FontSize', labelsFontSz);
placeToneTime(0, 2);
axis tight;
set(gca,'XLim', [xlimmin, t(end)]);

ylabel('Average Activity','FontSize', labelsFontSz);
leg = legend({'Success','Failure'});
set(leg, 'FontSize', labelsFontSz);
set(leg, 'Location','northeast');

mysave(gcf, fullfile(outputPath, 'averagedActivitySucFail'));

%% all trials
figure;
% 1
htop = subplot(2,1,1);
imagesc(t, 1:size(X,1),mean(X,3),[-.15 2]);
colormap jet;ylabel('Neurons','FontSize',10);
placeToneTime(0, 3);xlim([xlimmin,t(end)])

c=colorbar;
set(c,'Position',[0.9196    0.5810    0.0402    0.3452]);
% set(htop,'Position',[0.1300    0.5071    0.7750    0.4179]);
set(gca, 'YTick', unique([1 get(gca, 'YTick')]))
% 2
hmid=subplot(4,1,3);
plot(t,mean(mean(X,3),1), 'LineWidth',3, 'Color','k');
ylabel('Average','FontSize',10);
set(gca, 'YLim', [mA MA]);
placeToneTime(0, 2);
set(gca, 'Box','off');
set(gca, 'XTick',[]);
% set(hmid, 'Position', [0.1300    0.3291    0.7750    0.1066]);
xlim([xlimmin,t(end)])
xa=get(gca, 'XAxis');
set(xa,'Visible', 'off')
% 3
subplot(4,1,4);
lh=plotBehaveHist(t, allbehave, 0, generalProperty.Events2plot);
set(lh, 'Visible','off');
xlabel('Time [sec]','FontSize',10);
xlim([xlimmin,t(end)])
mysave(gcf, fullfile(outputPath, 'alltrialsActivity'));

figure;
% 1
htop = subplot(2,1,1);
imagesc(t, 1:size(X,1),mean(X(:,:,faillabels==0),3),[-.15 2]);
colormap jet;ylabel('Neurons','FontSize',10);
placeToneTime(0, 3);xlim([xlimmin,t(end)])

c=colorbar;
set(c,'Position',[0.9196    0.5810    0.0402    0.3452]);
% set(htop,'Position',[0.1300    0.5071    0.7750    0.4179]);
set(gca, 'YTick', unique([1 get(gca, 'YTick')]))
% 2
hmid=subplot(4,1,3);
plot(t,mean(mean(X(:,:,faillabels==0),3),1), 'LineWidth',3, 'Color','k');
ylabel('Average','FontSize',10);
set(gca, 'YLim', [mA MA]);
placeToneTime(0, 2);
set(gca, 'Box','off');
set(gca, 'XTick',[]);
% set(hmid, 'Position', [0.1300    0.3291    0.7750    0.1066]);
xlim([xlimmin,t(end)])
xa=get(gca, 'XAxis');
set(xa,'Visible', 'off')
% 3
subplot(4,1,4);
lh=plotBehaveHist(t, Sbehave, 0, generalProperty.Events2plot);
set(lh, 'Visible','off');
xlabel('Time [sec]','FontSize',10);
xlim([xlimmin,t(end)])
mysave(gcf, fullfile(outputPath, 'sucTrialsActivity'));



figure;
% 1
htop = subplot(2,1,1);
imagesc(t, 1:size(X,1),mean(X(:,:,faillabels==1),3),[-.15 2]);
colormap jet;ylabel('Neurons','FontSize',10);
placeToneTime(0, 3);xlim([xlimmin,t(end)])

c=colorbar;
set(c,'Position',[0.9196    0.5810    0.0402    0.3452]);
% set(htop,'Position',[0.1300    0.5071    0.7750    0.4179]);
set(gca, 'YTick', unique([1 get(gca, 'YTick')]))
% 2
hmid=subplot(4,1,3);
plot(t,mean(mean(X(:,:,faillabels==1),3),1), 'LineWidth',3, 'Color','k');
ylabel('Average','FontSize',10);
set(gca, 'YLim', [mA MA]);
placeToneTime(0, 2);
set(gca, 'Box','off');
set(gca, 'XTick',[]);
% set(hmid, 'Position', [0.1300    0.3291    0.7750    0.1066]);
xlim([xlimmin,t(end)]);
xa=get(gca, 'XAxis');
set(xa,'Visible', 'off')
% 3
subplot(4,1,4);
lh=plotBehaveHist(t, Fbehave, 0, generalProperty.Events2plot);
set(lh, 'Visible','off');
xlabel('Time [sec]','FontSize',10);
xlim([xlimmin,t(end)])
mysave(gcf, fullfile(outputPath, 'failTrialsActivity'));

