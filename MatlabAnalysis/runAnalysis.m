function runAnalysis(outputPath, xmlfile, BdaTpaList, analysisName)
% mkNewFolder(outputPath);

generalProperty = Experiment(xmlfile);

if isempty(generalProperty.Neurons2keep)
    generalProperty.Neurons2keep = getAllExperimentNeurons(BdaTpaList(1).TPA);
end

[imagingData, BehaveData] = loadData(BdaTpaList, generalProperty);
analysis(analysisName, outputPath, generalProperty, imagingData, BehaveData);

close all;

end