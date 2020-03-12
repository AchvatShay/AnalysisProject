function eventsTimeDiffAnalysis(outputPath, generalProperty, imagingData, BehaveData)
   
    NAMES_BEHAVE = fields(BehaveData);
    
    [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
        generalProperty.labels2cluster, generalProperty.includeOmissions);
    
    t = linspace(0, generalProperty.Duration, size(imagingData.samples,2));
    toneTime = t(findClosestDouble(t, generalProperty.ToneTime)); 
    
    [~, ~, excelDataRaw] = xlsread('TmpEventsCompare.xlsx');
        
    
%     trails_events_count(labels==classes(strcmp(labelsLUT, generalProperty.successLabel)));
    
    [lineIndexSet, compareCol] = find(strcmp(excelDataRaw, 'Compare'));    

    for i = 0:length(labelsLUT)
        if i == 0
            labelName = 'All';
            examinedIndsToRun = examinedInds;
        else
            labelName = labelsLUT{i};
            examinedIndsToRun = examinedInds(labels == i);
        end
        
        lineIndex = lineIndexSet + 1;  
       
        [~, currentCol] = find(strcmp(excelDataRaw, labelName));    

        toneToliftSum = zeros(1, max(examinedIndsToRun));
        liftToGrabSum = zeros(1, max(examinedIndsToRun));
        trialsCounter = 0;
        
        liftEvents = NAMES_BEHAVE(contains(NAMES_BEHAVE, 'lift'));
        grabEvents = NAMES_BEHAVE(contains(NAMES_BEHAVE, 'grab'));
        
        for trailsIndex = 1:length(examinedIndsToRun)          
            for liftIndex = 1:length(liftEvents)
                e_loc = BehaveData.(liftEvents{liftIndex}).eventTimeStamps{examinedIndsToRun(trailsIndex)};
                if ~isempty(e_loc)
                    if t(e_loc(1)) >= toneTime
                        for grabIndex = 1:length(grabEvents)
                            e2_loc = BehaveData.(grabEvents{grabIndex}).eventTimeStamps{examinedIndsToRun(trailsIndex)};
                            
                            if ~isempty(e_loc)
                                if t(e2_loc(1)) >= toneTime && t(e2_loc(1)) >= t(e_loc(1))
                                    toneToliftSum(examinedIndsToRun(trailsIndex)) = abs(t(e_loc(1)) - toneTime);
                                    liftToGrabSum(examinedIndsToRun(trailsIndex)) = abs(t(e_loc(1)) - t(e2_loc(1)));
                                    trialsCounter = trialsCounter + 1;
                                    
                                    break;
                                end
                            else
                                break;
                            end
                        end
                        
                        break;
                    end
                else
                    break;
                end
            end            
        end
        
        figBox2 = figure;
        hold on;
        
        boxplot([toneToliftSum', liftToGrabSum'], ...
            'Labels',{'Tone-Lift','Lift-Grab'})
        title({'Compare Events Diff', labelName})  
        
        mysave(figBox2, fullfile(outputPath, ['Box_Compare' labelName]));
   
        
        excelDataRaw{lineIndex, compareCol} = 'Lift-Tone';
        excelDataRaw{lineIndex, currentCol} = sum(toneToliftSum) ./ trialsCounter;
        lineIndex = lineIndex + 1;
                
        excelDataRaw{lineIndex, compareCol} = 'Lift-Grab';
        excelDataRaw{lineIndex, currentCol} = sum(liftToGrabSum) ./ trialsCounter;
    end
      
    filenameExcel = fullfile(outputPath, 'EventsTimeDiff_analysisResults.xlsx');
    xlswrite(filenameExcel,excelDataRaw);
end