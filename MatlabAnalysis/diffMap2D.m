function diffMap2D(outputPath, generalProperty, imagingData, BehaveData)
% requested labels
[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
generalProperty.labels2cluster, generalProperty.includeOmissions);
labelsNoDrops = labels(examinedInds);
[prevcurlabs, prevCurrLUT] = getPrevCurrLabels(labelsNoDrops, labelsLUT);

% analysis
X = imagingData.samples(:, :, examinedInds);
if exist(fullfile(outputPath, ['diff_map_res' eventsStr '.mat']), 'file')
    load(fullfile(outputPath, ['diff_map_res' eventsStr '.mat']));
else
    [resDiffMap, runningOrder] = diffMapAnalysis(X, generalProperty.analysis_pca_thEffDim);
    embedding = resDiffMap.embedding{runningOrder==3}(:,1:2);
    foldsNum = generalProperty.foldsNum;
ACC2D = svmClassifyAndRand(embedding, labelsNoDrops, labelsNoDrops, foldsNum, '', 1, 0);
        
ACC2Dprevcur = svmClassifyAndRand(embedding(2:end, :), prevcurlabs, prevcurlabs, foldsNum, '', 1, 0);    
save(fullfile(outputPath, ['diff_map_res' eventsStr '.mat']), 'resDiffMap', 'ACC2D', 'runningOrder');
end


% visualize
visualize2Dembedding(examinedInds, labelsNoDrops, prevcurlabs, prevCurrLUT, labelsLUT, generalProperty, ACC2D, eventsStr, resDiffMap.embedding{runningOrder==3}, outputPath, 'diffMap')
% visualize
switch lower(generalProperty.PelletPertubation)
    case 'none'
        visualize2Dembedding(examinedInds, labelsNoDrops, prevcurlabs, prevCurrLUT, labelsLUT, generalProperty, ACC2D, eventsStr, resDiffMap.embedding{runningOrder==3}, outputPath, 'diffMap')
    case 'taste'
        [labelsTaste, examinedIndsTaste, eventsStrTaste, labelsLUTTaste] = getLabels4clusteringFromEventslist(BehaveData, ...
            generalProperty.tastesLabels, generalProperty.includeOmissions);
        % mark failures - because then we do not know the tastes
        labelsTaste(labels == find(strcmp(labelsLUT, 'failure'))) = max(labelsTaste)+1;
        labelsLUTTaste{end+1} = 'failure';
        labelsFontSz = generalProperty.visualization_labelsFontSize;
        legendLoc = generalProperty.visualization_legendLocation;        
        clrs = getColors(generalProperty.tastesColors);
        clrs(end+1, :) = [1 0 0];
        plot2Dembedding(examinedIndsTaste, outputPath, eventsStrTaste, labelsLUTTaste, labelsTaste,resDiffMap.embedding{runningOrder==3}, clrs, 'diffMap', legendLoc, labelsFontSz)
        
        
    case 'ommisions'
        error('under constraction');
    otherwise
        error('Unfamiliar pellet pertrubation');
end

