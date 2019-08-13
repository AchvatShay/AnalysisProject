function FWHM_analysis(outputPath, generalProperty, imagingData, BehaveData)
    [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
        generalProperty.labels2cluster, generalProperty.includeOmissions);
    
    classes = unique(labels);
    
    s_t = examinedInds(labels==classes(strcmp(labelsLUT, generalProperty.successLabel)));
    
    [~, ~, excelDataRaw] = xlsread('FWHM_template.xlsx');
        
    lastrow = size(excelDataRaw,1);

    [line, currentCol] = find(strcmp(excelDataRaw, 'event:'));
    excelDataRaw{line, currentCol+1} = generalProperty.successLabel;
    
    min_points_above_baseline = generalProperty.min_points_above_baseline;
    min_points_under_FWHM = generalProperty.min_points_under_FWHM;
    data_downsamples_FWHM = generalProperty.data_downsamples_FWHM;
    
    data_downS_index = 1;
    for ds_index = 1:data_downsamples_FWHM:size(imagingData.samples, 2)
        downSampling_imagingData(:, data_downS_index,:) = mean(imagingData.samples(:, ds_index:(ds_index + (data_downsamples_FWHM - 1)),:), 2);
        data_downS_index = data_downS_index + 1;
    end
    
    imagingData.samples = downSampling_imagingData;
    
    t = linspace(0, generalProperty.Duration, size(imagingData.samples, 2));   
    toneTime = generalProperty.ToneTime;
    delays = findClosestDouble(t,toneTime)*ones(size(imagingData.samples,3), 1);
    onsetdiffvalid=max(delays(s_t))-delays(s_t);       
    currData = imagingData.samples(:, :, s_t);

    [peakValMean, peakTMean, ~, neurons_index, meanDat, baselineMean, ~] = getNeuronsActivationOrder(t, currData, toneTime, min_points_above_baseline, onsetdiffvalid);
    
    for ne = 1:size(imagingData.samples, 1)        
        
        if isnan(peakValMean(neurons_index == ne))
            fw_mean = nan; 
        else
            aboveHalfMaxMean = meanDat(ne, :) > ((peakValMean(neurons_index == ne) - baselineMean(neurons_index == ne))/2 + baselineMean(neurons_index == ne));

            firstIndexMean = find(aboveHalfMaxMean(1:peakTMean(neurons_index == ne)) == 0, 1, 'last') + 1;

            findLastIndex = peakTMean(neurons_index == ne);
            while findLastIndex <= length(aboveHalfMaxMean)
                lastIndexMean = find(aboveHalfMaxMean(findLastIndex:end) == 0, 1, 'first') + findLastIndex - 2;

                if isempty(lastIndexMean) || lastIndexMean == length(aboveHalfMaxMean)
                    lastIndexMean = length(aboveHalfMaxMean);
                    break;
                end
                
                aboveIndexF = find(aboveHalfMaxMean((lastIndexMean+1):end), 1, 'first') + lastIndexMean;
                if sum(aboveHalfMaxMean(lastIndexMean:aboveIndexF) == 0) > min_points_under_FWHM
                    break;
                end

                findLastIndex = aboveIndexF;
            end

            
            if (firstIndexMean < 1 || lastIndexMean > size(meanDat, 2))
                fw_mean = nan;    
            else
                fw_mean = lastIndexMean - firstIndexMean;
            end
        end
        
        fw_trails = zeros(1, length(s_t));
        for tr = 1:length(s_t)
            % to find a way to ignore noise
            [peakVal, peakT, baseline, ~] = getPeakPerTrialAndNeuron(t, currData(ne, :, tr), toneTime, min_points_above_baseline, onsetdiffvalid(tr));
            
            if ~isnan(peakT)
                aboveHalfMax = imagingData.samples(ne, :, s_t(tr)) > ((peakVal-baseline)/2 + baseline);

                firstIndex = find(aboveHalfMax(1:peakT) == 0, 1, 'last') + 1;
                
                findLastIndex = peakT;
                while findLastIndex <= length(aboveHalfMax)
                    lastIndex = find(aboveHalfMax(findLastIndex:end) == 0, 1, 'first') + findLastIndex - 2;
                    
                    if isempty(lastIndex) || lastIndex == length(aboveHalfMax)
                        lastIndex = length(aboveHalfMax);
                        break;
                    end
                        
                    aboveIndexF = find(aboveHalfMax((lastIndex+1):end), 1, 'first') + lastIndex;
                    
                    if sum(aboveHalfMax(lastIndex:aboveIndexF) == 0) > min_points_under_FWHM
                        break;
                    end
                    
                    findLastIndex = aboveIndexF;
                end
                
                
                
                if (firstIndex < 1 || lastIndex > size(imagingData.samples, 2))
                    fw_trails(tr) = nan;
                    continue;
                end

                fw_trails(tr) = lastIndex - firstIndex;
            else
                fw_trails(tr) = nan;
            end
        end
        
        fw_trails(isnan(fw_trails)) = [];
        
        [~, currentCol] = find(strcmp(excelDataRaw, 'Neuron'));
        excelDataRaw{lastrow+1, currentCol} = num2str(imagingData.roiNames(ne));
        
        [~, currentCol] = find(strcmp(excelDataRaw, 'Avg-FWHM'));
        excelDataRaw{lastrow+1, currentCol} = mean(fw_trails);
        
        [~, currentCol] = find(strcmp(excelDataRaw, 'TrialsCountForAvg'));
        excelDataRaw{lastrow+1, currentCol} = length(fw_trails);
        
        [~, currentCol] = find(strcmp(excelDataRaw, 'Avg-FWHM-ForMeanTrials'));
        excelDataRaw{lastrow+1, currentCol} = fw_mean;
        
        lastrow = lastrow + 1;
    end
    
    filenameExcel = fullfile(outputPath, 'FWHM_analysisResults.xlsx');
    xlswrite(filenameExcel,excelDataRaw);
end