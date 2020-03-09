function trajCompareEMDAnalysis(outputPath, generalProperty, imagingData, BehaveData)
    
    t = linspace(0, generalProperty.Duration, size(BehaveData.traj.data,2));
    
    NAMES_BEHAVE = fields(BehaveData);
    
%     [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
%         generalProperty.labels2cluster, generalProperty.includeOmissions);
%   
    labelsLUT = {};
    examinedInds = 1:size(BehaveData.traj.data,3);
    
    liftEvents = NAMES_BEHAVE(contains(NAMES_BEHAVE, 'lift'));
        
    for i = 0:length(labelsLUT)
        trajAvarage = [];
        
        if i == 0
            labelName = 'All';
            examinedIndsToRun = examinedInds;
        else
            labelName = labelsLUT{i};
            examinedIndsToRun = examinedInds(labels == i);
        end
        
        trajAvarage = mean(BehaveData.traj.data(:, :, examinedIndsToRun), 3);    
        trajSize = size(BehaveData.traj.data(:, :, examinedIndsToRun), 3);

        sum_front_zero = zeros(1, trajSize);
        sum_side_zero = zeros(1, trajSize);

        sum_front_tone = zeros(1, trajSize);
        sum_side_tone = zeros(1, trajSize);
        
        sum_front_lift = zeros(1, max(examinedIndsToRun));
        sum_side_lift = zeros(1, max(examinedIndsToRun));
        lift_index = zeros(1, max(examinedIndsToRun));
        
        startTimeZero = findClosestDouble(t, 0);
        endTimeZero = findClosestDouble(t, 1);
               
        startTimeTone = findClosestDouble(t, generalProperty.ToneTime - 0.5);
        endTimeTone = findClosestDouble(t, generalProperty.ToneTime + 0.5);
        
        startTimeLift = zeros(1 , max(examinedIndsToRun));
        endTimeLift = zeros(1, max(examinedIndsToRun));
        
        
        for currentTraj = 1:trajSize
            % Compare Start Trial zero time
            sum_front_zero(currentTraj) = emd_calc(trajAvarage(1:2, startTimeZero:endTimeZero)',...
                BehaveData.traj.data(1:2, startTimeZero:endTimeZero, examinedIndsToRun(currentTraj))');

            sum_side_zero(currentTraj) = emd_calc(trajAvarage(3:4, startTimeZero:endTimeZero)',...
                BehaveData.traj.data(3:4, startTimeZero:endTimeZero, examinedIndsToRun(currentTraj))');


            % Compare Start Trial Tone time
            sum_front_tone(currentTraj) = emd_calc(trajAvarage(1:2, startTimeTone:endTimeTone)',...
                BehaveData.traj.data(1:2, startTimeTone:endTimeTone, examinedIndsToRun(currentTraj))');

            sum_side_tone(currentTraj) = emd_calc(trajAvarage(3:4, startTimeTone:endTimeTone)',...
                BehaveData.traj.data(3:4, startTimeTone:endTimeTone, examinedIndsToRun(currentTraj))');

            
            % Compare First Lift after Tone
             for liftIndex = 1:length(liftEvents)
                e_loc = BehaveData.(liftEvents{liftIndex}).eventTimeStamps{examinedIndsToRun(currentTraj)};
                if ~isempty(e_loc)
                    if t(e_loc(1)) >= generalProperty.ToneTime
                        startTimeLift(examinedIndsToRun(currentTraj)) = findClosestDouble(t, t(e_loc(1)) - 0.5);
                        endTimeLift(examinedIndsToRun(currentTraj)) = findClosestDouble(t, t(e_loc(1)) + 0.5);
                        lift_index(examinedIndsToRun(currentTraj)) = 1;
                        
                        sum_front_lift(examinedIndsToRun(currentTraj)) = emd_calc(trajAvarage(1:2, startTime:endTime)',...
                            BehaveData.traj.data(1:2, startTime:endTime, examinedIndsToRun(currentTraj))');

                        sum_side_lift(examinedIndsToRun(currentTraj)) = emd_calc(trajAvarage(3:4, startTime:endTime)',...
                            BehaveData.traj.data(3:4, startTime:endTime, examinedIndsToRun(currentTraj))');
                        break;
                    end
                else
                    break;
                end
             end                     
        end
        
        avg_front_zero = mean(sum_front_zero);
        avg_side_zero = mean(sum_side_zero);
        avg_front_tone = mean(sum_front_tone);
        avg_side_tone = mean(sum_side_tone);
        avg_front_lift = mean(sum_front_lift(lift_index == 1));
        avg_side_lift = mean(sum_side_lift(lift_index == 1));

        std_front_zero = std(sum_front_zero);
        std_side_zero = std(sum_side_zero);
        std_front_tone = std(sum_front_tone);
        std_side_tone = std(sum_side_tone);
        std_front_lift = std(sum_front_lift(lift_index == 1));
        std_side_lift = std(sum_side_lift(lift_index == 1));

        % Plot Results
        
        % Zero
        figZeroFront = figure;
        hold on;
        shadedErrorBar(trajAvarage(1, startTimeZero:endTimeZero), trajAvarage(2, startTimeZero:endTimeZero), std_front_zero);
        title('PeriTime Zero Front');
        mysave(figZeroFront, fullfile(outputPath, ['TrajCompareResultsZeroFront_' labelName]));
       
        figZeroSide = figure;
        hold on;
        shadedErrorBar(trajAvarage(3, startTimeZero:endTimeZero), trajAvarage(4, startTimeZero:endTimeZero), std_side_zero);
        title('PeriTime Zero Side');
        mysave(figZeroSide, fullfile(outputPath, ['TrajCompareResultsZeroSide_' labelName]));
               
        % Tone
        figToneFront = figure;
        hold on;
        shadedErrorBar(trajAvarage(1, startTimeTone:endTimeTone), trajAvarage(2, startTimeTone:endTimeTone), std_front_tone);
        title('PeriTime Tone Front');
        mysave(figToneFront, fullfile(outputPath, ['TrajCompareResultsToneFront_' labelName]));
       
        figToneSide = figure;
        hold on;
        shadedErrorBar(trajAvarage(3, startTimeTone:endTimeTone), trajAvarage(4, startTimeTone:endTimeTone), std_side_tone);
        title('PeriTime Tone Side');
        mysave(figToneSide, fullfile(outputPath, ['TrajCompareResultsToneSide_' labelName]));
       
        % Lift first after tone
        figLiftFront = figure;
        hold on;
        shadedErrorBar(trajAvarage(1, mean(startTimeLift(lift_index == 1)):mean(endTimeLift(lift_index == 1))), trajAvarage(2, mean(startTimeLift(lift_index == 1)):mean(endTimeLift(lift_index == 1))), std_front_lift);
        title('PeriTime Lift Front');
        mysave(figLiftFront, fullfile(outputPath, ['TrajCompareResultsLiftFront_' labelName]));
       
        figLiftSide = figure;
        hold on;
        shadedErrorBar(trajAvarage(3, mean(startTimeLift(lift_index == 1)):mean(endTimeLift(lift_index == 1))), trajAvarage(4, mean(startTimeLift(lift_index == 1)):mean(endTimeLift(lift_index == 1))), std_side_lift);
        title('PeriTime Lift Side');
        mysave(figLiftSide, fullfile(outputPath, ['TrajCompareResultsLiftSide_' labelName]));
              
        
        %Box Plot
        figBox = figure;
        hold on;
        
        boxplot([sum_front_zero', sum_side_zero' ,sum_front_tone', sum_side_tone', sum_front_lift(lift_index == 1)', sum_side_lift(lift_index == 1)'], ...
            'Labels',{'FrontZero','SideZero', 'FrontTone', 'SideTone', 'FrontLift','SideLift'})
        title({'Traj Compare Results ', labelName})  
        
        mysave(figBox, fullfile(outputPath, ['TrajCompareResultsBox_' labelName]));
        
        tableSave = table(avg_front_zero, std_front_zero, avg_side_zero, std_side_zero, avg_front_tone, std_front_tone, avg_side_tone, std_side_tone, ...
            avg_front_lift, std_front_lift, avg_side_lift, std_side_lift, ...
            'VariableNames',  {'Front_Zero_PeriTime_avg', 'Front_Zero_PeriTime_std', 'Side_Zero_PeriTime_avg',...
            'Side_Zero_PeriTime_std', 'Front_Tone_PeriTime_avg', 'Front_Tone_PeriTime_std', 'Side_Tone_PeriTime_avg' , 'Side_Tone_PeriTime_std',...
            'Front_lift_PeriTime_avg', 'Front_lift_PeriTime_std', 'Side_lift_PeriTime_avg', 'Side_lift_PeriTime_std'});
        writetable(tableSave,[outputPath '\' labelName '_compareResults.xlsx'],'Sheet',1,'Range','D1')
    end
end
