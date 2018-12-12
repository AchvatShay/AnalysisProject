function [current_embedding] = calcDistPcaTrajCreator(examinedInds, imagingData, generalProperty)
    X = imagingData.samples(:, :, examinedInds);

    for k=1:size(X,1)
        alldataNT(:, k) = reshape(X(k,:,:), size(X,3)*size(X,2),1);
    end
    [pcaTrajres.kernel, pcaTrajres.mu, pcaTrajres.eigs] = mypca(alldataNT);
    pcaTrajres.effectiveDim = max(getEffectiveDim(pcaTrajres.eigs, generalProperty.analysis_pca_thEffDim), 3);

    [~, projeff] = linrecon(alldataNT, pcaTrajres.mu, pcaTrajres.kernel, 1:pcaTrajres.effectiveDim);
    for l=1:size(projeff,2)
        pcaTrajres.projeff(l,:,:) = reshape(projeff(:,l),size(X,2),size(X,3));
    end

    b = fir1(10,.3);
    trajSmooth = filter(b,1, pcaTrajres.projeff, [], 2);
    trajSmooth=trajSmooth(:,6:end,:);
    
    current_embedding = mean(trajSmooth,3).';
end