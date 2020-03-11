function dprimeAverageAnalysis(outputPath, generalProperty, analysisRes, BehaveData)

if isfield(analysisRes, 'dprime')
    name = 'dprime';
    namenext = 'dprimeNext';
else
    name = 'dprimeSmoothed';
    namenext = 'dprimeNextSmoothed';
end
toneTime = generalProperty.ToneTime;
labelsFontSz = generalProperty.visualization_labelsFontSize;
xlimmin = generalProperty.visualization_startTime2plot-toneTime;


mindim = inf;
for k=1:length(analysisRes)
    mindim = min(mindim, size(analysisRes(k).(name),1));
end
for k=1:length(analysisRes)
    
   vec(1,:, k) = sum(analysisRes(k).(name)(1:mindim,:,:).^2); 
   vecNext(1,:, k) =  sum(analysisRes(k).(namenext)(1:mindim,:,:).^2); 
end
dprime = mean(vec, 3);
S=std(vec,[],3);
N = size(vec,3);
dprimeNext = mean(vecNext, 3);
Snext=std(vecNext,[],3);
Nnext = size(vecNext,3);
t = linspace(0, generalProperty.Duration, size(dprime,2)) - toneTime;

minval = (min(0.9*min(dprime), 0.9*min(dprimeNext)));
maxval = (max(1.1*max(dprime), 1.1*max(dprimeNext)));


f(1)=figure;shadedErrorBar(t, dprime, S/sqrt(N),'lineprops','k');xlabel('Time [sec]', 'FontSize', labelsFontSz);
ylabel('Sensitivity Index', 'FontSize', labelsFontSz);
axis tight;
set(gca, 'Box','off');
% % grid on;

a=get(gcf,'Children');
setAxisFontSz(a(end), labelsFontSz);
yticks = get(a, 'YTick');
maxval = yticks(end)+yticks(2)-yticks(1);
yticks=[yticks maxval];
ylim([minval maxval]);
% set(a, 'YTick', yticks);
set(gca,'XLim',[xlimmin t(end)]);

placeToneTime(0, 2);

f(2)=figure;
a1=subplot(1,2,1);
shadedErrorBar(t, dprime, S/sqrt(N),'lineprops','k');xlabel('Time [sec]', 'FontSize', labelsFontSz);ylabel('Sensitivity Index', 'FontSize', labelsFontSz);
axis tight;
set(gca, 'Box','off');%grid on;
set(gca,'XLim',[xlimmin t(end)]);
fh=get(gca,'Children');
% set(fh(1),'YData', [m maxval])
a=get(f(2),'Children');
setAxisFontSz(a(end), labelsFontSz);
ylim([minval maxval]);
% set(a, 'YTick', yticks);
placeToneTime(0, 2);


a2=subplot(1,2,2);
shadedErrorBar(t, dprimeNext, Snext/sqrt(Nnext),'lineprops','k');
ax = get(gca,'YAxis');
set(ax,'Visible','off')
ylim([minval maxval]);
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
shadedErrorBar(t, dprimeNext, Snext/sqrt(Nnext),'lineprops','k');
ax = get(gca,'YAxis');
ylim([minval maxval]);
% set(a, 'YTick', yticks);

% grid on;
set(gca,'XLim', [t(1) t(end)])

set(gca, 'Box','off');
xlabel('Time [sec]','FontSize',labelsFontSz);
ylabel('Sensitivity Index','FontSize',labelsFontSz);



mysave(f(1), fullfile(outputPath, [name 'All'  ] ));
mysave(f(2), fullfile(outputPath, [name 'PrevCurrAll' ]));
mysave(f(3), fullfile(outputPath, [name 'NextAll' ]));