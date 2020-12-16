function plotCentralityResults(cent_v, RoiSplitColor, outputPath)
    centrality_measures = fieldnames(cent_v);


    for name_i = 1:length(centrality_measures)
        currentMatrix = cent_v.(centrality_measures{name_i});
        
        fig = figure;
        hold on;
        title(sprintf('centrality measure : %s', centrality_measures{name_i}));
        
        for roi_index = 1:size(currentMatrix, 1)
            plot(mean(currentMatrix(roi_index, :, :), 3), 'Color', RoiSplitColor(roi_index, :));
        end
        
        mysave(fig, fullfile(outputPath, ['centrality_', centrality_measures{name_i}]));  

    end
end