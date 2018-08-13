function [resDiffMap, runningOrder] = diffMapAnalysis(X, thEffDim)
[params, runningOrder] = setparams4Quest;
[ resDiffMap.Trees, ~, ~, resDiffMap.embedding, ~, resDiffMap.eigs] ...
    = RunGenericDimsQuestionnaire( params, permute(X,runningOrder));

for nr=1:size(X,1)
    alldataNT(:, nr) = reshape(X(nr,:,:), size(X,2)*size(X,3),1);
end

resDiffMap.effectiveDim = max(getEffectiveDim(diag(resDiffMap.eigs{runningOrder== 1}), thEffDim),3);

[~, projeff] = linrecon(alldataNT, mean(alldataNT,1),resDiffMap.embedding{runningOrder==1}, 1:resDiffMap.effectiveDim);

for l=1:size(projeff,2)
    resDiffMap.projeff(l,:,:) = reshape(projeff(:,l),size(X,2),size(X,3));
end
