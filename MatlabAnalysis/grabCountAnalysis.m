function grabCountAnalysis(outputPath, generalProperty, imagingData, BehaveData)

[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(...
BehaveData, generalProperty.labels2cluster, generalProperty.includeOmissions);


% go through all events having grabs and cound them
grabCount = zeros(length(examinedInds), 1);
for grab_i = 1:30
    eventname = sprintf('grab%02d', grab_i);
    if isfield(BehaveData, eventname)
        grabCount = grabCount + BehaveData.(eventname).indicatorPerTrial(examinedInds);
    end    
end

data = imagingData.samples(:, :, examinedInds);
t = linspace(0, generalProperty.Duration, size(data,2)) - generalProperty.ToneTime;
% evaluate baseline
start_baseline_time = -2;
end_baseline_time = 0;
meanbaseline = mean((mean(data(:, t<end_baseline_time & t > start_baseline_time, :), 2)),3);
stdbaseline  = std((mean(data(:, t<end_baseline_time & t > start_baseline_time, :), 2)),[], 3);
for T = 1:size(data,3)
    [peakvals(:, T), peakLocs(:, T)] = max(data(:, t > 0, T), [], 2);
    for nrni = 1:size(data,1)
        onsettemp = find(data(nrni, :, T)<=peakvals(nrni, T)-2*stdbaseline(nrni));
        onsettemp = onsettemp(onsettemp<peakLocs(nrni, T)+findClosestDouble(t, 0));
        if isempty(onsettemp)
            onset(nrni,T) = nan;
            offset(nrni,T) = nan;
            continue;
        end
        onset(nrni,T)=onsettemp(end);
        offsettemp = find(data(nrni, :, T)<=peakvals(nrni, T)-2*stdbaseline(nrni));
        offsettemp = offsettemp(offsettemp>peakLocs(nrni, T)+findClosestDouble(t, 0));
        if isempty(offsettemp)
            onset(nrni,T) = nan;
            offset(nrni,T) = nan;
            continue;
        end
        offset(nrni,T)=offsettemp(1);
        
    end
end
validpeaks = peakvals >= repmat(3*stdbaseline, 1, size(peakvals,2));
valid_peakvals = peakvals;
valid_peakvals(~validpeaks) = nan;
duration = offset - onset;
pvalth = 0.05;binsnum = 20;

[rho_dur,pval_durr] = getCorrelationPval(duration, grabCount, 'Duration', pvalth, binsnum);
mysave(gcf, fullfile(outputPath, 'grabDurationCorr'));
[rho_onset,pval_onset] = getCorrelationPval(onset, grabCount, 'Onset', pvalth, binsnum);
mysave(gcf, fullfile(outputPath, 'grabOnsetCorr'));

[rho_offset,pval_offset] = getCorrelationPval(offset, grabCount, 'Offset', pvalth, binsnum);
mysave(gcf, fullfile(outputPath, 'grabOffsetCorr'));

[rho_peakval,pval_peakval] = getCorrelationPval(valid_peakvals, grabCount, 'Peak Value', pvalth, binsnum);
mysave(gcf, fullfile(outputPath, 'grabPeakValCorr'));
