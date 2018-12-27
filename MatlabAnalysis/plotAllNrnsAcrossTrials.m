function plotAllNrnsAcrossTrials(outputPath, generalProperty, imagingData, BehaveData)
% extract behavioral data stats
[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(...
BehaveData, generalProperty.labels2cluster, generalProperty.includeOmissions);

% 1. grab counts per trial
% grabCount = getGrabCounts(eventTimeGrab{end}, findClosestDouble(t, toneTime), findClosestDouble(t, toneTime+2), frameRateRatio{1});
grabCount = getGrabCounts(BehaveData, generalProperty.time2startCountGrabs, generalProperty.time2endCountGrabs, generalProperty.ImagingSamplingRate);
% 2. discard trials with no suc or fail 

if (~isnan(grabCount))
    grabCount = grabCount(examinedInds);
end

% 3. obtain histograms of behave events
[behaveHist, allbehave] = getHistEventsByDynamicLabels(generalProperty, BehaveData, generalProperty.Events2plot, examinedInds);

X = imagingData.samples;
X=X(:,:,examinedInds);


if (~isnan(grabCount))
    [~, igrabs] = sort(grabCount);        
    X=X(:,:,igrabs);
end
classes = unique(labels);


if (~isnan(grabCount))
    labels = labels(igrabs);
end

toneTime = generalProperty.ToneTime;
t = linspace(0, generalProperty.Duration, size(X,2)) - toneTime;
xlimmin = generalProperty.visualization_startTime2plot-toneTime;
labelsFontSz = generalProperty.visualization_labelsFontSize;

mA = inf;
    for ci = 1:length(classes)
        mA = min(mA, min(mean(mean(X(:,:,labels==classes(ci)),3),1)));
    end
    MA = -inf;
    for ci = 1:length(classes)
        MA = max(MA, max(mean(mean(X(:,:,labels==classes(ci)),3),1)));
    end
    DN = MA-mA;
    mA=mA-DN*.1;
    MA=MA+DN*.1;
    
% visualize
%% averaging all trials and neurons
[clrs, clrsprevCurr] = cellClr2matClrs(generalProperty.labels2clusterClrs, generalProperty.prevcurrlabels2clusterClrs);

figure;
for ci = 1:length(classes)
plot(t, mean(mean(X(:, :, labels==classes(ci)),1),3), 'Color',clrs(ci,:));
hold all;
end
xlabel('Time [secs]','FontSize', labelsFontSz);
placeToneTime(0, 2);
axis tight;
set(gca,'XLim', [xlimmin, t(end)]);

ylabel('Average Activity','FontSize', labelsFontSz);
leg = legend(labelsLUT);
set(leg, 'FontSize', labelsFontSz);
set(leg, 'Location','northeast');

mysave(gcf, fullfile(outputPath, ['averagedActivity' eventsStr]));

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

for ci = 1:length(classes)
figure;
% 1
htop = subplot(2,1,1);
imagesc(t, 1:size(X,1),mean(X(:,:,labels==classes(ci)),3),[-.15 2]);
colormap jet;ylabel('Neurons','FontSize',10);
placeToneTime(0, 3);xlim([xlimmin,t(end)])

c=colorbar;
set(c,'Position',[0.9196    0.5810    0.0402    0.3452]);
% set(htop,'Position',[0.1300    0.5071    0.7750    0.4179]);
set(gca, 'YTick', unique([1 get(gca, 'YTick')]))
% 2
hmid=subplot(4,1,3);
plot(t,mean(mean(X(:,:,labels==classes(ci)),3),1), 'LineWidth',3, 'Color','k');
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
lh=plotBehaveHist(t, behaveHist{ci}, 0, generalProperty.Events2plot);
set(lh, 'Visible','off');
xlabel('Time [sec]','FontSize',10);
xlim([xlimmin,t(end)])
mysave(gcf, fullfile(outputPath, [labelsLUT{ci} 'trialsActivity']));
end

if strcmp(generalProperty.PelletPertubation, 'Taste')
    
    [labelsTaste, examinedIndsTaste, eventsStrTaste, labelsLUTTaste] = getLabels4clusteringFromEventslist(BehaveData, ...
            generalProperty.tastesLabels, generalProperty.includeOmissions);
    X_Taste = imagingData.samples;
    X_Taste=X_Taste(:,:,examinedIndsTaste);


    if (~isnan(grabCount))
        [~, igrabs] = sort(grabCount);        
        X_Taste=X_Taste(:,:,igrabs);
    end
    classes_Taste = unique(labelsTaste);


    if (~isnan(grabCount))
        labelsTaste = labelsTaste(igrabs);
    end
    
    mA = inf;
    for ci = 1:length(classes_Taste)
        mA = min(mA, min(mean(mean(X_Taste(:,:,labelsTaste==classes_Taste(ci)),3),1)));
    end
    MA = -inf;
    for ci = 1:length(classes_Taste)
        MA = max(MA, max(mean(mean(X_Taste(:,:,labelsTaste==classes_Taste(ci)),3),1)));
    end
    DN = MA-mA;
    mA=mA-DN*.1;
    MA=MA+DN*.1;
 
    figure;
    for ci = 1:length(classes_Taste)
        plot(t, mean(mean(X_Taste(:, :, labelsTaste==classes_Taste(ci)),1),3), 'Color',generalProperty.tastesColors{:,ci});
        hold all;
    end
    
    xlabel('Time [secs]','FontSize', labelsFontSz);
    placeToneTime(0, 2);
    axis tight;
    set(gca,'XLim', [xlimmin, t(end)]);

    ylabel('Average Activity','FontSize', labelsFontSz);
    leg = legend(labelsLUTTaste);
    set(leg, 'FontSize', labelsFontSz);
    set(leg, 'Location','northeast');

    mysave(gcf, fullfile(outputPath, ['averagedActivity' eventsStrTaste]));

    
    for ci = 1:length(classes_Taste)
        figure;
        % 1
        htop = subplot(2,1,1);
        imagesc(t, 1:size(X_Taste,1),mean(X_Taste(:,:,labelsTaste==classes_Taste(ci)),3),[-.15 2]);
        colormap jet;ylabel('Neurons','FontSize',10);
        placeToneTime(0, 3);xlim([xlimmin,t(end)])

        c=colorbar;
        set(c,'Position',[0.9196    0.5810    0.0402    0.3452]);
        % set(htop,'Position',[0.1300    0.5071    0.7750    0.4179]);
        set(gca, 'YTick', unique([1 get(gca, 'YTick')]))
        % 2
        hmid=subplot(2,1,2);
        plot(t,mean(mean(X_Taste(:,:,labelsTaste==classes_Taste(ci)),3),1), 'LineWidth',3, 'Color','k');
        ylabel('Average','FontSize',10);
        set(gca, 'YLim', [mA MA]);
        placeToneTime(0, 2);
        set(gca, 'Box','off');
        set(gca, 'XTick',[]);
        % set(hmid, 'Position', [0.1300    0.3291    0.7750    0.1066]);
        xlim([xlimmin,t(end)])
        xa=get(gca, 'XAxis');
        set(xa,'Visible', 'off')

        mysave(gcf, fullfile(outputPath, [labelsLUTTaste{ci} 'trialsActivity' ]));
    end 
end
% if isfield(allLabels, 'sucrose') && any(allLabels.sucrose)
%     grabCountSucrose = grabCount(allLabels.sucrose(expinds{l})==1);
%     [~, igrabsS] = sort(grabCountSucrose, 'ascend');
%     fail = allLabels.failure(expindsNoOmAll{l});
%     plotIndicativeNrAndBehave(toneTime, fullfile(currfolder{l}, 'indicativeNrnsSucrose')...
%         , dataAlltimes{l}(:, :, allLabels.sucrose(expinds{l})==1), t, ...
%         fail(allLabels.sucrose(expinds{l})==1), Sbehave{l}, Fbehave{l}, ...
%         {NeuronsLabels{l}},'Sucrose', newNreINds, igrabsS, xlimmin);
%     %% INdicative Neurons By Taste - Quinine
%     grabCountQuinine = grabCount(allLabels.quinine(expinds{l})==1);
%     [~, igrabsQ] = sort(grabCountQuinine, 'ascend');
%     plotIndicativeNrAndBehave(toneTime, fullfile(currfolder{l}, 'indicativeNrnsQuinine'), ...
%         dataAlltimes{l}(:, :, allLabels.quinine(expinds{l})==1), t, ...
%         fail(allLabels.quinine(expinds{l})==1), Sbehave{l}, Fbehave{l}, ...
%         {NeuronsLabels{l}},'Quinine', newNreINds, igrabsQ, xlimmin);
%     %% INdicative Neurons By Taste - Regular
%     grabCountRegular = grabCount(allLabels.regular(expinds{l})==1);
%     [~, igrabsR] = sort(grabCountRegular, 'ascend');
%     plotIndicativeNrAndBehave(toneTime, fullfile(currfolder{l}, 'indicativeNrnsReg'), ...
%         dataAlltimes{l}(:, :, allLabels.regular(expinds{l})==1), t, ...
%         fail(allLabels.regular(expinds{l})==1), Sbehave{l}, Fbehave{l}, ...
%         {NeuronsLabels{l}},'Regular', newNreINds, igrabsR, xlimmin);
% end
