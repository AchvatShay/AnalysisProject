function [res, strTrials, Events2plotDelay]=getPeriEventHist( generalProperty, imagingData, BehaveData)

% extract behavioral data stats
% [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
%     generalProperty.labels2cluster, generalProperty.includeOmissions);
Events2plotDelay = generalProperty.Events2plotDelay;

t = linspace(0, generalProperty.Duration, size(imagingData.samples, 2)) - generalProperty.ToneTime;
fields = fieldnames(BehaveData);

tstim = -t(1);
trialinds{1} = true(size(imagingData.samples,3),1);
trialinds{2} = sum(BehaveData.(generalProperty.successLabel).indicator,2)>0;
trialinds{3} = sum(BehaveData.(generalProperty.failureLabel).indicator,2)>0;
strTrials = {'All',generalProperty.successLabel,generalProperty.failureLabel};
for ei = 1:length(Events2plotDelay)
    if strcmpi(Events2plotDelay{ei}, 'tone')
        
        
        delays.start=findClosestDouble(t,0)*ones(size(imagingData.samples,3), 1);
        behaveindicators = zeros(size(imagingData.samples,3), size(imagingData.samples, 2));
        behaveindicators(:, delays.start) = 1;
        
        
        for ti = 1:length(strTrials)            
            res.first{ei,ti}=getAlignedDataHist(delays.start(trialinds{ti}), behaveindicators(trialinds{ti},:).', ...
                t+tstim, imagingData.samples(:,:,trialinds{ti}==1), tstim);
            res.last{ei,ti}=res.first{ei,ti};
        end
        
        
        
        
        continue;
    end
    ind = find(strcmpi(Events2plotDelay{ei}, fields), 1);
    if isempty(ind)
        eventnumber = num2str(generalProperty.Events2plotDelayNumber{ei}, '%02d');
        ind = find(strcmp([lower(Events2plotDelay{ei}) eventnumber], fields), 1);
        if isempty(ind)
            continue;
%             error('Unrecognized event to plot');
        end
        
        indicators = contains(fields, Events2plotDelay{ei});
        behaveUnifiedIndicatormatrix = zeros(size(BehaveData.tone.indicator));
        for ini = 1:length(indicators)
            if indicators(ini) == 1
                behaveUnifiedIndicatormatrix = behaveUnifiedIndicatormatrix | BehaveData.(fields{ini}).indicator;
            end
        end
        
        [tstampFirst, tstampLast] = getEventTimeStampFirstLast(behaveUnifiedIndicatormatrix.', t>generalProperty.delay2events_start_time & t<generalProperty.delay2events_end_time);
        
    else
        [tstampFirst, tstampLast] = getEventTimeStampFirstLast(BehaveData.(fields{ind}).indicator.', t>generalProperty.delay2events_start_time & t<generalProperty.delay2events_end_time);
    end
    
    
    
    % first
    for ti = 1:length(strTrials)
        res.first{ei,ti}=getAlignedDataHist(tstampFirst.start(trialinds{ti}), behaveUnifiedIndicatormatrix(trialinds{ti},:).', ...
            t+tstim, imagingData.samples(:,:,trialinds{ti}==1), tstim);
        % last
        res.last{ei,ti}=getAlignedDataHist(tstampLast.start(trialinds{ti}), behaveUnifiedIndicatormatrix(trialinds{ti},:).', ...
            t+tstim, imagingData.samples(:,:,trialinds{ti}==1), tstim);
    end
    
    
end

