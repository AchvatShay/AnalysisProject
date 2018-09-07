function [atop, hline] = plotAccResFinal(tmid, accSVM,  chanceLevel, behaveHist, t, toneTime, labelsFontSz, xlimMin, eventNames)


if length(behaveHist) ~= 2
    error('This plot would not work well');
end
figure;

atop = subplot(2,1,1);

shadedErrorBar(tmid,accSVM.raw.mean,accSVM.raw.std,'lineprops',{'-k'});

ylabel('Accuracy', 'FontSize',labelsFontSz);axis tight;
hold all;

plot(tmid, ones(size(tmid))*chanceLevel, '--k');

% ylim([0 1]);
ylim([min(chanceLevel*.9, min(get(gca,'YLim'))), max(1,  max(get(gca,'YLim')))]);
xlim([xlimMin, tmid(end)]);
hline = placeToneTime(toneTime, 2);
set(gca, 'Box','off');


    subplot(4,1,3);
     l=plotBehaveHist(t, behaveHist{1}, toneTime, eventNames);
    set(l, 'Visible','off');
    %     title('Events At Success');%ylabel('Event probability ')
    ylabel('');xlim([xlimMin, tmid(end)]);
    
    subplot(4,1,4);
    l=plotBehaveHist(t, behaveHist{2}, toneTime, eventNames);
    set(l,'Visible','off')
    xlim([xlimMin, tmid(end)]);
    
    xlabel('Time [sec]', 'FontSize',labelsFontSz);
    %     title('Events At Failure');
    h=ylabel('Event Probability', 'FontSize',labelsFontSz);
    set(h, 'Position',[-3.1568    1.2544   -1.0000]);
    set(atop, 'XLim', get(gca, 'XLim'));
    set(atop, 'XTick', get(gca, 'XTick'))

end