function getOrderOFActivationByData(outputPath, generalProperty, imagingData, BehaveData)
    [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
        generalProperty.labels2cluster, generalProperty.includeOmissions);
    
    classes = unique(labels);
    
    [examinedInds, labels] = getTrialsIndexAccordingToString(generalProperty.trailsToRunOrderByData, examinedInds, labels);
        
    minPointsForSettingActivity = generalProperty.min_points_above_baseline;
    t = linspace(0, generalProperty.Duration, size(imagingData.samples, 2));
    results = [];
    
    toneTime = generalProperty.ToneTime;
   
    if ~isempty(generalProperty.alignedOrderByDataAccordingToEvent_eventName) && ~isempty(generalProperty.alignedOrderByDataAccordingToEvent_eventNum) 
        delays = alignedDataAccordingToEvent(generalProperty.alignedOrderByDataAccordingToEvent_eventName, generalProperty.alignedOrderByDataAccordingToEvent_eventNum, BehaveData);
        alignedEventName = [generalProperty.alignedOrderByDataAccordingToEvent_eventName num2str(generalProperty.alignedOrderByDataAccordingToEvent_eventNum)];
    else
        delays = findClosestDouble(t,toneTime)*ones(size(imagingData.samples,3), 1); 
        alignedEventName = 'tone';
    end
    
    for index_events = 0:length(classes)
        if index_events == 0
            trails_list = examinedInds;
            eventName = 'all';
        else
            trails_list = examinedInds(labels==classes(index_events));
            eventName = labelsLUT{index_events};
        end
        
        validinds=~isnan(delays(trails_list)) ;
        if all(validinds==0)
            error('All trails do not contains event selected')
        end

        trails_list = trails_list(validinds);
        
        onsetdiffvalid=max(delays(trails_list))-delays(trails_list);       
        
        currData = imagingData.samples(:, :, trails_list);
        
        [~, ~, order_loctions_neurons, neurons_order_index, meanDat, ~, ~] = getNeuronsActivationOrder(t, currData, toneTime, minPointsForSettingActivity, onsetdiffvalid);
        
        tNew= linspace(-max(onsetdiffvalid)*t(2), t(end), size(imagingData.samples,2)+max(onsetdiffvalid));
        
        save_data_roi_names = imagingData.roiNames(neurons_order_index,1);       
        
        zerosValues = length(find(order_loctions_neurons == 0));
        if (zerosValues ~= 0)
            order_loctions_neurons(1:zerosValues) = [];
            save_data_roi_names(1:zerosValues) = [];
            neurons_order_index(1:zerosValues) = [];
        end
        
        save_data_time = tNew(order_loctions_neurons)';
        T_save.eventName = eventName;
        T_save.alignedEventName = generalProperty.alignedOrderByDataAccordingToEvent_eventName;
        T_save.alignedEventNum = generalProperty.alignedOrderByDataAccordingToEvent_eventNum;
        T_save.table = table((1:length(order_loctions_neurons))', save_data_roi_names, order_loctions_neurons, save_data_time);
                
        results{index_events + 1} = T_save;
        
        fig = figure;
        hold on;
        order_data = meanDat(neurons_order_index, :);
        imagesc(tNew, 1:length(order_loctions_neurons), order_data);
        fig.UserData = neurons_order_index;
        dcm_obj = datacursormode(fig);
        set(dcm_obj,'UpdateFcn',@getRealNeuronNameCursor)
        plot(save_data_time, 1:length(order_loctions_neurons), 'color', 'black', 'LineWidt', 2);
        colormap jet;
        ylabel('Neurons','FontSize',10);
%         placeToneTime(toneTime, 3);
        xlim([tNew(findClosestDouble(tNew, generalProperty.alignedOrderPlot_start_time)),tNew(findClosestDouble(tNew, generalProperty.alignedOrderPlot_end_time))]);
        ylim([1, length(order_loctions_neurons)]);
        
        mysave(fig, fullfile(outputPath, ['activation_order_peak'  eventName 'By_' alignedEventName '_plot']));
    end
    
    save(fullfile(outputPath, ['activation_order_peak' eventsStr 'By_' alignedEventName '.mat']), 'results');
end