function [peakVal, peakTime, order_loctions_neurons, neurons_order_index,dataAlltimesAl, meanbase, stdbase] = getNeuronsActivationOrder(t, currData, toneTime, minPointsForSettingActivity, onsetdiffvalid, orderMethod, centerOfMassStartTime, centerOfMassEndTime, samplingRate, outputpath)
    % Set base line and std according to unaligned data
    meanOrigData = mean(currData,3);
    meanbase = mean(meanOrigData(:, findClosestDouble(t, 1.5):findClosestDouble(t, toneTime-.1)),2);
    stdbase = std(meanOrigData(:, findClosestDouble(t, 1.5):findClosestDouble(t, toneTime-.1)),[],2);

    % Aligned Data
    % onsetdiffvalid = the diff between max event location and event
    % location of trials.
    dataAlltimesAl = zeros(size(currData,1), size(currData,2)+max(onsetdiffvalid), length(onsetdiffvalid));
    
    for m=1:length(onsetdiffvalid)
        dataAlltimesAl(:, 1:(size(currData,2)+onsetdiffvalid(m)), m) = [zeros(size(currData,1), onsetdiffvalid(m)) currData(:, :, m)];
    end
 
    dataAlltimesAl = smoothdata(dataAlltimesAl, 2, 'movmean', 10);
    
    [SpikeTrainStart] = calculateEventsDetection(dataAlltimesAl, samplingRate, [outputpath, '\EventsDetectionResults\']);
    
    start_activity = zeros(size(dataAlltimesAl, 1), size(dataAlltimesAl, 3));
    for tr_index = 1:size(dataAlltimesAl,3)
        
        meanDat = dataAlltimesAl(:,:,tr_index);
        
        % start to compare and find above treshold only after 1.5 sec
        start_check_time = findClosestDouble(t, 1.5) +  max(onsetdiffvalid);

        tNew = linspace(-max(onsetdiffvalid)*t(2), t(end), size(currData,2)+max(onsetdiffvalid));
           % start to compare and find above treshold only after 1.5 sec
        start_check_time_centerOfMass = findClosestDouble(tNew, centerOfMassStartTime);

        % start to compare and find above treshold only after 1.5 sec
        end_check_time_centerOfMass = findClosestDouble(tNew, centerOfMassEndTime);

        % for every neuron
        for index = 1:size(meanDat, 1)
            if (strcmp(orderMethod, 'peak'))
                % treshold set for baseline and 3 std
                treshold = (meanbase(index) + 3 * stdbase(index));
                start_activity(index, tr_index) = 0;
                peakVal(index, tr_index) = nan;
                peakTime(index, tr_index) = nan;

                % find in the neuron time only the ones that above treshold
                checkTreshold = meanDat(index, start_check_time:end) > treshold;
                lower_from_treshold = (checkTreshold == 0);
                ix = cumsum(lower_from_treshold & [true diff(lower_from_treshold) > 0]);
                if (lower_from_treshold(1) == 0)
                    ix = ix + 1;
                end
                location_array = start_check_time:size(meanDat, 2);
                cell_all_above_treshold = arrayfun(@(k) location_array(ix==k & ~lower_from_treshold),1:ix(end),'un',0);

                % The cellabovetreshold var contains cell array and the array is
                % the locations of time that pass treshold. every cell in the array
                % contains location that are only ones between 2 zeros
                for index_picks = 1:length(cell_all_above_treshold)
                    if length(cell_all_above_treshold{index_picks}) > minPointsForSettingActivity
                        % find peaks of signal only in the part where it pass
                        % trrshold and only if we have peak with MinPeakWidth
                        [pks,locs] = findpeaks(meanDat(index,cell_all_above_treshold{index_picks}).', 'MinPeakWidth', minPointsForSettingActivity);

                        if (~isempty(locs))
                            lessthan20Precentage = pks(1)*0.2;
                            
                            findLocation20P = find(meanDat(index,1:cell_all_above_treshold{index_picks}(end)).' <=  lessthan20Precentage, 1, 'last');
                            peakTime(index, tr_index) = findLocation20P;
                            peakVal(index, tr_index) = meanDat(index,findLocation20P);

                            start_activity(index, tr_index) = peakTime(index, tr_index);
                            
                            break;
                        end
                    end
                end
            elseif strcmp(orderMethod,'centerOfMass')
                TXA = meanDat(index, start_check_time_centerOfMass:end_check_time_centerOfMass) .* tNew(start_check_time_centerOfMass:end_check_time_centerOfMass);
                sumA = sum(meanDat(index, start_check_time_centerOfMass:end_check_time_centerOfMass));
                sumTXA = sum(TXA);

                start_activity(index, tr_index) = findClosestDouble(tNew, sumTXA / sumA);
                peakVal(index, tr_index) = nan;
                peakTime(index, tr_index) = nan;
            end
        end
        
        [order_loctions_neurons(tr_index, :), neurons_order_index(tr_index, :)] = sort(start_activity(:,tr_index));
        peakVal(:,tr_index) = peakVal(neurons_order_index, tr_index);
        peakTime(:,tr_index) = peakTime(neurons_order_index);
        meanbase(:,tr_index) = meanbase(neurons_order_index);
        stdbase(:,tr_index) = stdbase(neurons_order_index);
    end
end