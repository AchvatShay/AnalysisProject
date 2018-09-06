function runAnalysis(outputPath, xmlfile, BdaTpaList, analysisName)
% mkNewFolder(outputPath);

generalProperty = Experiment(xmlfile);

[imagingData, BehaveData] = loadData(BdaTpaList, generalProperty);
feval(analysisName,outputPath, generalProperty, imagingData, BehaveData); 
end