function [res] = runAnalysis(outputPath, xmlfile, BdaTpaList)
    mkNewFolder(outputPath);

    generalProperty = Experiment(xmlfile);
    [imagingData, BehaveData] = loadData(BdaTpaList, generalProperty);
    analysis('Pca2D', outputPath, generalProperty, imagingData, BehaveData);
    
    res = 1;
end