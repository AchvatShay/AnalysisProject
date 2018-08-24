function [a1,a2]=plotAccUnionCurrNext(tmid, accSVMlin, accSVMlinPrev, labs, t, toneTime, labelsFontSz, xlimmin)
accSVMlinUnion.raw.mean = [ transpose(accSVMlin.raw.mean(:))  nan(1,5) transpose(accSVMlinPrev.raw.mean(:))];
accSVMlinUnion.raw.std = [ transpose(accSVMlin.raw.std(:))  nan(1,5) transpose(accSVMlinPrev.raw.std(:)) ];
% accSVMlinUnion.pca.mean = [accSVMlinConseq.pca.mean accSVMlin.pca.mean accSVMlinPrev.pca.mean ];
% accSVMlinUnion.pca.std = [accSVMlinConseq.pca.std accSVMlin.pca.std accSVMlinPrev.pca.std ];
b=hist(labs(1:end-1),0:1);
    priorLabs=max(b./sum(b));
    
m = 0.9*min([accSVMlinUnion.raw.mean-accSVMlinUnion.raw.std min(priorLabs)]);
M = 1.1*max([accSVMlinUnion.raw.mean+accSVMlinUnion.raw.std max(priorLabs)]);




f=figure('Color',[1 1 1]);
a1 = subplot(1,2,1);
plotAccRes(tmid, accSVMlin, [],labs(1:end-1), [], [], t, toneTime, false,labelsFontSz);
ylim([m M]);xlim([xlimmin, tmid(end)]);
fh=get(gca,'Children');
set(fh(1),'YData', [m M])


a2 = subplot(1,2,2);
 shadedErrorBar(tmid,accSVMlinPrev.raw.mean,accSVMlinPrev.raw.std,'lineprops',{'-k'});
ax = get(gca,'YAxis');
set(ax,'Visible','off')
ylim([m M]);xlim([xlimmin, tmid(end)]);
hold all;
  plot(tmid, ones(size(tmid))*priorLabs, '--k');

set(gca,'XLim', [tmid(1) tmid(end)])

% Create line
annotation(f,'line',[0.530357142857143 0.508928571428571],...
    [0.141857142857143 0.0857142857142857]);

% Create line
annotation(f,'line',[0.548214285714286 0.526785714285714],...
    [0.141857142857143 0.0857142857142858]);

set(a1,'Position', [0.1889    0.1135    0.3347    0.8110]);
set(a2,'Position', [0.5400    0.1148    0.3347    0.8150]);
d=get(a1,'XAxis');
d1=get(d,'Label');
set(d1,'Position',[10.8824    0.2391   -1.0000], 'Visible','off');
set(d,'FontSize',labelsFontSz);
d=get(a1,'YAxis');
set(d,'FontSize',labelsFontSz);
d=get(a2,'XAxis');
set(d,'FontSize',labelsFontSz);






% accSVMlin.raw.C = getConfidenceInterval(accSVMlin.raw.mean, accSVMlin.raw.std, accSVMlin.raw.accv
% m, s, n, perc) 

m = 0.9*min([accSVMlin.raw.C(1,:) min(priorLabs)]);
M = 1.1*max([accSVMlin.raw.C(2,:) max(priorLabs)]);



 b=hist(labs(1:end-1),0:1);
    priorLabs=max(b./sum(b));
  

f=figure('Color',[1 1 1]);
a1 = subplot(1,2,1);
shadedErrorBar(tmid,accSVMlin.raw.mean,accSVMlin.raw.mean-accSVMlin.raw.C(1,:),'lineprops',{'-k'});
hold all;
   plot(tmid, ones(size(tmid))*priorLabs, '--k');
set(gca, 'Box','off');
ylim([m M]);xlim([xlimmin, tmid(end)]);
placeToneTime(toneTime, 2);

ylabel('Accuracy','FontSize', labelsFontSz);
fh=get(gca,'Children');
% set(fh(1),'YData', [m M])


a2 = subplot(1,2,2);
shadedErrorBar(tmid,accSVMlinPrev.raw.mean,accSVMlinPrev.raw.mean-accSVMlinPrev.raw.C(1,:),'lineprops',{'-k'});

ax = get(gca,'YAxis');
set(ax,'Visible','off')
ylim([m M]);
hold all;
   plot(tmid, ones(size(tmid))*priorLabs, '--k');
set(gca, 'Box','off');
xlim([xlimmin, tmid(end)]);
% Create line
annotation(f,'line',[0.530357142857143 0.508928571428571],...
    [0.141857142857143 0.0857142857142857]);

% Create line
annotation(f,'line',[0.548214285714286 0.526785714285714],...
    [0.141857142857143 0.0857142857142858]);

set(a1,'Position', [0.1889    0.1135    0.3347    0.8110]);
set(a2,'Position', [0.5400    0.1148    0.3347    0.8150]);
d=get(a1,'XAxis');
d1=get(d,'Label');
set(d1,'Position',[10.8824    0.2391   -1.0000], 'Visible','off');
set(d,'FontSize',labelsFontSz);
d=get(a1,'YAxis');
set(d,'FontSize',labelsFontSz);
d=get(a2,'XAxis');
set(d,'FontSize',labelsFontSz);