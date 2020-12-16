function trajCompareEMDAnalysis(outputPath, generalProperty, imagingData, BehaveData)
    
    t = linspace(0, generalProperty.Duration, size(BehaveData.traj.data,2));
    frameRateRatio = generalProperty.BehavioralSamplingRate/generalProperty.ImagingSamplingRate;

    NAMES_BEHAVE = fields(BehaveData);
    
    [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
        generalProperty.labels2cluster, generalProperty.includeOmissions);
  
%     labelsLUT = {};
%     examinedInds = 1:size(BehaveData.traj.data,3);
%     
    liftEvents = NAMES_BEHAVE(contains(NAMES_BEHAVE, 'lift'));        

    trajAvarage = mean(BehaveData.traj.data(:, :, examinedInds), 3);    
    trajSize = size(BehaveData.traj.data(:, :, examinedInds), 3);

    sum_front_zero = zeros(1, max(examinedInds));
    sum_side_zero = zeros(1, max(examinedInds));

    sum_front_tone = zeros(1, max(examinedInds));
    sum_side_tone = zeros(1, max(examinedInds));

    sum_front_lift = zeros(1, max(examinedInds));
    sum_side_lift = zeros(1, max(examinedInds));
    lift_index = zeros(1, max(examinedInds));
    tr_index = zeros(1, max(examinedInds));

    startTimeZero = findClosestDouble(t, 0);
    endTimeZero = findClosestDouble(t, 1);

    startTimeTone = findClosestDouble(t, generalProperty.ToneTime - 0.5);
    endTimeTone = findClosestDouble(t, generalProperty.ToneTime + 0.5);

    startTimeLift = zeros(1 , max(examinedInds));
    endTimeLift = zeros(1, max(examinedInds));


    for currentTraj = 1:trajSize
        % Compare Start Trial zero time
        sum_front_zero(examinedInds(currentTraj)) = emd_calc(trajAvarage(1:2, startTimeZero:endTimeZero)',...
            BehaveData.traj.data(1:2, startTimeZero:endTimeZero, examinedInds(currentTraj))');

        sum_side_zero(examinedInds(currentTraj)) = emd_calc(trajAvarage(3:4, startTimeZero:endTimeZero)',...
            BehaveData.traj.data(3:4, startTimeZero:endTimeZero, examinedInds(currentTraj))');


        % Compare Start Trial Tone time
        sum_front_tone(examinedInds(currentTraj)) = emd_calc(trajAvarage(1:2, startTimeTone:endTimeTone)',...
            BehaveData.traj.data(1:2, startTimeTone:endTimeTone, examinedInds(currentTraj))');

        sum_side_tone(examinedInds(currentTraj)) = emd_calc(trajAvarage(3:4, startTimeTone:endTimeTone)',...
            BehaveData.traj.data(3:4, startTimeTone:endTimeTone, examinedInds(currentTraj))');

        tr_index(examinedInds(currentTraj)) = 1;
        
        % Compare First Lift after Tone
         for liftIndex = 1:length(liftEvents)
            e_loc = BehaveData.(liftEvents{liftIndex}).eventTimeStamps{examinedInds(currentTraj)};
            e_loc = round(e_loc .* frameRateRatio) + generalProperty.BehavioralDelay;
            if ~isempty(e_loc)
                if t(e_loc(1)) >= generalProperty.ToneTime
                    startTimeLift(examinedInds(currentTraj)) = findClosestDouble(t, t(e_loc(1)) - 0.5);
                    endTimeLift(examinedInds(currentTraj)) = findClosestDouble(t, t(e_loc(1)) + 0.5);
                    lift_index(examinedInds(currentTraj)) = 1;

                    sum_front_lift(examinedInds(currentTraj)) = emd_calc(trajAvarage(1:2, startTimeLift(examinedInds(currentTraj)):endTimeLift(examinedInds(currentTraj)))',...
                        BehaveData.traj.data(1:2, startTimeLift(examinedInds(currentTraj)):endTimeLift(examinedInds(currentTraj)), examinedInds(currentTraj))');

                    sum_side_lift(examinedInds(currentTraj)) = emd_calc(trajAvarage(3:4, startTimeLift(examinedInds(currentTraj)):endTimeLift(examinedInds(currentTraj)))',...
                        BehaveData.traj.data(3:4, startTimeLift(examinedInds(currentTraj)):endTimeLift(examinedInds(currentTraj)), examinedInds(currentTraj))');
                    break;
                end
            else
                break;
            end
         end                     
    end
      
    
%     successtrials = find(labels==find(contains(labelsLUT, 'success')));
%     failtrials = find(labels==find(contains(labelsLUT, 'failure')));
%     
%     successtrials=setdiff(successtrials, max(examinedInds));
%     failtrials=setdiff(failtrials, max(examinedInds));
% 
%     prev_suc = successtrials+1;
%     prev_fail = failtrials+1;
%     
%     s_labels_index = zeros(1, max(examinedInds));
%     f_labels_index = zeros(1, max(examinedInds));
%     
%     s_labels_index(examinedInds(labels == find(contains(labelsLUT, 'success')))) = 1;
%     f_labels_index(examinedInds(labels == find(contains(labelsLUT, 'failure')))) = 1;
% %    
% %     s_labels_index(prev_suc) = 1;
% %     f_labels_index(prev_fail) = 1;
%    
%     
%     combS_tr = tr_index & s_labels_index;    
%     combF_tr = tr_index & f_labels_index;
%     
%     combS_lift = lift_index & s_labels_index;    
%     combF_lift = lift_index & f_labels_index;
%    
%     
%     figSF_front_zero = figure;
%     hold on;
%     scatter(find(combS_tr == 1), sum_front_zero(combS_tr == 1), 'blue');
%     scatter(find(combF_tr == 1), sum_front_zero(combF_tr == 1), 'red');
%     title('PeriTime 1sec Zero Front');
%     xlabel('Trial#');
%     ylabel('EMD from average');
%     mysave(figSF_front_zero, fullfile(outputPath, ['TrajPlotResultsZeroFront']));
% 
%     figSF_side_zero = figure;
%     hold on;
%     scatter(find(combS_tr == 1), sum_side_zero(combS_tr == 1), 'blue');
%     scatter(find(combF_tr == 1), sum_side_zero(combF_tr == 1), 'red');
%     title('PeriTime 1sec Zero Side');
%     xlabel('Trial#');
%     ylabel('EMD from average');
%     mysave(figSF_side_zero, fullfile(outputPath, ['TrajPlotResultsZeroSide']));
% 
%     figSF_front_tone = figure;
%     hold on;
%     scatter(find(combS_tr == 1), sum_front_tone(combS_tr == 1), 'blue');
%     scatter(find(combF_tr == 1), sum_front_tone(combF_tr == 1), 'red');
%     title('PeriTime 1sec Tone Front');
%     xlabel('Trial#');
%     ylabel('EMD from average');
%     mysave(figSF_front_tone, fullfile(outputPath, ['TrajPlotResultsToneFront']));
% 
%     figSF_side_tone = figure;
%     hold on;
%     scatter(find(combS_tr == 1), sum_side_tone(combS_tr == 1), 'blue');
%     scatter(find(combF_tr == 1), sum_side_tone(combF_tr == 1), 'red');
%     title('PeriTime 1sec Tone Side');
%     xlabel('Trial#');
%     ylabel('EMD from average');
%     mysave(figSF_side_tone, fullfile(outputPath, ['TrajPlotResultsToneSide']));
%     
%     figSF_front_lift = figure;
%     hold on;
%     scatter(find(combS_lift == 1), sum_front_lift(combS_lift == 1), 'blue');
%     scatter(find(combF_lift == 1), sum_front_lift(combF_lift == 1), 'red');
%     title('PeriTime 1sec Lift Front');
%     xlabel('Trial#');
%     ylabel('EMD from average');
%     mysave(figSF_front_lift, fullfile(outputPath, ['TrajPlotResultsLiftFront']));
% 
%     figSF_side_lift = figure;
%     hold on;
%     scatter(find(combS_lift == 1), sum_side_lift(combS_lift == 1), 'blue');
%     scatter(find(combF_lift == 1), sum_side_lift(combF_lift == 1), 'red');
%     title('PeriTime 1sec Lift Side');
%     xlabel('Trial#');
%     ylabel('EMD from average');
%     mysave(figSF_side_lift, fullfile(outputPath, ['TrajPlotResultsLiftSide']));
%     
    for i = 0:length(labelsLUT)  
        if i == 0
            labelName = 'All';
            examinedIndsToRun = examinedInds;
        else
            labelName = labelsLUT{i};
            examinedIndsToRun = examinedInds(labels == i);
        end
        
        location_index_label = zeros(1, max(examinedInds));
        location_index_label(examinedIndsToRun) = 1;
        
        comb_location_tr = tr_index & location_index_label;
        comb_location_lift = lift_index & location_index_label;
        
        avg_front_zero = mean(sum_front_zero(comb_location_tr == 1));
        avg_side_zero = mean(sum_side_zero(comb_location_tr == 1));
        avg_front_tone = mean(sum_front_tone(comb_location_tr == 1));
        avg_side_tone = mean(sum_side_tone(comb_location_tr == 1));
        avg_front_lift = mean(sum_front_lift(comb_location_lift == 1));
        avg_side_lift = mean(sum_side_lift(comb_location_lift == 1));

        std_front_zero = std(sum_front_zero(comb_location_tr == 1)) ./ sqrt(sum(comb_location_tr));
        std_side_zero = std(sum_side_zero(comb_location_tr == 1))  ./ sqrt(sum(comb_location_tr));
        std_front_tone = std(sum_front_tone(comb_location_tr == 1))  ./ sqrt(sum(comb_location_tr));
        std_side_tone = std(sum_side_tone(comb_location_tr == 1))  ./ sqrt(sum(comb_location_tr));
        std_front_lift = std(sum_front_lift(comb_location_lift == 1))  ./ sqrt(sum(comb_location_lift));
        std_side_lift = std(sum_side_lift(comb_location_lift == 1))  ./ sqrt(sum(comb_location_lift));

       save(fullfile(outputPath, ['resultsFileEMD_MAT', labelName '.mat']), 'sum_front_zero', 'sum_side_zero', ...
            'sum_front_tone', 'sum_side_tone', 'sum_front_lift', 'sum_side_lift', 'comb_location_tr', 'comb_location_lift');
       
        
        save(fullfile(outputPath, ['resultsFileEMD', labelName '.mat']), 'avg_front_zero', 'avg_side_zero', ...
            'avg_front_tone', 'avg_side_tone', 'avg_front_lift', 'avg_side_lift');
        
        % Plot Results
        
        % Zero
        figZeroFront = figure;
        hold on;
        histfit(sum_front_zero(comb_location_tr == 1));
        title('PeriTime 1sec Zero Front');
        mysave(figZeroFront, fullfile(outputPath, ['TrajCompareResultsZeroFront_' labelName]));
       
        figZeroSide = figure;
        hold on;
        histfit(sum_side_zero(comb_location_tr == 1));
        title('PeriTime 1sec Zero Side');
        mysave(figZeroSide, fullfile(outputPath, ['TrajCompareResultsZeroSide_' labelName]));
               
        % Tone
        figToneFront = figure;
        hold on;
        histfit(sum_front_tone(comb_location_tr == 1));     
%         shadedErrorBar(1:trajSize, sum_front_tone, ones(trajSize, 1) * std_front_tone);
%         xlabel('Trial#');
%         ylabel('EMD from average traj');
        title('PeriTime 1sec Tone Front');
        mysave(figToneFront, fullfile(outputPath, ['TrajCompareResultsToneFront_' labelName]));
       
        figToneSide = figure;
        hold on;
        histfit(sum_side_tone(comb_location_tr == 1));
        title('PeriTime 1sec Tone Side');
        mysave(figToneSide, fullfile(outputPath, ['TrajCompareResultsToneSide_' labelName]));
       
        % Lift first after tone
        figLiftFront = figure;
        hold on;
%         liftAvglength = length(find(lift_index == 1));
        histfit(sum_front_lift(comb_location_lift == 1));
        title('PeriTime 1sec Lift Front');
        mysave(figLiftFront, fullfile(outputPath, ['TrajCompareResultsLiftFront_' labelName]));
       
        figLiftSide = figure;
        hold on;
        histfit(sum_side_lift(comb_location_lift == 1));
        
        title('PeriTime 1sec Lift Side');
        mysave(figLiftSide, fullfile(outputPath, ['TrajCompareResultsLiftSide_' labelName]));
              
        
        %Box Plot
        figBox = figure;
        hold on;
        
        boxplot([sum_front_zero(comb_location_tr == 1)', sum_side_zero(comb_location_tr == 1)'...
            ,sum_front_tone(comb_location_tr == 1)', sum_side_tone(comb_location_tr == 1)'], ...
            'Labels',{'FrontZero','SideZero', 'FrontTone', 'SideTone'})
        title({'Traj Compare Results PeriTime 1 sec Tone\Zero', labelName})  
        
        mysave(figBox, fullfile(outputPath, ['TrajCompareResultsBox_Tone_Zero' labelName]));
        
        figBox2 = figure;
        hold on;
        
        boxplot([sum_front_lift(comb_location_lift == 1)', sum_side_lift(comb_location_lift == 1)'], ...
            'Labels',{'FrontLift','SideLift'})
        title({'Traj Compare Results PeriTime 1 sec Lift', labelName})  
        
        mysave(figBox2, fullfile(outputPath, ['TrajCompareResultsBox_Lift' labelName]));
        
        
        tableSave = table(avg_front_zero, std_front_zero, avg_side_zero, std_side_zero, avg_front_tone, std_front_tone, avg_side_tone, std_side_tone, ...
            avg_front_lift, std_front_lift, avg_side_lift, std_side_lift, ...
            'VariableNames',  {'Front_Zero_PeriTime_std', 'Front_Zero_PeriTime_std_mean_error', 'Side_Zero_PeriTime_std',...
            'Side_Zero_PeriTime_std_mean_error', 'Front_Tone_PeriTime_std', 'Front_Tone_PeriTime_std_mean_error', 'Side_Tone_PeriTime_std' , 'Side_Tone_PeriTime_std_mean_error',...
            'Front_lift_PeriTime_std', 'Front_lift_PeriTime_std_mean_error', 'Side_lift_PeriTime_std', 'Side_lift_PeriTime_std_mean_error'});
        writetable(tableSave,[outputPath '\' labelName '_compareResults.xlsx'],'Sheet',1,'Range','D1')
    end
end
