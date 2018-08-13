function [params, runningOrder] = setparams4Quest
dims4quest=3;

istopdown = true;

params = SetGenericDimsQuestParams(dims4quest, istopdown);
runningOrder = [1 2 3];

if istopdown
    for ind = 1:dims4quest
        params.init_aff{ind}.metric = 'L2';
        params.tree{ind}.runOnEmbdding = true;
        params.tree{ind}.splitsNum=2;
        params.tree{ind}.treeDepth = 8;%4;
        params.tree{ind}.clusteringAlgo = @kmeansWrapper;
        
    end
    params.tree{runningOrder==1}.runOnEmbdding = false;
    params.tree{runningOrder==2}.runOnEmbdding = false;
    
    % params.init_aff{runningOrder==2}.metric = 'euc';
    params.init_aff{runningOrder==2}.eps = 10;
    params.tree{1}.eigs_num=100;
    % params.tree{runningOrder==3}.eigs_num=100;
    
    params.tree{runningOrder==2}.splitsNum=2;
end
% params.tree{runningOrder==2}.runOnEmbdding = ~true;
params.n_iters = 0;
% params.tree{runningOrder==2}.treeDepth = 5;
params.data.over_rows = true;
params.data.to_normalize = false;%false
params.data.normalization_type = 'by_std';
params.verbose = 0;

