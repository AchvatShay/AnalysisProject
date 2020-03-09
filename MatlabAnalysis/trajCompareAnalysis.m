function trajCompareAnalysis(outputPath, generalProperty, imagingData, BehaveData)
    trajAvarage = mean(BehaveData.traj.data, 3);
    
    t = linspace(0, generalProperty.Duration, size(BehaveData.traj.data,2));
    
    trajSize = size(BehaveData.traj.data, 3);
    
    sum_front_zero = zeros(1, trajSize);
    sum_side_zero = zeros(1, trajSize);
    
    sum_front_tone = zeros(1, trajSize);
    sum_side_tone = zeros(1, trajSize);
    
    for currentTraj = 1:trajSize
        % Compare Start Trial zero time
        endT = 1;
        sum_front_zero(currentTraj) = emd_calc(trajAvarage(1:2, 1:(findClosestDouble(t, endT)))',...
            BehaveData.traj.data(1:2, 1:(findClosestDouble(t, endT)), currentTraj)');
        
        sum_side_zero(currentTraj) = emd_calc(trajAvarage(3:4, 1:(findClosestDouble(t, endT)))',...
            BehaveData.traj.data(3:4, 1:(findClosestDouble(t, endT)), currentTraj)');
   
        
        % Compare Start Trial Tone time
        startTime = findClosestDouble(t, generalProperty.ToneTime - 0.5);
        endT = generalProperty.ToneTime + 0.5;
        sum_front_tone(currentTraj) = emd_calc(trajAvarage(1:2, startTime:(findClosestDouble(t, endT)))',...
            BehaveData.traj.data(1:2, startTime:(findClosestDouble(t, endT)), currentTraj)');
        
        sum_side_tone(currentTraj) = emd_calc(trajAvarage(3:4, startTime:(findClosestDouble(t, endT)))',...
            BehaveData.traj.data(3:4, startTime:(findClosestDouble(t, endT)), currentTraj)');
   
    end
    
    avg_front_zero = mean(sum_front_zero);
    avg_side_zero = mean(sum_side_zero);
    avg_front_tone = mean(sum_front_tone);
    avg_side_tone = mean(sum_side_tone);
    
    std_front_zero = std(sum_front_zero);
    std_side_zero = std(sum_side_zero);
    std_front_tone = std(sum_front_tone);
    std_side_tone = std(sum_side_tone);
    
    tableSave = table(avg_front_zero, std_front_zero, avg_side_zero, std_side_zero, avg_front_tone, std_front_tone, avg_side_tone, std_side_tone, ...
        'VariableNames',  {'Front_Zero_PeriTime_avg', 'Front_Zero_PeriTime_std', 'Side_Zero_PeriTime_avg',...
        'Side_Zero_PeriTime_std', 'Front_Tone_PeriTime_avg', 'Front_Tone_PeriTime_std', 'Side_Tone_PeriTime_avg' , 'Side_Tone_PeriTime_std'});
    writetable(tableSave,[outputPath '\compareResults.xlsx'],'Sheet',1,'Range','D1')
end


