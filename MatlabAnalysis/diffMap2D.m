function diffMap2D(outputPath, generalProperty, imagingData, BehaveData)

% visualize
switch lower(generalProperty.PelletPertubation)
    case 'none'
        % requested labels
        [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
        generalProperty.labels2cluster, generalProperty.includeOmissions);
        [prevcurlabs, prevCurrLUT] = getPrevCurrLabels(labels, labelsLUT);

        % analysis
        X = imagingData.samples(:, :, examinedInds);
        if exist(fullfile(outputPath, ['diff_map_res' eventsStr '.mat']), 'file')
            load(fullfile(outputPath, ['diff_map_res' eventsStr '.mat']));
        else
            [resDiffMap, runningOrder] = diffMapAnalysis(X, generalProperty.analysis_pca_thEffDim);
            embedding = resDiffMap.embedding{runningOrder==3}(:,1:2);
            foldsNum = generalProperty.foldsNum;
        ACC2D = svmClassifyAndRand(embedding, labels, labels, foldsNum, '', 1, 0);

        ACC2Dprevcur = svmClassifyAndRand(embedding(2:end, :), prevcurlabs, prevcurlabs, foldsNum, '', 1, 0);    
        save(fullfile(outputPath, ['diff_map_res' eventsStr '.mat']), 'resDiffMap', 'ACC2D', 'runningOrder');
        end

        embedding_order_3 = resDiffMap.embedding{runningOrder==3};
        
        visualize2Dembedding(examinedInds, labels, prevcurlabs, prevCurrLUT, labelsLUT, generalProperty, ACC2D, eventsStr, embedding_order_3, outputPath, 'diffMap')
    case 'taste'
        [labelsTaste, examinedIndsTaste, eventsStrTaste, labelsLUTTaste] = getLabels4clusteringFromEventslist(BehaveData, ...
            generalProperty.tastesLabels, generalProperty.includeOmissions);
        % mark failures - because then we do not know the tastes
        %labelsTaste(labels == find(strcmp(labelsLUT, 'failure'))) = max(labelsTaste)+1;
       
        labelsLUTTaste{end+1} = 'failure';
        labelsFontSz = generalProperty.visualization_labelsFontSize;
        legendLoc = generalProperty.visualization_legendLocation;        
        
        for clr_i = 1:length(generalProperty.tastesColors)
         clrs(clr_i, :) =  reshape(cell2mat(generalProperty.tastesColors{clr_i}), 3 ,[])';
        end
        
        clrs(end+1, :) = [1 0 0];
        
         % analysis
        X = imagingData.samples(:, :, examinedIndsTaste);
        if exist(fullfile(outputPath, ['diff_map_res' eventsStrTaste '.mat']), 'file')
            load(fullfile(outputPath, ['diff_map_res' eventsStrTaste '.mat']));
        else
            [resDiffMap, runningOrder] = diffMapAnalysis(X, generalProperty.analysis_pca_thEffDim);
        save(fullfile(outputPath, ['diff_map_res' eventsStrTaste '.mat']), 'resDiffMap', 'runningOrder');
        end

        embedding_order_3 = resDiffMap.embedding{runningOrder==3};
           
        plot2Dembedding(examinedIndsTaste, outputPath, eventsStrTaste, labelsLUTTaste, labelsTaste,embedding_order_3, clrs, 'diffMap', legendLoc, labelsFontSz)
          
    case 'ommisions'
        error('under constraction');
    otherwise
        error('Unfamiliar pellet pertrubation');
end

