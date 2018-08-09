function placeToneTime(toneTime, lw)
if ~isempty(toneTime)
line([toneTime toneTime], get(gca, 'YLim'), 'Color','k','LineWidth',lw, 'LineStyle', ':');
end