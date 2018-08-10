function runAnalysis(outputPath, xmlfile, BdaTpaList, analysisName)
% mkNewFolder(outputPath);

generalProperty = Experiment(xmlfile);
[imagingData, BehaveData] = loadData(BdaTpaList, generalProperty);
analysis(analysisName, outputPath, generalProperty, imagingData, BehaveData);

end