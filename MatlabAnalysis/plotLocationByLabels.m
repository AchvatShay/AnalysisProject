function [estimateX, estimateY, cent] = plotLocationByLabels(locations, labels, stripesNum)



figure;
hold all;M = max(512, max(max(max(locations{1}))));
for nrni = 1:length(labels)
    if labels(nrni)
        clr = 'b';
    else
        clr = 'k';
    end
    
    x = locations{nrni}(:, 1,1);
    y = locations{nrni}(:, 2,1);
    BW = poly2mask(x,y,M,M);
    [x1,y1]=find(BW==1);
    plot(x1, y1, ['.' clr]);
    cent(nrni, 1) = mean(x1);
    cent(nrni, 2) = mean(y1);
end
title('Blue - Significant; Black - Rest');
xlabel('X Location');ylabel('Y Location');
axis tight



xlims = get(gca, 'XLim');
ylims = get(gca, 'YLim');

xborders = linspace(xlims(1), xlims(2), stripesNum+1);
yborders = linspace(ylims(1), ylims(2), stripesNum+1);


for si = 1:length(xborders)-1
   sigNumx0(si) = sum(cent(:, 1) >=  xborders(si) & cent(:,1) < xborders(si+1) & labels==0);
   sigNumx1(si) = sum(cent(:, 1) >=  xborders(si) & cent(:,1) < xborders(si+1) & labels==1);
    sigNumy0(si) = sum(cent(:, 2) >=  yborders(si) & cent(:,2) < yborders(si+1) & labels==0);
   sigNumy1(si) = sum(cent(:, 2) >=  yborders(si) & cent(:,2) < yborders(si+1) & labels==1);
end

ratiox = sigNumx0./(sigNumx0+sigNumx1);
ratioy = sigNumy0./(sigNumy0+sigNumy1);

LMx = fitlm(xborders(1:end-1),ratiox);
estimateX.constant = LMx.Coefficients.Estimate(1);
estimateX.slope = LMx.Coefficients.Estimate(2);
estimateX.Rsquare = LMx.Rsquared;
estimateX.pvalue = LMx.coefTest;
estimateX.ratio = ratiox;
LMy = fitlm(yborders(1:end-1),ratioy);
estimateY.constant = LMy.Coefficients.Estimate(1);
estimateY.slope = LMy.Coefficients.Estimate(2);
estimateY.Rsquare = LMy.Rsquared;
estimateY.pvalue = LMy.coefTest;
estimateX.meanRatio = mean(ratiox);
estimateY.meanRatio = mean(ratioy);
estimateX.stdRatio = std(ratiox);
estimateY.stdRatio = std(ratioy);
estimateY.ratio = ratioy;