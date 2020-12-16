function [cent_weighted, cent_notweighted] = graph_centrality(W, community_labels)
    isdirected = ~issymmetric(W);

    if isdirected
        G=digraph(double(W));
        c = {'indegree',             'outdegree',        'incloseness','outcloseness',...
            'betweenness','pagerank','hubs','authorities'};
        wstr = {'Importance'   'Importance'               'Cost'      'Cost'    'Cost'      'Importance'   'Importance' 'Importance'};
        wnums = {abs(G.Edges.Weight) abs(G.Edges.Weight) exp(-G.Edges.Weight) exp(-G.Edges.Weight)...
             exp(-G.Edges.Weight) abs(G.Edges.Weight) abs(G.Edges.Weight) abs(G.Edges.Weight)};
    else
        G = graph(W);
        c = {'degree',         'closeness','betweenness','pagerank', 'eigenvector'};
        wstr = {'Importance'   'Cost'      'Cost'         'Importance'   'Importance'};
        wnums = {abs(G.Edges.Weight) exp(-G.Edges.Weight) exp(-G.Edges.Weight)...
            abs(G.Edges.Weight) abs(G.Edges.Weight)};
    end

    for k=1:length(c)    
        cent_weighted.(c{k}) = centrality(G, c{k}, wstr{k}, wnums{k});    
        cent_notweighted.(c{k}) = centrality(G, c{k});
    end

    cent_notweighted.participation=participation_coef((W~=0),community_labels,0);
    cent_weighted.participation=participation_coef(W,community_labels,0);
end
