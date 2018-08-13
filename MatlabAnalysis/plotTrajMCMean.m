function [p, markers]=plotTrajMCMean(trajData, labels, dim, leg, toneTime, gtime,amtime, labelsFontSz)
if nargin == 2
    dim=2;leg=[];
end
map=colormap('jet');
labels1=labels+1;
labelsR=round(size(map,1)*(labels1)/(max(labels1)));
classes = unique(labels1);
for k=1:length(classes)
    for d = 1:dim
        if size(squeeze(trajData(d,:,labels1==classes(k))),1) == 1
             meanVals(d, :, k) = (squeeze(trajData(d,:,labels1==classes(k))));
        else
    meanVals(d, :, k) = mean(squeeze(trajData(d,:,labels1==classes(k))),2);
        end
    end
end


p = plotTrajMC(meanVals, classes, dim, labelsFontSz);
for k=1:length(classes)
 markers(k,1) = plot3(meanVals(1,1,k), meanVals(2,1,k), meanVals(3,1,k),'ks','MarkerFaceColor','w','MarkerSize',8);
    markers(k,2) = plot3(meanVals(1,toneTime,k), meanVals(2,toneTime,k), meanVals(3,toneTime,k),'ko','MarkerSize',8,'MarkerFaceColor','w');
       if ~isempty(gtime) && ~isnan(gtime(k))
        markers(k,3) = plot3(meanVals(1,gtime(k),k), meanVals(2,gtime(k),k), meanVals(3,gtime(k),k),'Marker','^','MarkerSize',8,...
         'MarkerFaceColor','w');
    end
    if ~isempty(amtime) &&~isnan(amtime(k))
        markers(k,4) = plot3(meanVals(1,amtime(k),k), meanVals(2,amtime(k),k), meanVals(3,amtime(k),k),'Marker','Pentagram','MarkerSize',8,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','w');
    end
   
   
end
    

        
l=legend(leg, 'Location','northeastoutside');
set(l, 'FontSize',labelsFontSz);

a=get(gcf,'Children');
setAxisFontSz(a(end), labelsFontSz);