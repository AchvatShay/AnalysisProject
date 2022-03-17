function [SpikeTrainStart] = calculateEventsDetection(dataAlltimesAl, samplingRate, outputpath)
    thresholdForGn = 2;
    runMLS = 1;
    sigmaChangeValue = 0;
    aV = 0.3;
    frameNum = size(dataAlltimesAl, 2);
    
    for activityIndex = 1:size(dataAlltimesAl, 1) 
        roiName = num2str(activityIndex);
        
        if runMLS == 0
            for tr_index = 1:size(dataAlltimesAl, 3)
               dataCurROI = squeeze(dataAlltimesAl(activityIndex, :, tr_index))';
               [spk, spk_end, spk_peak,~, ~, ~, spk_fit] = calcRoiEventDetectorByMLSpike_V3(dataCurROI, 1/samplingRate, frameNum, aV, outputpath, activityIndex, [], roiName, sigmaChangeValue, [], runMLS, thresholdForGn);                   
               SpikeTrainStart(activityIndex, tr_index) = spk;
               SpikeTrainEND(activityIndex, tr_index) = spk_end;
               SpikeTrainPEAK(activityIndex, tr_index) = spk_peak;
               SpikeTrainFIT(activityIndex, tr_index) = spk_fit;
            end
        else
            dataCurROI = squeeze(dataAlltimesAl(activityIndex, :, :));
            [spk, spk_end, spk_peak,~, ~, ~, spk_fit] = calcRoiEventDetectorByMLSpike_V3(dataCurROI, 1/samplingRate, frameNum, aV, outputpath, activityIndex, [], roiName, sigmaChangeValue, [], runMLS, thresholdForGn);                                       
            SpikeTrainStart(activityIndex, :) = spk;
            SpikeTrainEND(activityIndex, :) = spk_end;
            SpikeTrainPEAK(activityIndex, :) = spk_peak;
            SpikeTrainFIT(activityIndex, :) = spk_fit;
        end
    end
    
    save([outputpath, '\resultsEventsDetection.mat'], 'SpikeTrainStart');
end