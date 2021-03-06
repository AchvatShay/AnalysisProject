function plotSingleNrnAcrossTrials(outputPath, generalProperty, imagingData, BehaveData)

% extract behavioral data stats
[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
    generalProperty.labels2cluster, generalProperty.includeOmissions);

% 1. grab counts per trial
% grabCount = getGrabCounts(eventTimeGrab{end}, findClosestDouble(t, toneTime), findClosestDouble(t, toneTime+2), frameRateRatio{1});
grabCount = getGrabCounts(BehaveData, generalProperty.time2startCountGrabs, generalProperty.time2endCountGrabs, generalProperty.ImagingSamplingRate);
% 2. discard trials with no suc or fail

if (~isnan(grabCount))
    grabCount = grabCount(examinedInds);
end

% 3. obtain histograms of behave events
[behaveHist, allbehave] = getHistEventsByDynamicLabels(generalProperty, BehaveData, generalProperty.Events2plot, examinedInds);

% [Sbehave, Fbehave, allbehave] = getHistEvents(BehaveData, generalProperty.Events2plot, examinedInds);
X = imagingData.samples;

% if ~isempty(generalProperty.PlotSingleNrnAcrossTrials_AlignedEvent_Name) && ~isempty(generalProperty.PlotSingleNrnAcrossTrials_AlignedEvent_Num) 
%     delays = alignedDataAccordingToEvent(generalProperty.PlotSingleNrnAcrossTrials_AlignedEvent_Name, generalProperty.PlotSingleNrnAcrossTrials_AlignedEvent_Num, BehaveData);
%     alignedEventName = [generalProperty.alignedOrderByDataAccordingToEvent_eventName num2str(generalProperty.alignedOrderByDataAccordingToEvent_eventNum)];
% else
%     delays = findClosestDouble(t,toneTime)*ones(size(imagingData.samples,3), 1); 
%     alignedEventName = 'tone';
% end

X=X(:,:,examinedInds);

if (~isnan(grabCount))
    [~, igrabs] = sort(grabCount);
    X=X(:,:,igrabs);
end


if (~isnan(grabCount))
    labels = labels(igrabs);
end
classes = unique(labels);
t = linspace(0, generalProperty.Duration, size(X,2)) - generalProperty.ToneTime;
nerons2plot = generalProperty.Neurons2plot;
% visualize
M=2;
m=-.15;
xlimmin = generalProperty.visualization_startTime2plot-generalProperty.ToneTime;
for nrind=1:length(nerons2plot)
    curr_nrn2plot = nerons2plot(nrind);
    currnrnind = find(imagingData.roiNames(:,1)-curr_nrn2plot==0);
    
    if isempty(currnrnind)
        continue;
%         error('the neuron selected for ploting is not exists in the neurons selected for analysis');
    end
    
    x = squeeze(X(currnrnind,:,:))';
    mA = inf;
    for ci = 1:length(classes)
        mA = min(mA, min(mean(X(currnrnind,:,labels==classes(ci)),3)));
    end
    MA = -inf;
    for ci = 1:length(classes)
        MA = max(MA, max(mean(X(currnrnind,:,labels==classes(ci)),3)));
    end
    DN = MA-mA;
    mA=mA-DN*.1;
    MA=MA+DN*.1;
    for ci = 1:length(classes)
        plotsinglNrnPerTrials(labelsLUT{ci}, mA, MA,imagingData.roiNames, currnrnind, x, outputPath, '', labels, classes(ci), xlimmin, t,...
            m, M, X, behaveHist{ci}, generalProperty);        
        mysave(gcf, fullfile(outputPath, [labelsLUT{ci} 'Nr' num2str(imagingData.roiNames(currnrnind))]));
    end
    
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


    if (~isnan(grabCount))
        labelsTaste = labelsTaste(igrabs);
    end
    classes_Taste = unique(labelsTaste);

    for nrind=1:length(nerons2plot)
        curr_nrn2plot = nerons2plot(nrind);
        currnrnind = find(imagingData.roiNames(:,1)-curr_nrn2plot==0);

        if isempty(currnrnind)
            error('the neuron selected for ploting is not exists in the neurons selected for analysis');
        end

        x_taste = squeeze(X_Taste(currnrnind,:,:))';
        mA = inf;
        for ci = 1:length(classes_Taste)
            mA = min(mA, min(mean(X_Taste(currnrnind,:,labelsTaste==classes_Taste(ci)),3)));
        end
        MA = -inf;
        for ci = 1:length(classes_Taste)
            MA = max(MA, max(mean(X_Taste(currnrnind,:,labelsTaste==classes_Taste(ci)),3)));
        end
        DN = MA-mA;
        mA=mA-DN*.1;
        MA=MA+DN*.1;

        for ci = 1:length(classes_Taste)
            plotsinglNrnPerTrials(labelsLUTTaste{ci}, mA, MA,imagingData.roiNames, currnrnind, x_taste, outputPath, '', labelsTaste, classes_Taste(ci), xlimmin, t,...
                m, M, X_Taste, [], generalProperty);        
            mysave(gcf, fullfile(outputPath, [labelsLUTTaste{ci} 'Nr' num2str(imagingData.roiNames(currnrnind))]));
        end
    end
