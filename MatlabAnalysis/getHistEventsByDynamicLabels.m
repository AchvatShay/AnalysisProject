function [behaveHist, allbehave] = getHistEventsByDynamicLabels(generalProperty, BehaveData, Events2plot, tryinginds)

NAMES = fieldnames(BehaveData);
[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(...
BehaveData, generalProperty.labels2cluster, generalProperty.includeOmissions);
classes = unique(labels);
for ci = 1:length(classes)
behaveHist{ci} = zeros(length(Events2plot), size(BehaveData.(NAMES{1}).indicator,2));
end
allbehave = zeros(length(Events2plot), size(BehaveData.(NAMES{1}).indicator,2));


for event_i = 1:length(Events2plot)
    for name_i = 1:length(NAMES)
        if ~isempty(strfind(NAMES{name_i}, Events2plot{event_i}))
            for ci = 1:length(classes)
                behaveHist{ci}(event_i, :) = behaveHist{ci}(event_i, :) + sum(BehaveData.(NAMES{name_i}).indicator(intersect(find(BehaveData.(labelsLUT{ci}).indicatorPerTrial),examinedInds),:));
            end
           allbehave(event_i, :) = allbehave(event_i, :) + sum(BehaveData.(NAMES{name_i}).indicator(examinedInds,:));
      end
   end
end
allbehave = allbehave/length(examinedInds);
for ci = 1:length(classes)
behaveHist{ci} = behaveHist{ci}/sum(BehaveData.(labelsLUT{ci}).indicatorPerTrial(examinedInds));
end
