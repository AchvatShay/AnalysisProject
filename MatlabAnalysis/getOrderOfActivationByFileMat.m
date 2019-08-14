function getOrderOfActivationByFileMat(outputPath, generalProperty, imagingData, BehaveData)    
    [labels, examinedInds, ~, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
        generalProperty.labels2cluster, generalProperty.includeOmissions);
    min_points_above_baseline = generalProperty.min_points_above_baseline;
    classes = unique(labels);
%     
    t = linspace(0, generalProperty.Duration, size(imagingData.samples, 2));  
    toneTime = generalProperty.ToneTime;
   [examinedInds, labels] = getTrialsIndexAccordingToString(generalProperty.trailsToRunOrderByData, examinedInds, labels);
       
    orderActivation = load(generalProperty.orderActivationFileLocation);

    for index_events = 1:length(orderActivation.results)
        eventName = orderActivation.results{index_events}.eventName;
        ind = find(strcmp(labelsLUT, eventName));
        
         if ~isempty(orderActivation.results{index_events}.alignedEventName) && ~isempty(orderActivation.results{index_events}.alignedEventNum) 
            delays = alignedDataAccordingToEvent(orderActivation.results{index_events}.alignedEventName, orderActivation.results{index_events}.alignedEventNum, BehaveData);
            alignedEventName = [orderActivation.results{index_events}.alignedEventName num2str(generalProperty.alignedOrderByDataAccordingToEvent_eventNum)];
        else
            delays = findClosestDouble(t,toneTime)*ones(size(imagingData.samples,3), 1); 
            alignedEventName = 'tone';
        end
        
        if isempty(ind)
            trails_list = examinedInds;
        else
            trails_list = examinedInds(labels==classes(ind));
        end
        
        validinds=~isnan(delays(trails_list)) ;
        if all(validinds==0)
            error('All trails do not contains event selected')
        end

        trails_list = trails_list(validinds);
        
        onsetdiffvalid=max(delays(trails_list))-delays(trails_list);       
        
        currData = imagingData.samples(:, :, trails_list);
        
        [~, ~, order_loctions_neurons, neurons_order_index, meanDat, ~, ~] = getNeuronsActivationOrder(t, currData, toneTime, min_points_above_baseline, onsetdiffvalid);
        
        tNew= linspace(-max(onsetdiffvalid)*t(2), t(end), size(imagingData.samples,2)+max(onsetdiffvalid));
      
        orderTable = orderActivation.results{index_events}.table;
        data_order = [];
        save_data_time = [];
        orig_data_time = [];
        data_order_index = 1;
        time_order_index = 1;
            
        for n_index = 1:size(orderTable, 1)
            neurons_location = find(imagingData.roiNames(:,1)-orderTable{n_index, 2}==0);
            
            if (isempty(neurons_location))
                continue;
            end
            
            save_data_time(data_order_index, 1) = orderTable{n_index, 4};
            data_order(data_order_index, :) = meanDat(neurons_location,:);
            
            if order_loctions_neurons(neurons_location) ~= 0
                orig_data_time(time_order_index, :) = [tNew(order_loctions_neurons(neurons_location)), data_order_index];
                time_order_index = time_order_index + 1;
            end
            
            data_order_index = data_order_index + 1;
        end
        
        fig = figure;
        hold on;
        imagesc(tNew, 1:size(data_order, 1), data_order);
        plot(save_data_time, 1:size(data_order, 1), 'color', 'blue', 'LineWidt', 2);
        plot(orig_data_time(:, 1), orig_data_time(:, 2), 'color', 'black', 'LineWidt', 2);
        colormap jet;
        ylabel('Neurons','FontSize',10);
%         placeToneTime(toneTime, 3);
        xlim([tNew(findClosestDouble(tNew, 0)),tNew(findClosestDouble(tNew, 8))]);
        ylim([1, size(data_order, 1)]);
        
        mysave(fig, fullfile(outputPath, ['activation_order_'  eventName 'By' alignedEventName '_plot']));
    end
end