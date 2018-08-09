function lh=plotBehaveHist(t, behave, toneTime, eventNames)
leg = {};
for event_i = 1:length(eventNames)
    if all(behave(event_i, :)==0)
        continue;
    end
    leg{end+1} = eventNames{event_i};
    switch eventNames{event_i}
        case 'lift'
            plot(t, behave(event_i, :), 'b','LineWidth',3);
            hold all;
        case 'grab'
            plot(t, behave(event_i, :), 'g','LineWidth',3);
            hold all;
        case 'atmouth'
            plot(t, behave(event_i, :), 'r','LineWidth',3);
            hold all;
        case 'lick'
            plot(t, behave(event_i, :), 'm','LineWidth',3);
            hold all;
        otherwise
            plot(t, behave(event_i, :), 'LineWidth',3);
            hold all;
    end
end
lh = legend(leg);
set(lh,'FontSize',10,'Location','NorthEast')
ylim([0 (max(1, max(get(gca, 'Ylim'))))]);

placeToneTime(toneTime, 2);
set(gca, 'Box','off');

set(gca, 'Box','off');
ylabel('Event Probability','FontSize',10);
