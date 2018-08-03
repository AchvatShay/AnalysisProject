function runAnalysis(outputPath, xmlfile, BdaTpaList, analysisName)
    mkNewFolder(outputPath);

    generalProperty = Experiment(xmlfile);
    [imagingData, BehaveData] = loadData(BdaTpaList, generalProperty);
    for k = 1:length(analysisName)
    analysis(analysisName{k}, outputPath, generalProperty, imagingData, BehaveData);
    end
end