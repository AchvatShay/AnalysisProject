function f = plotDprime(t, dprime, dprimeNext, labelsFontSz, xlimmin, toneTime)



m = (min(0.9*min(sum(dprime.^2)), 0.9*min(sum(dprimeNext.^2))));
M = (max(1.1*max(sum(dprime.^2)), 1.1*max(sum(dprimeNext.^2))));


f(1)=figure;plot(t, sum(dprime.^2), 'k');xlabel('Time [sec]', 'FontSize', labelsFontSz);
ylabel('Sensitivity Index', 'FontSize', labelsFontSz);
axis tight;
set(gca, 'Box','off');
% % grid on;

a=get(gcf,'Children');
setAxisFontSz(a(end), labelsFontSz);
yticks = get(a, 'YTick');
M = yticks(end)+yticks(2)-yticks(1);
yticks=[yticks M];
ylim([m M]);
% set(a, 'YTick', yticks);
set(gca,'XLim',[xlimmin t(end)]);

placeToneTime(toneTime, 2);

f(2)=figure;
a1=subplot(1,2,1);
plot(t, sum(dprime.^2), 'k');xlabel('Time [sec]', 'FontSize', labelsFontSz);ylabel('Sensitivity Index', 'FontSize', labelsFontSz);
axis tight;
set(gca, 'Box','off');%grid on;
set(gca,'XLim',[xlimmin t(end)]);
fh=get(gca,'Children');
% set(fh(1),'YData', [m M])
a=get(f(2),'Children');
setAxisFontSz(a(end), labelsFontSz);
ylim([m M]);
% set(a, 'YTick', yticks);
placeToneTime(toneTime, 2);


a2=subplot(1,2,2);
plot(t, sum(dprimeNext.^2), 'k');
ax = get(gca,'YAxis');
set(ax,'Visible','off')
ylim([m M]);
% set(a, 'YTick', yticks);

% grid on;
set(gca,'XLim', [t(1) t(end)])

% Create line
annotation(f(2),'line',[0.530357142857143 0.508928571428571],...
    [0.141857142857143 0.0857142857142857]);

% Create line
annotation(f(2),'line',[0.548214285714286 0.526785714285714],...
    [0.141857142857143 0.0857142857142858]);
set(gca, 'Box','off');
set(a1,'Position', [0.1889    0.1135    0.3347    0.8150]);
set(a2,'Position', [0.5400    0.1148    0.3347    0.8150]);
set(gca, 'Box','off');

ah=get(f(2),'Children');
setAxisFontSz(ah(end-1), labelsFontSz);

d=get(a1,'XAxis');
d1=get(d,'Label');
loc = get(d1,'Position');
if loc(2) < -.5
    set(d1,'Position',[12.1604   -0.5133   -1.0000]);
else
    set(d1,'Position',[12.1604   -0.15   -1.0000]);
end
%  [left bottom width height]
% title(['S/F Sensitivity of ' method ' Trajectories']);
ticks=get(a2,'XTick');
set(a2,'XTick',ticks(2:end));
set(d1,'Visible','off');


f(3) = figure;
plot(t, sum(dprimeNext.^2), 'k');
ax = get(gca,'YAxis');
ylim([m M]);
% set(a, 'YTick', yticks);

% grid on;
set(gca,'XLim', [t(1) t(end)])

set(gca, 'Box','off');
xlabel('Time [sec]','FontSize',labelsFontSz);
ylabel('Sensitivity Index','FontSize',labelsFontSz);
