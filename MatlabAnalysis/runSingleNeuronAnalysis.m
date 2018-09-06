function runSingleNeuronAnalysis(outputPath, xmlfile, BdaTpaList)
% mkNewFolder(outputPath);
generalProperty = Experiment(xmlfile);


[imagingData, BehaveData] = loadData(BdaTpaList, generalProperty);
SingleNeuronAnalysis(outputPath, generalProperty, imagingData, BehaveData, eventsList);
