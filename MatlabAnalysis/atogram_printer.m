function atogram_printer(outputPath, generalProperty, imagingData, BehaveData)
    [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
        generalProperty.labels2cluster, generalProperty.includeOmissions);
    
    classes = unique(labels);
    
    allTrailsIndex = 1:size(imagingData.samples, 3);
    
    examinedIndsResults = getTrialsIndexAccordingToString(generalProperty.trailsToRun, allTrailsIndex);
    
    labels = labels(sum(examinedInds == allTrailsIndex(examinedIndsResults == 1), 2) == 1);
    examinedInds = examinedInds(sum(examinedInds == allTrailsIndex(examinedIndsResults == 1), 2) == 1);
    
    
    atogram_printer_event(outputPath, generalProperty, imagingData, BehaveData, 'All', examinedInds);
    atogram_printer_event(outputPath, generalProperty, imagingData, BehaveData, generalProperty.successLabel, examinedInds(labels==classes(strcmp(labelsLUT, generalProperty.successLabel))));
    atogram_printer_event(outputPath, generalProperty, imagingData, BehaveData, generalProperty.failureLabel, examinedInds(labels==classes(strcmp(labelsLUT, generalProperty.failureLabel))));
end