function runAverageAnalysis(outputPath, generalProperty, MatList, analysisName, specificParams)

for file_i = 1:length(MatList)
    analysisRes(file_i) = load(MatList{file_i});
end

feval([analysisName 'AverageAnalysis'], outputPath, generalProperty, analysisRes, specificParams); 

end