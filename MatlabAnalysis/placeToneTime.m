function hline = placeToneTime(toneTime, lw)
if ~isempty(toneTime)
hline = line([toneTime toneTime], get(gca, 'YLim'), 'Color','k','LineWidth',lw, 'LineStyle', ':');
end