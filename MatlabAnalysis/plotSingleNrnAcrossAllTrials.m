function plotSingleNrnAcrossAllTrials(outputPath, generalProperty, imagingData, BehaveData)

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
        error('the neuron selected for ploting is not exists in the neurons selected for analysis');
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
        plotsinglNrnPerAllTrials(labelsLUT{ci}, mA, MA,imagingData.roiNames, currnrnind, x, outputPath, '', labels, classes(ci), xlimmin, t,...
            m, M, X, behaveHist{ci}, generalProperty);        
        mysave(gcf, fullfile(outputPath, [labelsLUT{ci} 'Nr' num2str(imagingData.roiNames(currnrnind))]));
    end
    
end