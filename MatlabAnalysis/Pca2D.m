function pcares = Pca2D(outputPath, generalProperty, imagingData, BehaveData)
% analysis
X = imagingData.samples;
for k=1:size(X,3)
    alldata(:, k) = reshape(X(:,:,k), size(X,1)*size(X,2),1);
end

[pcares.embedding, ~, vals] = pca(alldata);
pcares.effectiveDim = max(getEffectiveDim(vals, generalProperty.analysis_pca_thEffDim), 3);
pcares.eigs = vals;

save(fullfile(outputPath, 'pca_res'), 'pcares');

% visualize
switch generalProperty.PelletPertubation
    case 'None'
        plotSF2D([],  pcares.embedding(:,1:2), BehaveData.failure, generalProperty.visualization_labelsFontSize, generalProperty.visualization_legendLocation);
        mysave(gcf, fullfile(outputPath, 'pca2Dsucfail'));
        
    case 'Ommisions'
        if ~isfield(BehaveData, 'nopellet')
            warning('ommisions were not marked in BDA file!');
            plotSF2D([],  pcares.embedding(:,1:2), BehaveData.failure, generalProperty.visualization_labelsFontSize, generalProperty.visualization_legendLocation);
        else
            
            figure;a=gca;
            plot(a, pcares.embedding(BehaveData.nopellet==1,1)  ,embedding(BehaveData.nopellet==1,2),'ko', 'MarkerFaceColor','k');
            hold all;
            plotSF2D(a, pcares.embedding(BehaveData.nopellet==0,1:2), BehaveData.failure(BehaveData.nopellet==0), labelsFontSz);
            plotSF2D(a, pcares.embedding(:, 1:2), BehaveData.failure, generalProperty.visualization_labelsFontSize);
            l=legend('Omission','Failure','Success', 'Location',generalProperty.visualization_legendLocation);
            set(l, 'FontSize',generalProperty.visualization_labelsFontSize);
        end
        mysave(gcf, fullfile(outputPath, 'pca2Dsucfail'));
        
    case 'Taste'
        plotSF2D([],  pcares.embedding(:,1:2), BehaveData.failure, generalProperty.visualization_labelsFontSize, generalProperty.visualization_legendLocation);
        mysave(gcf, fullfile(outputPath, 'pca2Dsucfail'));
        
        f=plot2Dtasting(BehaveData, pcares.embedding, generalProperty.visualization_labelsFontSize. generalProperty.visualization_legendLocation);
        if ~isempty(f)
            mysave(f(1), fullfile(outputPath, 'pca2Dtaste'));
            mysave(f(2), fullfile(outputPath, 'pca2Dtastesucfail'));
            
        end
        
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




