function [cent_weighted, cent_notweighted] = calc_centrality_per_time_and_trial(W, community_labels)
%%%%%%%%%%%%%%%%
% input  -W is connectivity features over time windows over trials
% outputs - cent_weighted, cent_notweighted are centrality structs. Each
% field is a specific centrality measure of nodes over time over trials.
% weighted/not - for weighted/not weighted versions of centrality
%
% Written by: Hadas Benisty 17/11/2002
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [NN, Nt, NT] = size(W);
    N = length(community_labels);
    if N ~= sqrt(NN)
        error('Check dims, first dim of W should be length of labels^2');
    end

    for t = 1:Nt
        for T = 1:NT
            w = reshape(W(:, t, T), [N N]);
            [cent_weighted0{t,T}, cent_notweighted0{t,T}] = graph_centrality(w, community_labels);
        end
    end
    cent_weighted = get_cent_vals_by_time_trial(cent_weighted0, Nt, NT);
    cent_notweighted = get_cent_vals_by_time_trial(cent_notweighted0, Nt, NT);
end