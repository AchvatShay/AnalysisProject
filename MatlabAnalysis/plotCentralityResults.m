function plotCentralityResults(cent_v, RoiSplitColor, outputPath)
    centrality_measures = fieldnames(cent_v);


    for name_i = 1:length(centrality_measures)
        currentMatrix = cent_v.(centrality_measures{name_i});
        
        for tr_index = 1:size(currentMatrix, 3)            
            fig = figure;
            hold on;
            title(sprintf('centrality measure : %s, Trial : %d', centrality_measures{name_i}, tr_index));

            for roi_index = 1:size(currentMatrix, 1)
                plot(squeeze(currentMatrix(roi_index, :, tr_index)), 'Color', RoiSplitColor(roi_index, :));
            end

            mysave(fig, fullfile(outputPath, ['centrality_', centrality_measures{name_i}, 'trIndex',num2str(tr_index)]));  
        end
    end
end