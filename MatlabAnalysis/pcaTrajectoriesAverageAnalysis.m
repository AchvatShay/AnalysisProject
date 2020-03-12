function pcaTrajectoriesAverageAnalysis(outputPath, generalProperty, analysisRes, BehaveData)

[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
    generalProperty.labels2cluster, generalProperty.includeOmissions);
% [prevcurlabs, prevCurrLUT] = getPrevCurrLabels(labels, labelsLUT);


duration = generalProperty.Duration;





for l=1:length(analysisRes)
    classes = unique(labels);
    trajData = analysisRes(l).pcaTrajres.projeff;
    meanVals = zeros(size(trajData,1), size(trajData,2), length(classes));
    eVals = zeros(size(trajData,1), size(trajData,2), length(classes));
    varVals = zeros(size(trajData,1), size(trajData,2), length(classes));
    for k=1:length(classes)
        for d = 1:size(trajData,1)
            meanVals(d, :, k) = mean(permute(trajData(d,:,labels==classes(k)),[2 3 1]),2);
            eVals(d, :, k) = mean(std(permute(trajData(d,:,labels==classes(k)),[2 3 1]),0,2),3);
            varVals(d, :, k) = mean(var(permute(trajData(d,:,labels==classes(k)),[2 3 1]),0,2),3);
        end
    end
    
    trajData=trajData(:,:,2:end);
    labels=labels(1:end-1);
      meanValsNext = zeros(size(trajData,1), size(trajData,2), length(classes));
    varValsNext = zeros(size(trajData,1), size(trajData,2), length(classes));
  
    for k=1:length(classes)
        for d = 1:size(trajData,1)
            meanValsNext(d, :, k) = mean(permute(trajData(d,:,labels==classes(k)),[2 3 1]),2);
            varValsNext(d, :, k) = mean(var(permute(trajData(d,:,labels==classes(k)),[2 3 1]),0,2),3);
        end
    end



dprime = (meanVals(:,:,1)-meanVals(:,:,2))./sqrt(0.5*(varVals(:,:,1)+varVals(:,:,2)));
dprimeNext = (meanValsNext(:,:,1)-meanValsNext(:,:,2))./sqrt(0.5*(varValsNext(:,:,1)+varValsNext(:,:,2)));

finalNum(:,l) = sum(dprime.^2);

end
f(2)=figure;plot(t, sum(dprime.^2), 'k');xlabel('Time [sec]', 'FontSize', labelsFontSz);

   
