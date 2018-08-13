function [tstampFirst, tstampLast] = getStartEndEventTimes(tryinginds, BehaveData, eventName, tindicator)

Names = fieldnames(BehaveData);
BehaveDatagrab = zeros(length(tryinginds), length(tindicator));
for event_i = 1:length(Names)
    if contains(lower(Names{event_i}), eventName)  
     BehaveDatagrab = BehaveDatagrab | BehaveData.(Names{event_i}).indicator(tryinginds, :);
    end
end
[tstampFirstgrab, tstampLastgrab] = getEventTimeStampFirstLast(BehaveDatagrab.', tindicator);
tstampLast.start = tstampLastgrab.start;
tstampFirst.start = tstampFirstgrab.start;

% Names = fieldnames(BehaveData);
% 
% tstampFirst = zeros(length(tryinginds),1);
% tstampLast = zeros(length(tryinginds),1);
% for event_i = 1:length(Names)
%     if contains(lower(Names{event_i}), lower(eventName))  
%         behaveTimes = BehaveData.(Names{event_i}).eventTimeStamps;
%         for trial_i = 1:length(tryinginds)
%             if tstampFirst(trial_i) == 0
%                 if length(behaveTimes) >= tryinginds(trial_i) && ~isempty(behaveTimes{tryinginds(trial_i)})
%                     currstart = behaveTimes{tryinginds(trial_i)}(1);
%                     currend = behaveTimes{tryinginds(trial_i)}(2);
%                     if currstart > startBehaveTime && currend < endBehaveTime
%                         tstampFirst(trial_i) = currstart;                    
%                         tstampLast(trial_i) = currend;
%                     end
%                 end
%             end
%         end
%     end
%     if all(tstampLast ~= 0)
%         break;
%     end
% end