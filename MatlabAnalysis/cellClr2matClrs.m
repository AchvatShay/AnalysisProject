function [clrs, clrsprevCurr] = cellClr2matClrs(labels2clusterClrs, prevcurrlabels2clusterClrs)

for clr_i = 1:length(labels2clusterClrs)
 clrs(clr_i, :) =  reshape(cell2mat(labels2clusterClrs{clr_i}), 3 ,[])';
end
clrsprevCurr=[];
for clr_i = 1:length(prevcurrlabels2clusterClrs)
 clrsprevCurr = cat(1, clrsprevCurr, reshape(cell2mat(prevcurrlabels2clusterClrs{clr_i}), 3 ,[])');
end
