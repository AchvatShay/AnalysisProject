function trajCompareAnalysis(outputPath, generalProperty, imagingData, BehaveData)
    trajAvarage = mean(BehaveData.traj.data, 3);
    
    t = linspace(0, generalProperty.Duration, size(BehaveData.traj.data,2));
   
    sum_front_zero = 0;
    sum_side_zero = 0;
    
    sum_front_tone = 0;
    sum_side_tone = 0;
    
    trajSize = size(BehaveData.traj.data, 3);
    for currentTraj = 1:trajSize
        % Compare Start Trial zero time
        endT = 1;
        sum_front_zero = sum_front_zero + emd_calc(trajAvarage(1:2, 1:(findClosestDouble(t, endT)))',...
            BehaveData.traj.data(1:2, 1:(findClosestDouble(t, endT)), currentTraj)');
        
        sum_side_zero = sum_side_zero + emd_calc(trajAvarage(3:4, 1:(findClosestDouble(t, endT)))',...
            BehaveData.traj.data(3:4, 1:(findClosestDouble(t, endT)), currentTraj)');
   
        
        % Compare Start Trial Tone time
        startTime = findClosestDouble(t, generalProperty.ToneTime - 0.5);
        endT = generalProperty.ToneTime + 0.5;
        sum_front_tone = sum_front_tone + emd_calc(trajAvarage(1:2, startTime:(findClosestDouble(t, endT)))',...
            BehaveData.traj.data(1:2, startTime:(findClosestDouble(t, endT)), currentTraj)');
        
        sum_side_tone = sum_side_tone + emd_calc(trajAvarage(3:4, startTime:(findClosestDouble(t, endT)))',...
            BehaveData.traj.data(3:4, startTime:(findClosestDouble(t, endT)), currentTraj)');
   
    end
    
    avg_front_zero = sum_front_zero ./ trajSize;
    avg_side_zero = sum_side_zero ./ trajSize;
    avg_front_tone = sum_front_tone ./ trajSize;
    avg_side_tone = sum_side_tone ./ trajSize;
    
    tableSave = table(avg_front_zero, avg_side_zero, avg_front_tone, avg_side_tone, 'VariableNames',  {'Front_Zero_Time', 'Side_Zero_Time', 'Front_Tone_Time', 'Side_Tone_Time'});
    writetable(tableSave,[outputPath '\compareResults.xlsx'],'Sheet',1,'Range','D1')
end


