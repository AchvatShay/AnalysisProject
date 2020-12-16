function cent_vals = get_cent_vals_by_time_trial(cent_vals0, Nt, NT)
    centrality_measures = fieldnames(cent_vals0{1,1});


    for name_i = 1:length(centrality_measures)
        cent_vals.(centrality_measures{name_i}) = zeros(length(cent_vals0{1,1}.(centrality_measures{1})), size(cent_vals0, 1), size(cent_vals0,2));
        for t = 1:Nt
            for T = 1:NT
                cent_vals.(centrality_measures{name_i})(:, t, T) = cent_vals0{t,T}.(centrality_measures{name_i});
            end
        end
    end
end
