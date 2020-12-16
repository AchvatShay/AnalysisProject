function eventsTimeDiffAnalysis(outputPath, generalProperty, imagingData, BehaveData)
   
    NAMES_BEHAVE = fields(BehaveData);
    
    [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
        generalProperty.labels2cluster, generalProperty.includeOmissions);
    
    t = linspace(0, generalProperty.Duration, size(imagingData.samples,2));
     
    toneTimeIndex = findClosestDouble(t, generalProperty.ToneTime);
    toneTime = t(toneTimeIndex);
    
    [~, ~, excelDataRaw] = xlsread('TmpEventsCompare.xlsx');
          
    [lineIndexSet, compareCol] = find(strcmp(excelDataRaw, 'Compare'));    

    for ru = 0:length(labelsLUT)
        if ru == 0
            labelName = 'All';
            examinedIndsToRun = examinedInds;
        else
            labelName = labelsLUT{ru};
            examinedIndsToRun = examinedInds(labels == ru);
        end

        lineIndex = lineIndexSet + 1;  
        startTimeCompare = ones(1, max(examinedIndsToRun)) * toneTime;
        startTimeCompareLabel = 'Tone';
        trailsCounterPrev = ones(1, max(examinedIndsToRun));
        for gE = 1:(length(generalProperty.eventsTimeDiffEvents))
            firstEvent = generalProperty.eventsTimeDiffEvents{gE};

            [~, currentCol] = find(strcmp(excelDataRaw, labelName));    

            toneToFirstSum = zeros(1, max(examinedIndsToRun));

            trialsCounterF = zeros(1, max(examinedIndsToRun));

            firstEvents = NAMES_BEHAVE(contains(NAMES_BEHAVE, firstEvent));           
            
            for trailsIndex = 1:length(examinedIndsToRun)  
                for firstIndex = 1:length(firstEvents)
                    e_loc = BehaveData.(firstEvents{firstIndex}).eventTimeStamps{examinedIndsToRun(trailsIndex)};
                    if ~isempty(e_loc)
                        if t(e_loc(1)) >= startTimeCompare(examinedIndsToRun(trailsIndex))
                            toneToFirstSum(examinedIndsToRun(trailsIndex)) = abs(t(e_loc(1)) - startTimeCompare(examinedIndsToRun(trailsIndex)));
                            trialsCounterF(examinedIndsToRun(trailsIndex)) = 1;       
                            startTimeCompare(examinedIndsToRun(trailsIndex)) = t(e_loc(1));

                            break;
                        end
                    else
                        break;
                    end
                end 

            end
            
            indexCounterComb = (trailsCounterPrev == 1 & trialsCounterF == 1);
            figBox2 = figure;
            hold on;

            boxplot(toneToFirstSum(indexCounterComb)', ...
                'Labels',{[startTimeCompareLabel '-' firstEvent]})
            title({'Compare Events Diff first after tone', labelName})  
            ylabel('Event diff sec');
            ylim([-0.5, 2]);
            mysave(figBox2, fullfile(outputPath, ['Box_Compare_' firstEvent startTimeCompareLabel '_' labelName]));

            excelDataRaw{lineIndex, compareCol} = [firstEvent '-' startTimeCompareLabel ' average'];
            excelDataRaw{lineIndex, currentCol} = sum(toneToFirstSum(indexCounterComb)) ./ sum(indexCounterComb);
            lineIndex = lineIndex + 1;

            excelDataRaw{lineIndex, compareCol} = [firstEvent '-' startTimeCompareLabel ' std'];
            stdtonetoift = std(toneToFirstSum(indexCounterComb));
            excelDataRaw{lineIndex, currentCol} = stdtonetoift;
            lineIndex = lineIndex + 1;

           
            [h_T2L,p_T2L,ci_T2L,~] = ttest(toneToFirstSum(indexCounterComb));
           
            excelDataRaw{lineIndex, compareCol} = [firstEvent '-' startTimeCompareLabel ' ttest h = 1 reject null hypothesis'];
            excelDataRaw{lineIndex, currentCol} = h_T2L;
            lineIndex = lineIndex + 1;

            excelDataRaw{lineIndex, compareCol} = [firstEvent '-' startTimeCompareLabel ' ttest p-value'];
            excelDataRaw{lineIndex, currentCol} = p_T2L;
            lineIndex = lineIndex + 1;

            excelDataRaw{lineIndex, compareCol} = [firstEvent '-' startTimeCompareLabel ' ttest confidence interval '];
            excelDataRaw{lineIndex, currentCol} = sprintf('%f-%f', ci_T2L(1), ci_T2L(2));
            lineIndex = lineIndex + 1;  
 
            save(fullfile(outputPath, ['mat_results_Compare_' firstEvent startTimeCompareLabel '_' labelName]), 'toneToFirstSum', 'indexCounterComb');
            startTimeCompareLabel = firstEvent;
            trailsCounterPrev = trialsCounterF;
        end
        
    end
      
    filenameExcel = fullfile(outputPath, ['EventsTimeDiff_analysisResults_' cell2mat(generalProperty.eventsTimeDiffEvents) '.xlsx']);
    xlswrite(filenameExcel,excelDataRaw);
end