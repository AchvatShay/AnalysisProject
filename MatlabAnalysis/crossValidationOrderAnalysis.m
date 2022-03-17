function crossValidationOrderAnalysis(outputPath, generalProperty, imagingData, BehaveData)
    folds = 3;
    generalProperty.trailsToRun = '1:end';
    lengthTrials = size(imagingData.samples, 3);
    
    kendall_r_order_final = {};
    kendall_r_t_final = {};
    Pearson_r_order_final = {};
    Pearson_r_t_final = {};
    Spearman_r_order_final = {};
    Spearman_r_t_final = {};
    
    master_imagingData.samples = imagingData.samples(:,:,:);
    master_imagingData.roiNames = imagingData.roiNames(:,:);

    fields = fieldnames(BehaveData);
    
    fields(strcmp(fields, 'traj')) = [];
    for b_i = 1:length(fields)
        master_BehaveData.(fields{b_i}).indicator = BehaveData.(fields{b_i}).indicator(:, :);
        master_BehaveData.(fields{b_i}).eventTimeStamps = BehaveData.(fields{b_i}).eventTimeStamps(:);
        master_BehaveData.(fields{b_i}).indicatorPerTrial = BehaveData.(fields{b_i}).indicatorPerTrial(:);
    end

    masterResults.results = getOrderOFActivationByData([outputPath '\master'], generalProperty, master_imagingData, master_BehaveData);

    for index = 1:folds
        selectedIndex = round(rand(1, round(lengthTrials / 2)) * lengthTrials);
        selectedIndex = unique(selectedIndex);
        selectedIndex(selectedIndex == 0) = [];
        unselectedIndex = 1:lengthTrials;
        unselectedIndex(selectedIndex) = [];
        
        self_imagingData.samples = imagingData.samples(:,:,unselectedIndex);
        self_imagingData.roiNames = imagingData.roiNames(:,unselectedIndex);

        
        fields = fieldnames(BehaveData);
        
        fields(strcmp(fields, 'traj')) = [];
        for b_i = 1:length(fields)
            self_BehaveData.(fields{b_i}).indicator = BehaveData.(fields{b_i}).indicator(unselectedIndex, :);
            self_BehaveData.(fields{b_i}).eventTimeStamps = BehaveData.(fields{b_i}).eventTimeStamps(unselectedIndex);
            self_BehaveData.(fields{b_i}).indicatorPerTrial = BehaveData.(fields{b_i}).indicatorPerTrial(unselectedIndex);
        end
        
        [kendall_r_order, Pearson_r_order, Spearman_r_order, kendall_r_t, Pearson_r_t, Spearman_r_t] = getOrderOfActivationByMaster([outputPath '\fold_' num2str(index)], generalProperty, self_imagingData, self_BehaveData, masterResults);            
        
        for indexEvents = 1:length(kendall_r_order)
            kendall_r_order_final{indexEvents} = getMaxAndMinValuesOfTest(kendall_r_order_final ,indexEvents, kendall_r_order{indexEvents}(1,2));
            kendall_r_t_final{indexEvents} = getMaxAndMinValuesOfTest(kendall_r_t_final, indexEvents, kendall_r_t{indexEvents}(1,2));
            Pearson_r_order_final{indexEvents} = getMaxAndMinValuesOfTest(Pearson_r_order_final, indexEvents, Pearson_r_order{indexEvents}(1,2));
            Pearson_r_t_final{indexEvents} = getMaxAndMinValuesOfTest(Pearson_r_t_final, indexEvents, Pearson_r_t{indexEvents}(1,2));
            Spearman_r_order_final{indexEvents} = getMaxAndMinValuesOfTest(Spearman_r_order_final, indexEvents, Spearman_r_order{indexEvents}(1,2));
            Spearman_r_t_final{indexEvents} = getMaxAndMinValuesOfTest(Spearman_r_t_final, indexEvents, Spearman_r_t{indexEvents}(1,2));
        end    
    end
    
    for eventI = 1:length(kendall_r_order_final)
        [~, ~, excelDataRaw] = xlsread('OrderAndTimingTemplate.xlsx');
        [line, currentCol] = find(strcmp(excelDataRaw, 'Pearson-order'));
        excelDataRaw{line, currentCol+1} = sprintf('%f-%f',Pearson_r_order_final{eventI});
        
        [line, currentCol] = find(strcmp(excelDataRaw, 'Kendall-order'));
        excelDataRaw{line, currentCol+1} = sprintf('%f-%f',kendall_r_order_final{eventI});
        
        [line, currentCol] = find(strcmp(excelDataRaw, 'Spearman-order'));
        excelDataRaw{line, currentCol+1} = sprintf('%f-%f',Spearman_r_order_final{eventI});
        
        [line, currentCol] = find(strcmp(excelDataRaw, 'Pearson-timing'));
        excelDataRaw{line, currentCol+1} = sprintf('%f-%f',Pearson_r_t_final{eventI});
        
        [line, currentCol] = find(strcmp(excelDataRaw, 'Kendall-timing'));
        excelDataRaw{line, currentCol+1} = sprintf('%f-%f',kendall_r_t_final{eventI});
        
        [line, currentCol] = find(strcmp(excelDataRaw, 'Spearman-timing'));
        excelDataRaw{line, currentCol+1} = sprintf('%f-%f',Spearman_r_t_final{eventI});
        
        filenameExcel = fullfile(outputPath, ['OrderAndTimingByMAster_analysisResults', num2str(eventI), 'By', generalProperty.alignedOrderByDataAccordingToEvent_eventName, '.xlsx']);
        xlswrite(filenameExcel,excelDataRaw);
        
    end
end

function results = getMaxAndMinValuesOfTest(t_final, indexEvents, t_test)
    if isempty(t_final) || length(t_final) < indexEvents || isempty(t_final{indexEvents})
        results = [t_test, t_test];
    else
        results = [max(t_test, t_final{indexEvents}(1)), min(t_test, t_final{indexEvents}(2))];
    end
end