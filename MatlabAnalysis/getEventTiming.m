function eventTiming = getEventTiming(behaveEvents, labelsBehave, trialsinds)

for event_i = 1:length(behaveEvents)
    for trial_i = 1:length(trialsinds)
        eventTiming.(behaveEvents{event_i}){trial_i} = [];
        currtrial = labelsBehave.(behaveEvents{event_i})(:, trialsinds(trial_i));
        if currtrial(1) == 0
            currevent=0;
        else
            currevent = 1;
            eventTiming.(behaveEvents{event_i}){trial_i}{end+1}(1) = 1;
        end
        for time_i = 1:length(currtrial)
            if currevent == 0 && currtrial(time_i) == 0
                % no event do nothing
            elseif currevent == 0 && currtrial(time_i) == 1
                % event started
                eventTiming.(behaveEvents{event_i}){trial_i}{end+1}(1) = time_i;
                currevent = 1;
            elseif currevent == 1 && currtrial(time_i) == 0
                % event ended
                eventTiming.(behaveEvents{event_i}){trial_i}{end}(2) = time_i;
                currevent = 0;
            else
                % event continue do nothing
            end
        end
        if length(eventTiming.(behaveEvents{event_i}){trial_i}) > 0 && length(eventTiming.(behaveEvents{event_i}){trial_i}{end}) == 1
            eventTiming.(behaveEvents{event_i}){trial_i}{end}(2) = time_i;
        end
    end
end
