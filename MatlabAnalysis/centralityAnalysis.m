function centralityAnalysis(outputPath, generalProperty, imagingData, BehaveData)
    fixCorrValues = imagingData.samples + 1;
    
    [cent_weighted, cent_notweighted] = calc_centrality_per_time_and_trial(fixCorrValues, generalProperty.roiLabels);
    
    plotCentralityResults(cent_notweighted, generalProperty.RoiSplit_d1, [outputPath, '\noW\']);
    plotCentralityResults(cent_weighted, generalProperty.RoiSplit_d1, [outputPath, 'W']);
end