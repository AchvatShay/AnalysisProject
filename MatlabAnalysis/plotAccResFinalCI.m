function [atop, h, htoneLine] = plotAccResFinalCI(tmid, accSVM,  chanceLevel, behaveHist, t, toneTime, labelsFontSz, xlmMin, eventNames)
if length(behaveHist) ~= 2
    error('This plot would not work well');
end
if all(behaveHist{1} == 0)
    plotHist = 0;
else
    plotHist = 2;
end


figure;
if plotHist~=0
    atop = subplot(2,1,1);
else
    atop=[];
end
shadedErrorBar(tmid,accSVM.raw.mean,accSVM.raw.mean-accSVM.raw.C(1,:),'lineprops',{'-k'});
xlim([xlmMin, tmid(end)]);
ylabel('Accuracy', 'FontSize',labelsFontSz);axis tight;
hold all;

plot(tmid, ones(size(tmid))*chanceLevel, '--k');

% ylim([0 1]);
ylim([min(chanceLevel*.9, min(get(gca,'YLim'))), max(1,  max(get(gca,'YLim')))]);

htoneLine = placeToneTime(toneTime, 2);
set(gca, 'Box','off');
if isempty(atop)
    atop=gca;
end
if plotHist > 0
    subplot(4,1,3);
    
    l=plotBehaveHist(t, behaveHist{1}, toneTime, eventNames);
    set(l, 'Visible','off');
    %     title('Events At Success');%ylabel('Event probability ')
    ylabel('');xlim([xlmMin, tmid(end)]);
    
    subplot(4,1,4);
    l=plotBehaveHist(t, behaveHist{2}, toneTime, eventNames);
    set(l,'Visible','off')
    xlim([xlmMin, tmid(end)]);
    
    xlabel('Time [sec]', 'FontSize',labelsFontSz);
    %     title('Events At Failure');
    h=ylabel('Event Probability', 'FontSize',labelsFontSz);
    set(h, 'Position',[-0.8111    1.2424   -1.0000]);
    set(atop, 'XLim', get(gca, 'XLim'));
    set(atop, 'XTick', get(gca, 'XTick'));
else
    %     title('Events At Success');%ylabel('Event probability ')
    ylabel('');xlim([xlmMin, tmid(end)]);
    %     title('Events At Failure');
    h=ylabel('Event Probability', 'FontSize',labelsFontSz);
    set(h, 'Position',[-0.8111    1.2424   -1.0000]);
end
end