function [behaveHist] = getHistEventsAllTrails(BehaveData, Events2plot)

NAMES = fieldnames(BehaveData);

behaveHist = zeros(length(Events2plot), size(BehaveData.(NAMES{1}).indicator,2));

for event_i = 1:length(Events2plot)
    for name_i = 1:length(NAMES)
        if ~isempty(strfind(NAMES{name_i}, Events2plot{event_i}))
           behaveHist(event_i, :) = behaveHist(event_i, :) + sum(BehaveData.(NAMES{name_i}).indicator(:,:));         
        end
   end
end

behaveHist(event_i, :) = behaveHist(event_i, :)/size(BehaveData.(NAMES{1}).indicator,1);
