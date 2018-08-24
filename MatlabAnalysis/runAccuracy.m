function runAccuracy(outputPath, xmlfile, BdaTpaList, eventsList)
% mkNewFolder(outputPath);
generalProperty = Experiment(xmlfile);


[imagingData, BehaveData] = loadData(BdaTpaList, generalProperty);
accuracyAnalysis(outputPath, generalProperty, imagingData, BehaveData, eventsList);