end
 
% %% all trials
% mA1 = min(mean(mean(X(:,:,labels==0),3),1));
% MA1 = max(mean(mean(X(:,:,labels==0),3),1));
% mA2 = min(mean(mean(X(:,:,labels==1),3),1));
% MA2 = max(mean(mean(X(:,:,labels==1),3),1));
% mA = min(mA1, mA2);
% MA = max(MA1, MA2);
% DN = MA-mA;
% mA=mA-DN*.1;
% MA=MA+DN*.1;
% figure;
% % 1
% htop = subplot(2,1,1);
% imagesc(t, 1:size(X,1),mean(X,3),[-.15 2]);
% colormap jet;ylabel('Neurons','FontSize',10);
% placeToneTime(toneTime, 3);xlim([xlimmin,tending])
%
% c=colorbar;
% set(c,'Position',[0.9196    0.5810    0.0402    0.3452]);
% % set(htop,'Position',[0.1300    0.5071    0.7750    0.4179]);
% set(gca, 'YTick', unique([1 get(gca, 'YTick')]))
% % 2
% hmid=subplot(4,1,3);
% plot(t,mean(mean(X,3),1), 'LineWidth',3, 'Color','k');
% ylabel('Average','FontSize',10);
% set(gca, 'YLim', [mA MA]);
% placeToneTime(toneTime, 2);
% set(gca, 'Box','off');
% set(gca, 'XTick',[]);
% % set(hmid, 'Position', [0.1300    0.3291    0.7750    0.1066]);
% xlim([xlimmin,tending])
% xa=get(gca, 'XAxis');
% set(xa,'Visible', 'off')
% % 3
% wfail = sum(labels)/length(labels);
% subplot(4,1,4);
% l=plotBehaveHist(t, (1-wfail)*Sbehave+Fbehave*wfail, toneTime);
% set(l, 'Visible','off');
% xlabel('Time [sec]','FontSize',10);
% xlim([xlimmin,tending])
% mysave(gcf, fullfile(currfolder, 'alltrialsActivity'));
%
% figure;
% % 1
% htop = subplot(2,1,1);
% imagesc(t, 1:size(X,1),mean(X(:,:,labels==0),3),[-.15 2]);
% colormap jet;ylabel('Neurons','FontSize',10);
% placeToneTime(toneTime, 3);xlim([xlimmin,tending])
%
% c=colorbar;
% set(c,'Position',[0.9196    0.5810    0.0402    0.3452]);
% % set(htop,'Position',[0.1300    0.5071    0.7750    0.4179]);
% set(gca, 'YTick', unique([1 get(gca, 'YTick')]))
% % 2
% hmid=subplot(4,1,3);
% plot(t,mean(mean(X(:,:,labels==0),3),1), 'LineWidth',3, 'Color','k');
% ylabel('Average','FontSize',10);
% set(gca, 'YLim', [mA MA]);
% placeToneTime(toneTime, 2);
% set(gca, 'Box','off');
% set(gca, 'XTick',[]);
% % set(hmid, 'Position', [0.1300    0.3291    0.7750    0.1066]);
% xlim([xlimmin,tending])
% xa=get(gca, 'XAxis');
% set(xa,'Visible', 'off')
% % 3
% subplot(4,1,4);
% l=plotBehaveHist(t, Sbehave, toneTime);
% set(l, 'Visible','off');
% xlabel('Time [sec]','FontSize',10);
% xlim([xlimmin,tending])
% mysave(gcf, fullfile(currfolder, 'sucTrialsActivity'));
%
%
%
% figure;
% % 1
% htop = subplot(2,1,1);
% imagesc(t, 1:size(X,1),mean(X(:,:,labels==1),3),[-.15 2]);
% colormap jet;ylabel('Neurons','FontSize',10);
% placeToneTime(toneTime, 3);xlim([xlimmin,tending])
%
% c=colorbar;
% set(c,'Position',[0.9196    0.5810    0.0402    0.3452]);
% % set(htop,'Position',[0.1300    0.5071    0.7750    0.4179]);
% set(gca, 'YTick', unique([1 get(gca, 'YTick')]))
% % 2
% hmid=subplot(4,1,3);
% plot(t,mean(mean(X(:,:,labels==1),3),1), 'LineWidth',3, 'Color','k');
% ylabel('Average','FontSize',10);
% set(gca, 'YLim', [mA MA]);
% placeToneTime(toneTime, 2);
% set(gca, 'Box','off');
% set(gca, 'XTick',[]);
% % set(hmid, 'Position', [0.1300    0.3291    0.7750    0.1066]);
% xlim([xlimmin,tending]);
% xa=get(gca, 'XAxis');
% set(xa,'Visible', 'off')
% % 3
% subplot(4,1,4);
% l=plotBehaveHist(t, Fbehave, toneTime);
% set(l, 'Visible','off');
% xlabel('Time [sec]','FontSize',10);
% xlim([xlimmin,tending])
% mysave(gcf, fullfile(currfolder, 'failTrialsActivity'));


