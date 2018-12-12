function pcaTrajectoriesCalcDistance(outputPath, generalProperty, imagingData, BehaveData)
% the output path contain the path of the file to be saved and the
% animalname and the date split by char ','
% it can be like this - 'C:\\,output.xlxs,M31,21/1/18'
splitRes = strsplit(outputPath,',');

% analysis
[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
generalProperty.labels2cluster, generalProperty.includeOmissions);

toneTime = generalProperty.ToneTime;
t = linspace(0, generalProperty.Duration, size(imagingData.samples,2)) - toneTime;
t = t(6:end);
mvStartInd=findClosestDouble(t,t(11));
toneTimeind=findClosestDouble(t,0);

excelFileName = strcat(splitRes{1},'\',splitRes{2});

classes = unique(labels);

if isfile(excelFileName)
    [~, ~, excelDataRaw] = xlsread(excelFileName);
else
    [~, ~, excelDataRaw] = xlsread('TemplateExcelForCalcDist.xlsx');
end

excelDataRaw{end + 1, 1} = splitRes{3};
excelDataRaw{end, 2} = splitRes{4};

for ci = 0:length(classes)
    
    if (ci == 0)
        inds = examinedInds;
        [~, currentLabelCol] = find(strcmp(excelDataRaw, 'All labels'));
    else
        inds = labels==classes(ci); 
        [~, currentLabelCol] = find(strcmp(excelDataRaw, labelsLUT{ci}));
    end
    
    current_embedding = calcDistPcaTrajCreator(inds, imagingData, generalProperty);
    
    [excelDataRaw{end, currentLabelCol}, excelDataRaw{end, currentLabelCol + 1}, excelDataRaw{end, currentLabelCol + 2}, excelDataRaw{end, currentLabelCol + 3}] = calcDistCreateVectores(current_embedding, mvStartInd, (size(current_embedding, 1) - 1));
    currentLabelCol = currentLabelCol + 4;
    [excelDataRaw{end, currentLabelCol}, excelDataRaw{end, currentLabelCol + 1}, excelDataRaw{end, currentLabelCol + 2}, excelDataRaw{end, currentLabelCol + 3}] = calcDistCreateVectores(current_embedding, mvStartInd, (toneTimeind - 1));
    currentLabelCol = currentLabelCol + 4;
    [excelDataRaw{end, currentLabelCol}, excelDataRaw{end, currentLabelCol + 1}, excelDataRaw{end, currentLabelCol + 2}, excelDataRaw{end, currentLabelCol + 3}] = calcDistCreateVectores(current_embedding, toneTimeind, (size(current_embedding, 1) - 1));
    current_embedding = [];
    inds = [];
end

xlswrite(excelFileName,excelDataRaw);
end
                    