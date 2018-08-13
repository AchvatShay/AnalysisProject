function diffMap2D(outputPath, generalProperty, imagingData, BehaveData)
% analysis
tryinginds = find(BehaveData.success == 1 | BehaveData.failure == 1);
X = imagingData.samples(:, :, tryinginds);
if exist(fullfile(outputPath, 'diff_map_res.mat'), 'file')
    load(fullfile(outputPath, 'diff_map_res'), 'resDiffMap', 'ACC2D', 'runningOrder');
else
    [resDiffMap, runningOrder] = diffMapAnalysis(X, generalProperty.analysis_pca_thEffDim);
    labsOmissions = BehaveData.failure;    
    embedding = resDiffMap.embedding{runningOrder==3}(:,1:2);
    labsOmissionstrying = labsOmissions(tryinginds);
    foldsNum = generalProperty.foldsNum;
    ACC2D = svmClassifyAndRand(embedding(labsOmissions(tryinginds)~=2,:), labsOmissionstrying(labsOmissionstrying~=2), labsOmissionstrying(labsOmissionstrying~=2), foldsNum, '', 1, 0);
    save(fullfile(outputPath, 'diff_map_res'), 'resDiffMap', 'ACC2D', 'runningOrder');
end


% visualize
visualize2Dembedding(generalProperty, ACC2D, BehaveData, resDiffMap.embedding{runningOrder==3}, outputPath, 'diffMap')



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




