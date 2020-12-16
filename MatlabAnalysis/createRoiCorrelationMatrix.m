function [x_data, generalProperty] = createRoiCorrelationMatrix(imagingData, generalProperty)
    if strcmp(generalProperty.corrTypeRoiCorrelation, 'reg')
        func = 'corr';
    elseif strcmp(generalProperty.corrTypeRoiCorrelation, 'par')
        func = 'custom_parcorr';
    else
        error('Correlation Type Error');
    end
    
    correlationWindow = generalProperty.winLenRoiCorrelation;
    correlationTimeJump = generalProperty.winHopRoiCorrelation;
    
    
    win_index = 1;
    for index_time = 0:correlationTimeJump:generalProperty.Duration
        
        if index_time + correlationWindow > generalProperty.Duration
            break;
        end
        
        framesToTake = (index_time*generalProperty.ImagingSamplingRate + 1) : (index_time + correlationWindow)*generalProperty.ImagingSamplingRate;
        
        for index_trial = 1:size(imagingData.samples, 3)
            corr_results = feval(func,imagingData.samples(:, framesToTake, index_trial)');
            corr_results = tril(corr_results, -1) + tril(corr_results, -1)' + diag(ones(1, size(corr_results, 1))); 
            x_data(:, win_index, index_trial) = reshape(corr_results, [], 1);
        end
        
        win_index = win_index + 1;
    end
    
    generalProperty.ImagingSamplingRate = 1 / correlationTimeJump;
end