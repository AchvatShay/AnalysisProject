function plotSingleNrnAcrossAllTrials(outputPath, generalProperty, imagingData, BehaveData)

% 1. grab counts per trial
% grabCount = getGrabCounts(eventTimeGrab{end}, findClosestDouble(t, toneTime), findClosestDouble(t, toneTime+2), frameRateRatio{1});
grabCount = getGrabCounts(BehaveData, generalProperty.time2startCountGrabs, generalProperty.time2endCountGrabs, generalProperty.ImagingSamplingRate);
% 2. discard trials with no suc or fail

% 3. obtain histograms of behave events
[behaveHist] = getHistEventsAllTrails(BehaveData, generalProperty.Events2plot);

if (~isnan(grabCount))
    grabCount = grabCount(:);
end

% [Sbehave, Fbehave, allbehave] = getHistEvents(BehaveData, generalProperty.Events2plot, examinedInds);
X = imagingData.samples;

if (~isnan(grabCount))
    [~, igrabs] = sort(grabCount);
    X=X(:,:,igrabs);
end

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
    mA = min(mA, min(mean(X(currnrnind,:,:),3)));
    MA = -inf;
    MA = max(MA, max(mean(X(currnrnind,:,:),3)));

    DN = MA-mA;
    mA=mA-DN*.1;
    MA=MA+DN*.1;

     plotsinglNrnPerAllTrials('All Trails', mA, MA,imagingData.roiNames, currnrnind, x, xlimmin, t,...
            m, M, X, behaveHist, generalProperty);        
     mysave(gcf, fullfile(outputPath, ['All Trails' 'Nr' num2str(imagingData.roiNames(currnrnind))]));
    
end