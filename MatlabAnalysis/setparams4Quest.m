function [params, runningOrder] = setparams4Quest
dims4quest=3;

istopdown = false;

params = SetGenericDimsQuestParams(dims4quest, istopdown);
runningOrder = [1 2 3];


params.n_iters = 2;
% params.data.over_rows = true;
% params.data.normalization_type = 'by_std';
params.verbose = 0;
params.data.to_normalize = false;

