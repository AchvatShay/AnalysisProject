function grabsCountHis(outputPath, generalProperty, imagingData, BehaveData)
    [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
        generalProperty.labels2cluster, generalProperty.includeOmissions);

     classes = unique(labels);
    
     
    allTrailsIndex = 1:size(imagingData.samples, 3);
    
    examinedIndsResults = getTrialsIndexAccordingToString(generalProperty.trailsToRun, allTrailsIndex);
    
    labels = labels(sum(examinedInds == allTrailsIndex(examinedIndsResults == 1), 2) == 1);
    examinedInds = examinedInds(sum(examinedInds == allTrailsIndex(examinedIndsResults == 1), 2) == 1);
    
     
     toneTime = generalProperty.ToneTime;
     t = linspace(0, generalProperty.Duration, size(imagingData.samples,2));
     
     trails_grabs_count = zeros(1, length(examinedInds));
     
     NAMES_BEHAVE = fields(BehaveData);
     grabsEvents = NAMES_BEHAVE(contains(NAMES_BEHAVE, 'grab'));
     
     for trailsHisIndex = 1:length(examinedInds)
         for i = 1:length(grabsEvents)
            sumTrailCurrentEvent = double(sum(BehaveData.(grabsEvents{i}).indicator(examinedInds(trailsHisIndex), t >= generalProperty.startTimeGrabCountHis & t<= generalProperty.endTimeGrabCountHis)) > 0);

            trails_grabs_count(trailsHisIndex) = trails_grabs_count(trailsHisIndex) + sumTrailCurrentEvent;
         end          
     end
     
     % plot hist
     no_trials_grabs_count = trails_grabs_count(trails_grabs_count ~= 0);
     uv = unique(no_trials_grabs_count);
     precentageGrabsCount  = (histc(no_trials_grabs_count,uv) ./ length(no_trials_grabs_count)) *100;
     
     fig1 = figure;
     hold on;
     bar(uv,precentageGrabsCount, 0.95)
     xlabel('grabs count');
     ylabel('trials %');
     title(['All Trials Grabs count precentage, trials count -' num2str(length(no_trials_grabs_count))]);
     mysave(fig1, fullfile(outputPath, 'hist_grabs_trials_precentage'));

     successGrabs = trails_grabs_count(labels==classes(strcmp(labelsLUT, generalProperty.successLabel)));
     
     no_zeros_sg = successGrabs(successGrabs ~= 0);
     uvS = unique(no_zeros_sg);
     precentageGrabsCountS  = (histc(no_zeros_sg,uvS) ./ length(no_zeros_sg)) *100;
     
     fig3 = figure;
     hold on;
     bar(uvS,precentageGrabsCountS,0.95)
     xlabel('grabs count');
     ylabel('trials %');
     title(['Success Trials Grabs count precentage, trials count -' num2str(length(no_zeros_sg))]);
     mysave(fig3, fullfile(outputPath, 'hist_grabs_Strials_precentage'));
     
     failureGrabs = trails_grabs_count(labels==classes(strcmp(labelsLUT, generalProperty.failureLabel)));
     
     no_zeros_fg = failureGrabs(failureGrabs ~= 0);
     uvF = unique(no_zeros_fg);
     precentageGrabsCountF  = (histc(no_zeros_fg,uvF) ./ length(no_zeros_fg)) *100;
     
     fig4 = figure;
     hold on;
     bar(uvF,precentageGrabsCountF,0.95)
     xlabel('grabs count');
     ylabel('trials %');
     title(['Failure Trials Grabs count precentage, trials count -' num2str(length(no_zeros_fg))]);
     mysave(fig4, fullfile(outputPath, 'hist_grabs_Ftrials_precentage'));
     
     meanS = mean(no_zeros_sg);
     stdS = std(no_zeros_sg);
       
     meanF = mean(no_zeros_fg);
     stdF = std(no_zeros_fg);   
     
     fig2 = figure;
     hold on;
     c = categorical({[generalProperty.successLabel, ' (', num2str(length(no_zeros_sg)), ')'],[generalProperty.failureLabel, ' (', num2str(length(no_zeros_fg)), ')']});
     bar(c, [meanS, meanF], 0.5);
     er = errorbar(c, [meanS, meanF],[stdS, stdF]);  
     
     
     [h_s,p_s,ci_s,~]  = ttest2(no_zeros_sg, no_zeros_fg);
     
     xlabel('labels#');
     ylabel('grabs avg.');
     title({'S-F Trials Grabs Average, ', ['success: mean= ', num2str(meanS), ' ,std=', num2str(stdS)] , [' failure: mean= ' num2str(meanF), ' ,std=' num2str(stdF)], ...
         });
% ['ttest success : ', num2str(t_test_s), 'ttest failure : ', num2str(t_test_f)]
     mysave(fig2, fullfile(outputPath, 'SF_grabs_trials_average'));

    fileID = fopen([outputPath, '\ttest_S_vs_F.txt'],'w');
    fprintf(fileID,'h=%f p=%f ci=[%f, %f] \n', h_s, p_s, ci_s(1), ci_s(2));
    fclose(fileID);
end