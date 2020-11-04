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
        
        startEventTime = ones(1, max(examinedIndsToRun)) * toneTime;
        
        if (~strcmp(generalProperty.behaveTimeDiff{1}, 'tone'))
            fEvents = NAMES_BEHAVE(contains(NAMES_BEHAVE, generalProperty.behaveTimeDiff{1}));
            
            for trailsIndex = 1:length(examinedIndsToRun)          
                for liftIndex = 1:length(fEvents)
                    e_loc = BehaveData.(fEvents{liftIndex}).eventTimeStamps{examinedIndsToRun(trailsIndex)};
                    if ~isempty(e_loc) 
                        if t(e_loc(1)) >= toneTime
                            startEventTime(examinedIndsToRun(trailsIndex)) = t(e_loc(1));
                            break;
                        end
                    else
                        break;
                    end
                end
            end
        end
        
        liftEvents = NAMES_BEHAVE(contains(NAMES_BEHAVE, generalProperty.behaveTimeDiff{2}));
        grabEvents = NAMES_BEHAVE(contains(NAMES_BEHAVE, generalProperty.behaveTimeDiff{3}));
        
        for trailsIndex = 1:length(examinedIndsToRun)          
            for liftIndex = 1:length(liftEvents)
                e_loc = BehaveData.(liftEvents{liftIndex}).eventTimeStamps{examinedIndsToRun(trailsIndex)};
                if ~isempty(e_loc)
                    if t(e_loc(1)) >= startEventTime(examinedIndsToRun(trailsIndex))
                        for grabIndex = 1:length(grabEvents)
                            e2_loc = BehaveData.(grabEvents{grabIndex}).eventTimeStamps{examinedIndsToRun(trailsIndex)};
                            
                            if ~isempty(e2_loc)
                                if t(e2_loc(1)) >= startEventTime(examinedIndsToRun(trailsIndex)) && t(e2_loc(1)) >= t(e_loc(1))
                                    toneToliftSum(examinedIndsToRun(trailsIndex)) = abs(t(e_loc(1)) - startEventTime(examinedIndsToRun(trailsIndex)));
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
            'Labels',{sprintf('%s-%s', generalProperty.behaveTimeDiff{1}, generalProperty.behaveTimeDiff{2}),...
            sprintf('%s-%s', generalProperty.behaveTimeDiff{2}, generalProperty.behaveTimeDiff{3})})
        title({'Compare Events Diff', labelName, sprintf('trails number %d', trialsCounter)})  
        
        mysave(figBox2, fullfile(outputPath, ['Box_Compare' labelName, generalProperty.behaveTimeDiff{2}, generalProperty.behaveTimeDiff{3}]));
   
        
        excelDataRaw{lineIndex, compareCol} = sprintf('%s-%s', generalProperty.behaveTimeDiff{1}, generalProperty.behaveTimeDiff{2});
        excelDataRaw{lineIndex, currentCol} = sum(toneToliftSum) ./ trialsCounter;
        lineIndex = lineIndex + 1;
                
        excelDataRaw{lineIndex, compareCol} = sprintf('%s-%s', generalProperty.behaveTimeDiff{2}, generalProperty.behaveTimeDiff{3});
        excelDataRaw{lineIndex, currentCol} = sum(liftToGrabSum) ./ trialsCounter;
    end
      
    filenameExcel = fullfile(outputPath, sprintf('EventsTimeDiff_analysisResults_%s_.xlsx', [generalProperty.behaveTimeDiff{2}, generalProperty.behaveTimeDiff{3}]));
    xlswrite(filenameExcel,excelDataRaw);
end