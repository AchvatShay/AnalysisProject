function runAverageAnalysis(outputPath, xmlfile, BdaTpaList, MatList, analysisName)

generalProperty = Experiment(xmlfile);

[~, BehaveData] = loadData(BdaTpaList, generalProperty);













for file_j = 1:size(MatList,2)

for file_i = 1:size(MatList,1)
    analysisRes(file_i,file_j) = load(MatList{file_i,file_j});
end
end

feval([analysisName 'AverageAnalysis'], outputPath, generalProperty, analysisRes, BehaveData); 

end