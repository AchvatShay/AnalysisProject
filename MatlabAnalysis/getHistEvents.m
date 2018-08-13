function [Sbehave, Fbehave, allbehave] = getHistEvents(BehaveData, Events2plot, tryinginds)

NAMES = fieldnames(BehaveData);
Sbehave = zeros(length(Events2plot), size(BehaveData.(NAMES{1}).indicator,2));
Fbehave = zeros(length(Events2plot), size(BehaveData.(NAMES{1}).indicator,2));
allbehave = zeros(length(Events2plot), size(BehaveData.(NAMES{1}).indicator,2));


for event_i = 1:length(Events2plot)
   for name_i = 1:length(NAMES)
      if ~isempty(strfind(NAMES{name_i}, Events2plot{event_i}))
          Sbehave(event_i, :) = Sbehave(event_i, :) + sum(BehaveData.(NAMES{name_i}).indicator(intersect(find(BehaveData.success),tryinginds),:));
          Fbehave(event_i, :) = Fbehave(event_i, :) + sum(BehaveData.(NAMES{name_i}).indicator(intersect(find(BehaveData.failure),tryinginds),:));
          allbehave(event_i, :) = allbehave(event_i, :) + sum(BehaveData.(NAMES{name_i}).indicator(tryinginds,:));
      end
   end
end
allbehave = allbehave/length(tryinginds);
Fbehave = Fbehave/length(tryinginds);
Sbehave = Sbehave/length(tryinginds);