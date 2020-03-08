function eventsCountHis(outputPath, generalProperty, imagingData, BehaveData)
    [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
        generalProperty.labels2cluster, generalProperty.includeOmissions);

     classes = unique(labels);
    
     
    allTrailsIndex = 1:size(imagingData.samples, 3);
    
    examinedIndsResults = getTrialsIndexAccordingToString(generalProperty.trailsToRun, allTrailsIndex);
    
    labels = labels(sum(examinedInds == allTrailsIndex(examinedIndsResults == 1), 2) == 1);
    examinedInds = examinedInds(sum(examinedInds == allTrailsIndex(examinedIndsResults == 1), 2) == 1);
    
     
     toneTime = generalProperty.ToneTime;
     t = linspace(0, generalProperty.Duration, size(imagingData.samples,2));
     
     for event_current = 1:length(generalProperty.Events2plot)
        eventNameCurrent = generalProperty.Events2plot{event_current};
        
        trails_events_count = zeros(1, length(examinedInds));

         NAMES_BEHAVE = fields(BehaveData);
         currentEvents = NAMES_BEHAVE(contains(NAMES_BEHAVE, eventNameCurrent));

         for trailsHisIndex = 1:length(examinedInds)
             for i = 1:length(currentEvents)
                sumTrailCurrentEvent = double(sum(BehaveData.(currentEvents{i}).indicator(examinedInds(trailsHisIndex), t >= generalProperty.startTimeGrabCountHis & t<= generalProperty.endTimeGrabCountHis)) > 0);

                trails_events_count(trailsHisIndex) = trails_events_count(trailsHisIndex) + sumTrailCurrentEvent;
             end          
         end

         % plot hist
         no_trials_event_count = trails_events_count(trails_events_count ~= 0);
         uv = unique(no_trials_event_count);
         precentageEventCount  = (histc(no_trials_event_count,uv) ./ length(no_trials_event_count)) *100;

         fig1 = figure;
         hold on;
         bar(uv,precentageEventCount, 0.95)
         xlabel([eventNameCurrent ' count']);
         ylabel('trials %');
         title(['All Trials ' eventNameCurrent ' count precentage, trials count -' num2str(length(no_trials_event_count))]);
         mysave(fig1, fullfile(outputPath, ['hist_' eventNameCurrent '_trials_precentage']));

         successEventCurr = trails_events_count(labels==classes(strcmp(labelsLUT, generalProperty.successLabel)));

         no_zeros_se = successEventCurr(successEventCurr ~= 0);
         uvS = unique(no_zeros_se);
         precentageEventCountS  = (histc(no_zeros_se,uvS) ./ length(no_zeros_se)) *100;

         fig3 = figure;
         hold on;
         bar(uvS,precentageEventCountS,0.95)
         xlabel([eventNameCurrent ' count']);
         ylabel('trials %');
         title(['Success Trials ' eventNameCurrent ' count precentage, trials count -' num2str(length(no_zeros_se))]);
         mysave(fig3, fullfile(outputPath, ['hist_' eventNameCurrent '_Strials_precentage']));

         failureEventCurr = trails_events_count(labels==classes(strcmp(labelsLUT, generalProperty.failureLabel)));

         no_zeros_fe = failureEventCurr(failureEventCurr ~= 0);
         uvF = unique(no_zeros_fe);
         precentageEventCountF  = (histc(no_zeros_fe,uvF) ./ length(no_zeros_fe)) *100;

         fig4 = figure;
         hold on;
         bar(uvF,precentageEventCountF,0.95)
         xlabel([eventNameCurrent ' count']);
         ylabel('trials %');
         title(['Failure Trials ' eventNameCurrent ' count precentage, trials count -' num2str(length(no_zeros_fe))]);
         mysave(fig4, fullfile(outputPath, ['hist_' eventNameCurrent '_Ftrials_precentage']));

         meanS = mean(no_zeros_se);
         stdS = std(no_zeros_se);

         meanF = mean(no_zeros_fe);
         stdF = std(no_zeros_fe);   

         fig2 = figure;
         hold on;
         c = categorical({[generalProperty.successLabel, ' (', num2str(length(no_zeros_se)), ')'],[generalProperty.failureLabel, ' (', num2str(length(no_zeros_fe)), ')']});
         bar(c, [meanS, meanF], 0.5);
         er = errorbar(c, [meanS, meanF],[stdS, stdF]);  


         [h_s,p_s,ci_s,~]  = ttest2(no_zeros_se, no_zeros_fe);

         xlabel('labels#');
         ylabel([eventNameCurrent ' avg.']);
         title({['S-F Trials ' eventNameCurrent ' Average, '], ['success: mean= ', num2str(meanS), ' ,std=', num2str(stdS)] , [' failure: mean= ' num2str(meanF), ' ,std=' num2str(stdF)], ...
             });
    % ['ttest success : ', num2str(t_test_s), 'ttest failure : ', num2str(t_test_f)]
         mysave(fig2, fullfile(outputPath, ['SF_' eventNameCurrent '_trials_average']));

        fileID = fopen([outputPath, '\ttest_S_vs_F_' eventNameCurrent '.txt'],'w');
        fprintf(fileID,'h=%f p=%f ci=[%f, %f] \n', h_s, p_s, ci_s(1), ci_s(2));
        fclose(fileID);
     
     end
     
end