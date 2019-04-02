function pcares = Pca2D(outputPath, generalProperty, imagingData, BehaveData)
  
% visualize
switch lower(generalProperty.PelletPertubation)
    case 'none'        
        % requested labels
        [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
        generalProperty.labels2cluster, generalProperty.includeOmissions);
        [prevcurlabs, prevCurrLUT] = getPrevCurrLabels(labels, labelsLUT);

        % analysis
        X = imagingData.samples(:, :, examinedInds);

        if exist(fullfile(outputPath, ['pca_res' eventsStr '.mat']), 'file')
            load(fullfile(outputPath,  ['pca_res' eventsStr '.mat']));
        else
            for k=1:size(X,3)
                alldata(:, k) = reshape(X(:,:,k), size(X,1)*size(X,2),1);
            end

            [pcares.embedding, ~, vals] = pca(alldata);
            pcares.effectiveDim = max(getEffectiveDim(vals, generalProperty.analysis_pca_thEffDim), 3);
            pcares.eigs = vals;
            embedding = pcares.embedding(:,1:2);
            foldsNum = generalProperty.foldsNum;
            ACC2D = svmClassifyAndRand(embedding, labels, labels, foldsNum, '', 1, 0);
            ACC2Dprevcur = svmClassifyAndRand(embedding(2:end, :), prevcurlabs, prevcurlabs, foldsNum, '', 1, 0);
            save(fullfile(outputPath,  ['pca_res' eventsStr '.mat']), 'pcares', 'ACC2D', 'ACC2Dprevcur');
        end
        
        visualize2Dembedding(examinedInds, labels, prevcurlabs, prevCurrLUT, labelsLUT, generalProperty, ACC2D, eventsStr, pcares.embedding(:, 1:2), outputPath, 'pca')
    case 'taste'
        [labelsTaste, examinedIndsTaste, eventsStrTaste, labelsLUTTaste] = getLabels4clusteringFromEventslist(BehaveData, ...
            generalProperty.tastesLabels, generalProperty.includeOmissions);
        % mark failures - because then we do not know the tastes
%         labelsTaste(labels == find(strcmp(labelsLUT, 'failure'))) = max(labelsTaste)+1;
        
        labelsLUTTaste{end+1} = 'failure';
        labelsFontSz = generalProperty.visualization_labelsFontSize;
        legendLoc = generalProperty.visualization_legendLocation;        
        
        for clr_i = 1:length(generalProperty.tastesColors)
         clrs(clr_i, :) =  reshape(cell2mat(generalProperty.tastesColors{clr_i}), 3 ,[])';
        end
        
        
        clrs(end+1, :) = [1 0 0];
        
          % analysis
        X = imagingData.samples(:, :, examinedIndsTaste);

        if exist(fullfile(outputPath, ['pca_res' eventsStrTaste '.mat']), 'file')
            load(fullfile(outputPath,  ['pca_res' eventsStrTaste '.mat']));
        else
            for k=1:size(X,3)
                alldata(:, k) = reshape(X(:,:,k), size(X,1)*size(X,2),1);
            end

            [pcares.embedding, ~, vals] = pca(alldata);
            pcares.effectiveDim = max(getEffectiveDim(vals, generalProperty.analysis_pca_thEffDim), 3);
            pcares.eigs = vals;
           
            save(fullfile(outputPath,  ['pca_res' eventsStrTaste '.mat']), 'pcares');
        end    
        
        plot2Dembedding(examinedIndsTaste, outputPath, eventsStrTaste, labelsLUTTaste, labelsTaste,pcares.embedding(:, 1:2), clrs, 'pca', legendLoc, labelsFontSz)
        
        
    case 'ommisions'
        error('under constraction');
    otherwise
        error('Unfamiliar pellet pertrubation');
end

% %% 2D Projections Using PCA Colored by # grabs - all time span (0-12 seconds)
% grabCount = getGrabCounts(eventTimeGrab{l}, findClosestDouble(t, toneTime), findClosestDouble(t, toneTime+2), frameRateRatio{1});
% grabCount1=grabCount(2:end);
%
% if length(unique(grabCount))>1
%     figure;plotEmbeddingWithColors(res.pca.embedding{1}(:,1:2), grabCount,'', 30, 14)
%     mysave(gcf, fullfile(outputPath, 'pca2Dgrabcount'));
%
% end
% if ~isempty(labelsAnimal)
%     %% 2D Projections Using PCA - Colors by Protocol all time span (0-12 seconds)
%     [clrsProt, legProt] = plotProtocolEmbedding(res.pca.embedding{1}, labelsAnimal{l}, 'PCA Along Trials', labelsFontSz);
%     mysave(gcf, fullfile(outputPath, 'pca2Dprotocol'));
%
%     %     %% 2D Projections Using PCA - Colors by protocol Before Movement (0->tone)
%     %     plotProtocolEmbedding(resBefore.pca.embedding{1}, labelsAnimal{l}, 'PCA Along Trials', labelsFontSz);
%     % %% 2D Projections Using PCA - Colors by protocol Movement (tone->tone+2secs)
%     %     plotProtocolEmbedding(resMovement.pca.embedding{1}, labelsAnimal{l}, 'PCA Along Trials', labelsFontSz);
%     % %% 2D Projections Using PCA - Colors by  protocol After Movement (tone+2secs->end)
%     %     [clrsProt, legProt] = plotProtocolEmbedding(resAfter.pca.embedding{1}, labelsAnimal{l}, 'PCA Along Trials', labelsFontSz);
% end




