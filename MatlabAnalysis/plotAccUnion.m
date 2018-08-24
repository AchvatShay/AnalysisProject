function plotAccUnion(tmid, accSVMlinConseq, accSVMlin, accSVMlinPrev, labs, t, toneTime, labelsFontSz)
accSVMlinUnion.raw.mean = [transpose(accSVMlinConseq.raw.mean(:)) nan(1,5) transpose(accSVMlin.raw.mean(:))  nan(1,5) transpose(accSVMlinPrev.raw.mean(:))];
accSVMlinUnion.raw.std = [transpose(accSVMlinConseq.raw.std(:)) nan(1,5) transpose(accSVMlin.raw.std(:))  nan(1,5) transpose(accSVMlinPrev.raw.std(:)) ];
% accSVMlinUnion.pca.mean = [accSVMlinConseq.pca.mean accSVMlin.pca.mean accSVMlinPrev.pca.mean ];
% accSVMlinUnion.pca.std = [accSVMlinConseq.pca.std accSVMlin.pca.std accSVMlinPrev.pca.std ];

m = 0.9*min(accSVMlinUnion.raw.mean-accSVMlinUnion.raw.std);
M = 1.1*max(accSVMlinUnion.raw.mean+accSVMlinUnion.raw.std);



f=figure('Color',[1 1 1]);
a1 = subplot(1,3,1);
shadedErrorBar(-fliplr(tmid),accSVMlinConseq.raw.mean,accSVMlinConseq.raw.std,'lineprops',{'-k'});
ylabel('Accuracy','FontSize',labelsFontSz);hold all;
    b=hist(labs(1:end-1),0:1);
    priorLabs=max(b./sum(b));
    
    ylim([m M]);
    plot(-fliplr(tmid), ones(size(tmid))*priorLabs, '--k');
    set(gca,'XLim', [-tmid(end),0]);
    d=get(a1,'XAxis');
set(d,'FontSize',labelsFontSz);
   d=get(a1,'YAxis');
set(d,'FontSize',labelsFontSz);

a2=subplot(1,3,2);
  
plotAccRes(tmid, accSVMlin, [],labs(1:end-1), [], [], t, toneTime, false,labelsFontSz);
ylabel('');xlabel('');
d=get(a2,'XAxis');
set(d,'FontSize',labelsFontSz);
% set(d,'Visible','off');
ax = get(gca,'YAxis');
set(ax,'Visible','off');ylim([m M]);
fh=get(gca,'Children');
set(fh(1),'YData', [m M])


a3 = subplot(1,3,3);
 shadedErrorBar(tmid,accSVMlinPrev.raw.mean,accSVMlinPrev.raw.std,'lineprops',{'-k'});
ax = get(gca,'YAxis');
set(ax,'Visible','off')
ylim([m M]);
hold all;

    plot(tmid, ones(size(tmid))*priorLabs, '--k');

set(gca,'XLim', [tmid(1) tmid(end)])

d=get(a3,'XAxis');
set(d,'FontSize',labelsFontSz);

annotation(f,'line',[0.408928571428571 0.378571428571428],...
    [0.138095238095238 0.0857142857142859]);

% Create line
annotation(f,'line',[0.424999999999999 0.394642857142856],...
    [0.138095238095239 0.0857142857142855]);

% Create line
annotation(f,'line',[0.657142857142856 0.626785714285713],...
    [0.135714285714287 0.0833333333333336]);

% Create line
annotation(f,'line',[0.641071428571428 0.610714285714285],...
    [0.135714285714287 0.0833333333333334]);

set(a1,'Position', [0.1818    0.11    0.2134    0.7875]);
set(a3,'Position', [0.6434    0.11    0.2134    0.7875]);





