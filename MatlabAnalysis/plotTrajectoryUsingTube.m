function f=plotTrajectoryUsingTube(xlimmin, t, trajData, labels, clrs, toneTime, labelsFontSz)

f(1)=figure;
map=colormap('jet');
labels1=labels+1;
labelsR=round(size(map,1)*(labels1)/(max(labels1)));
classes = unique(labels1);
for k=1:length(classes)
    for d = 1:3
    meanVals(d, :, k) = mean(permute(trajData(d,:,labels1==classes(k)),[2 3 1]),2);
    eVals(d, :, k) = mean(std(permute(trajData(d,:,labels1==classes(k)),[2 3 1]),0,2),3);
varVals(d, :, k) = mean(var(permute(trajData(d,:,labels1==classes(k)),[2 3 1]),0,2),3);
    end
%     shadedTraj(meanVals(1:2, :, k),eVals(1:2, :, k),'lineprops',{'-b'});
    tubeplot(meanVals(:, :, k), mean(mean(eVals(:, :, k))));hold all;
end
c=get(gca, 'Children');
for c_i = 1:length(c)
   set(c(c_i), 'FaceColor', clrs(c_i,:)); 
end

xlabel('\psi_1', 'FontSize', labelsFontSz);
ylabel('\psi_2', 'FontSize', labelsFontSz);
zlabel('\psi_3', 'FontSize', labelsFontSz);

a = get(gcf,'Children');
setAxisFontSz(a(end), labelsFontSz);
if length(classes) == 1
    return
end
trajData=trajData(:,:,2:end);
labels1=labels1(1:end-1);
for k=1:length(classes)
    for d = 1:3
    meanValsNext(d, :, k) = mean(permute(trajData(d,:,labels1==classes(k)),[2 3 1]),2);
varValsNext(d, :, k) = mean(var(permute(trajData(d,:,labels1==classes(k)),[2 3 1]),0,2),3);
    end
end

meanValsAll = cat(2,meanVals, meanValsNext);
varValsAll = cat(2,varVals, varValsNext);

dprime = (meanVals(:,:,1)-meanVals(:,:,2))./sqrt(0.5*(varVals(:,:,1)+varVals(:,:,2)));
dprimeNext = (meanValsNext(:,:,1)-meanValsNext(:,:,2))./sqrt(0.5*(varValsNext(:,:,1)+varValsNext(:,:,2)));

m = floor(min(0.9*min(sum(dprime.^2)), 0.9*min(sum(dprimeNext.^2))));
M = ceil(max(1.1*max(sum(dprime.^2)), 1.1*max(sum(dprimeNext.^2))));
if length(classes) == 1
    f(2) = [];
    f(3) = [];
    return;
end

f(2)=figure;plot(t, sum(dprime.^2), 'k');xlabel('Time [sec]', 'FontSize', labelsFontSz);
ylabel('Sensitivity Index', 'FontSize', labelsFontSz);
axis tight;
set(gca, 'Box','off');
% % grid on;

a=get(gcf,'Children');
setAxisFontSz(a(end), labelsFontSz);
yticks = get(a, 'YTick');
M = yticks(end)+yticks(2)-yticks(1);
yticks=[yticks M];
ylim([m M]);set(a, 'YTick', yticks);
set(gca,'XLim',[xlimmin t(end)]);

placeToneTime(toneTime, 2);

f(3)=figure;
a1=subplot(1,2,1);
plot(t, sum(dprime.^2), 'k');xlabel('Time [sec]', 'FontSize', labelsFontSz);ylabel('Sensitivity Index', 'FontSize', labelsFontSz);
axis tight;
set(gca, 'Box','off');%grid on;
set(gca,'XLim',[xlimmin t(end)]);
fh=get(gca,'Children');
% set(fh(1),'YData', [m M])
a=get(f(3),'Children');
setAxisFontSz(a(end), labelsFontSz);
ylim([m M]);set(a, 'YTick', yticks);
placeToneTime(toneTime, 2);


a2=subplot(1,2,2);
plot(t, sum(dprimeNext.^2), 'k');
ax = get(gca,'YAxis');
set(ax,'Visible','off')
ylim([m M]);set(a, 'YTick', yticks);

% grid on;
set(gca,'XLim', [t(1) t(end)])

% Create line
annotation(f(3),'line',[0.530357142857143 0.508928571428571],...
    [0.141857142857143 0.0857142857142857]);

% Create line
annotation(f(3),'line',[0.548214285714286 0.526785714285714],...
    [0.141857142857143 0.0857142857142858]);
set(gca, 'Box','off');
set(a1,'Position', [0.1889    0.1135    0.3347    0.8150]);
set(a2,'Position', [0.5400    0.1148    0.3347    0.8150]);
set(gca, 'Box','off');

ah=get(f(3),'Children');
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


f(4) = figure;
plot(t, sum(dprimeNext.^2), 'k');
ax = get(gca,'YAxis');
ylim([m M]);set(a, 'YTick', yticks);

% grid on;
set(gca,'XLim', [t(1) t(end)])

set(gca, 'Box','off');
xlabel('Time [sec]','FontSize',labelsFontSz);
ylabel('Sensitivity Index','FontSize',labelsFontSz);
