function svmAccuracyConditionalAverageAnalysis(outputPath, generalProperty, analysisRes, BehaveData)
[labels, ~, eventsStr] = getLabels4clusteringFromEventslist(BehaveData, ...
    generalProperty.labels2cluster, generalProperty.includeOmissions);
% [prevcurlabs, prevCurrLUT] = getPrevCurrLabels(labels, labelsLUT);
eventsStr = [eventsStr '_contitional'];

labelsFontSz = generalProperty.visualization_labelsFontSize;
toneTime = generalProperty.ToneTime;
xlimmin = generalProperty.visualization_startTime2plot-toneTime;
tmid = analysisRes(1).tmid - toneTime;
foldsnum = generalProperty.foldsNum;
islin = generalProperty.linearSVN;

foldstr = ['folds' num2str(foldsnum)];
if islin
    linstr = 'lin';
else
    linstr = 'Rbf';
end

eventsStr1 = [eventsStr '_contitional_on_success'];

eventsStr2 = [eventsStr '_contitional_on_fail'];

allAccTot_cond_suc = collectAcc({analysisRes(1,:).tmid},[analysisRes(1,:).accSVM], [analysisRes(1,:).trialsNum], [analysisRes(1,:).chanceLevel]);

plotAccRes(allAccTot_cond_suc.tmid-toneTime, allAccTot_cond_suc, [], allAccTot_cond_suc.chanceLevel, [], [], [], 0);
mysave(gcf, fullfile(outputPath,[ 'AverageAnalysis_accuracy' foldstr linstr eventsStr1]));
allAccTot_cond_sucSEM = allAccTot_cond_suc;
allAccTot_cond_sucSEM.raw.std=allAccTot_cond_sucSEM.raw.std/sqrt(length(analysisRes));
plotAccRes(allAccTot_cond_sucSEM.tmid-toneTime, allAccTot_cond_sucSEM, [], allAccTot_cond_sucSEM.chanceLevel, [], [], [], 0);
mysave(gcf, fullfile(outputPath,[ 'AverageAnalysis_accuracy' foldstr linstr eventsStr1 '_SEM']));


