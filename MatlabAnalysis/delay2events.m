function delay2events(outputPath, generalProperty, imagingData, BehaveData)
labelsFontSz = generalProperty.visualization_labelsFontSize;

% extract behavioral data stats
% [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
%     generalProperty.labels2cluster, generalProperty.includeOmissions);
Events2plotDelay = generalProperty.Events2plotDelay;

t = linspace(0, generalProperty.Duration, size(imagingData.samples, 2)) - generalProperty.ToneTime;
fields = fieldnames(BehaveData);

tstim = -t(1);
    trialinds{1} = ones(size(imagingData.samples,3),1);
    trialinds{2} = sum(BehaveData.(generalProperty.successLabel).indicator,2)>0;
    trialinds{3} = sum(BehaveData.(generalProperty.failureLabel).indicator,2)>0;
    strTrials = {'All','Success','Failure'};
for ei = 1:length(Events2plotDelay)
    if strcmpi(Events2plotDelay{ei}, 'tone')
        
        
        delays.start=findClosestDouble(t,0)*ones(size(imagingData.samples,3), 1);
        behaveindicators = zeros(size(imagingData.samples, 2), size(imagingData.samples,3));
        behaveindicators(delays.start, :) = 1;
        
        
        for ti = 1:length(strTrials)
    plotAlignedDataHist(outputPath, '', strTrials{ti}, Events2plotDelay{ei}, ...
        delays.start(trialinds{ti}), behaveindicators(:, trialinds{ti}), ...
        t+tstim, imagingData.samples(:,:,trialinds{ti}), tstim, labelsFontSz);
    
        end
        continue;
    end
    ind = find(strcmpi(Events2plotDelay{ei}, fields), 1);
    if isempty(ind)
        ind = find(strcmp([lower(Events2plotDelay{ei}) '01'], fields), 1);
    end
    if isempty(ind)
        error('Unrecognized event to plot');
    end
    
    [tstampFirst, tstampLast] = getEventTimeStampFirstLast(BehaveData.(fields{ind}).indicator.', t>0& t<2);
    
    for ti = 1:length(strTrials)
    % first
    plotAlignedDataHist(outputPath, 'First', strTrials{ti}, Events2plotDelay{ei}, ...
        tstampFirst.start(trialinds{ti}), BehaveData.(fields{ind}).indicator(trialinds{ti},:).', ...
        t+tstim, imagingData.samples(:,:,trialinds{ti}), tstim, labelsFontSz);
    % last
    plotAlignedDataHist(outputPath, 'Last', strTrials{ti}, Events2plotDelay{ei}, ...
        tstampLast.start(trialinds{ti}), BehaveData.(fields{ind}).indicator(trialinds{ti},:).', ...
        t+tstim, imagingData.samples(:,:,trialinds{ti}), tstim, labelsFontSz);
    end
   

    
end