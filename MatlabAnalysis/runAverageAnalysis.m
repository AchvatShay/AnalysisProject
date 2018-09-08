function runAverageAnalysis(outputPath, xmlfile, BdaTpaList, MatList, analysisName)

generalProperty = Experiment(xmlfile);

[~, BehaveData] = loadData(BdaTpaList, generalProperty);

for file_i = 1:length(MatList)
    analysisRes(file_i) = load(MatList{file_i});
end

feval([analysisName 'AverageAnalysis'], outputPath, generalProperty, analysisRes, BehaveData); 

end