function svmAccuracyConditional(outputPath, generalProperty, imagingData, BehaveData)
% mkNewFolder(outputPath);




[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(...
BehaveData, generalProperty.prevcurrlabels2cluster, generalProperty.includeOmissions);
eventsStr = [eventsStr '_contitional'];
if length(examinedInds) ~= size(imagingData.samples,3)
    imagingData.samples=imagingData.samples(:,:,examinedInds);
end

successtrials = find(labels==1);
failtrials = find(labels==2);

successtrials=setdiff(successtrials,1);
failtrials=setdiff(failtrials,1);

prev_suc = successtrials-1;
prev_fail = failtrials-1;

eventsStr1 = [eventsStr '_contitional_on_success'];
accuracyAnalysis(BehaveData, outputPath, generalProperty, imagingData, labels(prev_suc), successtrials, eventsStr1, labelsLUT, false);

eventsStr1 = [eventsStr '_contitional_on_fail'];
accuracyAnalysis(BehaveData, outputPath, generalProperty, imagingData, labels(prev_fail), failtrials, eventsStr1, labelsLUT, false);

