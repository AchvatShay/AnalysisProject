function [peakVal, peakT, meanbase, stdbase] = getPeakPerTrialAndNeuron(t, dataPerNeuronAndTrial, toneTime, minPointsForSettingActivity, onsetdiffvalidPerTrial)
    % Set base line and std according to unaligned data
    meanbase = mean(dataPerNeuronAndTrial(findClosestDouble(t, 1.5):findClosestDouble(t, toneTime-.1)));
    stdbase = std(dataPerNeuronAndTrial(findClosestDouble(t, 1.5):findClosestDouble(t, toneTime-.1)));

    % Aligned Data
    % onsetdiffvalid = the diff between max event location and event
    % location of trials.
    dataAlltimesAl = zeros(1,length(dataPerNeuronAndTrial) + onsetdiffvalidPerTrial);
    dataAlltimesAl(1:(length(dataPerNeuronAndTrial)+onsetdiffvalidPerTrial)) = [zeros(1, onsetdiffvalidPerTrial) dataPerNeuronAndTrial];
                   
    % start to compare and find above treshold only after 1.5 sec
    start_check_time = findClosestDouble(t, 1.5) +  onsetdiffvalidPerTrial;
    
    % for every neuron
    % treshold set for baseline and 3 std
    treshold = (meanbase + 3 * stdbase);
    
    peakVal = nan;
    peakT = nan;

    % find in the neuron time only the ones that above treshold
    checkTreshold = dataAlltimesAl(start_check_time:end) > treshold;
    lower_from_treshold = (checkTreshold == 0);
    ix = cumsum(lower_from_treshold & [true diff(lower_from_treshold) > 0]);
    if (lower_from_treshold(1) == 0)
        ix = ix + 1;
    end
    location_array = start_check_time:length(dataAlltimesAl);
    cell_all_above_treshold = arrayfun(@(k) location_array(ix==k & ~lower_from_treshold),1:ix(end),'un',0);

    % The cellabovetreshold var contains cell array and the array is
    % the locations of time that pass treshold. every cell in the array
    % contains location that are only ones between 2 zeros
    for index_picks = 1:length(cell_all_above_treshold)
        if length(cell_all_above_treshold{index_picks}) > minPointsForSettingActivity
            % find peaks of signal only in the part where it pass
            % trrshold and only if we have peak with MinPeakWidth
            [pks,locs] = findpeaks(dataAlltimesAl(cell_all_above_treshold{index_picks}).', 'MinPeakWidth', minPointsForSettingActivity);

            if (~isempty(locs))
                peakT = cell_all_above_treshold{index_picks}(locs(1));
                peakVal = pks(1);
            else
                [peakVal, peakT] = max(dataAlltimesAl(cell_all_above_treshold{index_picks}).');
                peakT = cell_all_above_treshold{index_picks}(peakT);
            end

            break;
        end
    end
end