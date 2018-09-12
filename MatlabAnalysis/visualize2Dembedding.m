function visualize2Dembedding(examinedInds, labels, prevcurlabs, prevCurrLUT, labelsLUT, generalProperty, ACC2D, eventsStr, embedding, outputPath, Method)


fid = fopen(fullfile(outputPath, [Method 'accuracy2D.txt']), 'w');
fprintf(fid, 'Accuracy of %s :\t\tmean = %f std = %f\n', Method, ACC2D.mean, ACC2D.std);
fprintf(fid, 'Accuracy of %s :\t\tmean = %f std = %f\n', Method, ACC2D.mean, ACC2D.std);
fclose(fid);
[clrs, clrsprevCurr] = cellClr2matClrs(generalProperty.labels2clusterClrs, generalProperty.prevcurrlabels2clusterClrs);

% for clr_i = 1:length(generalProperty.labels2clusterClrs)
%  clrs(clr_i, :) =  reshape(cell2mat(generalProperty.labels2clusterClrs{clr_i}), 3 ,[])';
% end
% clrsprevCurr=[];
% for clr_i = 1:length(generalProperty.prevcurrlabels2clusterClrs)
%  clrsprevCurr = cat(1, clrsprevCurr, reshape(cell2mat(generalProperty.prevcurrlabels2clusterClrs{clr_i}), 3 ,[])');
% end

labelsFontSz = generalProperty.visualization_labelsFontSize;
legendLoc = generalProperty.visualization_legendLocation;

plot2Dembedding(outputPath, eventsStr, labelsLUT, labels,embedding, clrs, Method, legendLoc, labelsFontSz)
if length(unique(labels)) == 2
    plot2Dembedding(examinedInds, outputPath, [eventsStr 'PrevCurr'], {prevCurrLUT.name}, prevcurlabs, embedding(2:end, :), clrsprevCurr, Method, legendLoc, labelsFontSz)
end
end

function plot2Dembedding(examinedInds, outputPath, eventsStr, labelsLUT, labels,embedding, clrs, Method, legendLoc, labelsFontSz)


classes = unique(labels);
figure;
for ci = 1:length(classes)
    scatter(embedding(labels==classes(ci),1)  ,embedding(labels==classes(ci),2),...
        'o', 'MarkerFaceColor', clrs(ci, :), 'MarkerEdgeColor', clrs(ci, :));
    hold all;
end
xlabel('\psi_1', 'FontSize', labelsFontSz), ylabel('\psi_2', 'FontSize', labelsFontSz);
l=legend(labelsLUT, 'Location',legendLoc);

set(gca, 'Box','off');
set(l, 'FontSize',labelsFontSz);
a=get(gcf,'Children');
for ai=1:length(a)
    if strcmp(a(ai).Type, 'Axes')
        setAxisFontSz(a(ai), labelsFontSz);
    end
end
mysave(gcf, fullfile(outputPath, [ Method '2D' eventsStr]));


strs = cellstr(num2str(examinedInds));
text(embedding(:,1),embedding(:,2),strs,'VerticalAlignment','bottom',...
    'HorizontalAlignment','right');
mysave(gcf, fullfile(outputPath, [ Method '2D' eventsStr 'withNumbers']));
end

%
%
% switch generalProperty.PelletPertubation
%     case 'None'
%         plotSF2D([],  embedding(:,1:2), BehaveData.failure(tryinginds), generalProperty.visualization_labelsFontSize, generalProperty.visualization_legendLocation);
%         mysave(gcf, fullfile(outputPath, [ Method '2Dsucfail']));
%
%
%     case 'Ommisions'
%         if ~isfield(BehaveData, 'nopellet')
%             warning('ommisions were not marked in BDA file!');
%             plotSF2D([],  embedding(:,1:2), BehaveData.failure(tryinginds), generalProperty.visualization_labelsFontSize, generalProperty.visualization_legendLocation);
%         else
%             labsOmissions(BehaveData.nopellet==1) = 2;
%             figure;a=gca;
%             plot(a, embedding(BehaveData.nopellet(tryinginds)==1,1)  ,embedding(BehaveData.nopellet(tryinginds)==1,2),'ko', 'MarkerFaceColor','k');
%             hold all;
%             plotSF2D(a, embedding(BehaveData.nopellet(tryinginds)==0,1:2), BehaveData.failure(BehaveData.nopellet(tryinginds)==0), labelsFontSz);
%             plotSF2D(a, embedding, BehaveData.failure(tryinginds), generalProperty.visualization_labelsFontSize);
%             l=legend('Omission','Failure','Success', 'Location',generalProperty.visualization_legendLocation);
%             set(l, 'FontSize',generalProperty.visualization_labelsFontSize);
%         end
%         mysave(gcf, fullfile(outputPath, [ Method '2Dsucfail']));
%
%     case 'Taste'
%         plotSF2D([],  embedding(:,1:2), BehaveData.failure(tryinginds), generalProperty.visualization_labelsFontSize, generalProperty.visualization_legendLocation);
%         mysave(gcf, fullfile(outputPath, [ Method '2Dsucfail']));
%         f=plot2Dtasting(BehaveData, tryinginds, embedding(:,1:2), generalProperty.visualization_labelsFontSize);
%         if ~isempty(f)
%             mysave(f(1), fullfile(outputPath, [ Method '2Dtaste']));
%             mysave(f(2), fullfile(outputPath, [ Method '2Dtastesucfail']));
%
%         end
%
% end
