function svmAccuracy(outputPath, generalProperty, imagingData, BehaveData)
% mkNewFolder(outputPath);



[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(...
BehaveData, generalProperty.labels2cluster, generalProperty.includeOmissions);
accuracyAnalysis(BehaveData, outputPath, generalProperty, imagingData, labels, examinedInds, eventsStr, labelsLUT, true);

[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(...
BehaveData, generalProperty.prevcurrlabels2cluster, generalProperty.includeOmissions);
[prevcurlabs, prevCurrLUT] = getPrevCurrLabels(labels, labelsLUT);
eventsStr = [eventsStr 'PrevCurr'];
accuracyAnalysis(BehaveData, outputPath, generalProperty, imagingData, prevcurlabs, examinedInds(2:end), eventsStr, {prevCurrLUT.name}, false);

