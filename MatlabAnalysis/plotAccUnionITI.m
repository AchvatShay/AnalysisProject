function plotAccUnionITI(tmid, accSVMlinConseq, accSVMlin, accSVMlinPrev, chanceLevels, toneTime, labelsFontSz)
accSVMlinUnion.raw.mean = [transpose(accSVMlinConseq.raw.mean(:)) nan(1,5) transpose(accSVMlin.raw.mean(:))  nan(1,5) transpose(accSVMlinPrev.raw.mean(:))];
accSVMlinUnion.raw.std = [transpose(accSVMlinConseq.raw.std(:)) nan(1,5) transpose(accSVMlin.raw.std(:))  nan(1,5) transpose(accSVMlinPrev.raw.std(:)) ];
% accSVMlinUnion.pca.mean = [accSVMlinConseq.pca.mean accSVMlin.pca.mean accSVMlinPrev.pca.mean ];
% accSVMlinUnion.pca.std = [accSVMlinConseq.pca.std accSVMlin.pca.std accSVMlinPrev.pca.std ];

m = 0.9*min(accSVMlinUnion.raw.mean-accSVMlinUnion.raw.std);
M = 1.1*max(accSVMlinUnion.raw.mean+accSVMlinUnion.raw.std);


T = [-fliplr(tmid) tmid tmid(end)+tmid];
T1=unique(T);
meanvals = [accSVMlinConseq.raw.mean accSVMlin.raw.mean accSVMlinPrev.raw.mean];
Svals =  [accSVMlinConseq.raw.std accSVMlin.raw.std accSVMlinPrev.raw.std];

for k=1:length(T1)
    ind = find(T==T1(k));
   
    meanvals1(k) = mean(meanvals(ind));
    Svals1(k) = mean(Svals(ind));
end

f=figure('Color',[1 1 1]);
shadedErrorBar(T1,meanvals1,...
    Svals1,'lineprops',{'-k'});


  xlim([T1(1) T1(end)])
    ylim([m M]);
%     set(gca,'XLim', [-tmid(end),-tmid(1)]);
    d=get(gca,'XAxis');
set(d,'FontSize',labelsFontSz);
   d=get(gca,'YAxis');
set(d,'FontSize',labelsFontSz);


    line(get(gca,'XLim'), ones(2,1)*chanceLevels(3),'LineStyle','--','Color','k');
placeToneTime(0, 2);
placeToneTime(tmid(end)-tmid(1), 1);

placeToneTime(-tmid(end)-tmid(1), 1);

xlabel('Time [sec]','FontSize',14);
ylabel('Accuracy','FontSize',14);
% ticks = get(gca,'XTick');
% ticks(ticks>tmid(end)) = ticks(ticks>tmid(end))+ticks(1);
% ticks(ticks<0) = ticks(ticks<0)-ticks(1);
% set(gca,'XTickLabel',ticks);


