function [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(...
    BehaveData, eventsList, includeOmissions)


examinedInds = [];
for event_i = 1:length(eventsList)    
    if ~isfield(BehaveData, eventsList{event_i}{1})
        error([eventsList{event_i}{1} ' is not labeled as a behavioral label on the BDA files']);
    end
    currExaminedInds = find(BehaveData.(eventsList{event_i}{1}));
    for name_i = 2:length(eventsList{event_i})
        if ~isfield(BehaveData, eventsList{event_i}{name_i})
            error([eventsList{event_i}{name_i} ' is not labeled as a behavioral label on the BDA files']);
        end
        currExaminedInds = intersect(currExaminedInds, find(BehaveData.(eventsList{event_i}{name_i})));
    end
    examinedInds = cat(1, examinedInds, currExaminedInds);
end
if length(examinedInds) ~= length(unique(examinedInds))
    error('The events you chose for accuracy are true for the same trial. Please choose non-overlapping trials');
end
examinedInds = sort(examinedInds);

if includeOmissions
    if ~isfield(BehaveData, 'nopellet') || all(BehaveData.noPellet == 0)
        error('Cannot include omissions because there are no trials marked with "nopellet"');
    end
else
    if isfield(BehaveData, 'nopellet')
        examinedInds = setdiff(examinedInds, find(BehaveData.nopellet));
    end
end
labels = zeros(length(examinedInds), 1);
for event_i = 1:length(eventsList)
    currlabelsval = BehaveData.(eventsList{event_i}{1});
    for name_i = 2:length(eventsList{event_i})
        currlabelsval = currlabelsval &  BehaveData.(eventsList{event_i}{name_i});
    end
    labels = labels + currlabelsval*2^(event_i-1);
end
labelsLUT{1} = eventsList{1}{1};
eventsStr = ['_' eventsList{1}{1}];
for name_i = 2:length(eventsList{1})
    eventsStr = [eventsStr 'And' eventsList{1}{name_i}];
    labelsLUT{1} = [labelsLUT{1} 'And' eventsList{1}{name_i}];
end
for event_i = 2:length(eventsList)
    eventsStr = [eventsStr '_' eventsList{event_i}{1}]; %#ok<*AGROW>
    labelsLUT{event_i} = eventsList{event_i}{1};
    for name_i = 2:length(eventsList{1})
        eventsStr = [eventsStr 'And' eventsList{event_i}{name_i}];
        labelsLUT{event_i} = [labelsLUT{event_i} 'And' eventsList{event_i}{name_i}];
    end
end