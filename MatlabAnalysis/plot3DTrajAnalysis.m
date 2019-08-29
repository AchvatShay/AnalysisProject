function plot3DTrajAnalysis(outputPath, generalProperty, imagingData, BehaveData)
    [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
        generalProperty.labels2cluster, generalProperty.includeOmissions);
    frameRateRatio = generalProperty.BehavioralSamplingRate/generalProperty.ImagingSamplingRate;
    classes = unique(labels);
    
    allTrailsIndex = 1:size(imagingData.samples, 3);
    
    examinedIndsResults = getTrialsIndexAccordingToString(generalProperty.trailsToRun, allTrailsIndex);
    
    labels = labels(sum(examinedInds == allTrailsIndex(examinedIndsResults == 1), 2) == 1);
    examinedInds = examinedInds(sum(examinedInds == allTrailsIndex(examinedIndsResults == 1), 2) == 1);
    
    t = linspace(0, generalProperty.Duration, size(BehaveData.traj.data, 2));    
    tone = generalProperty.ToneTime;
    
    NAMES_BEHAVE = fields(BehaveData);

    BehaveData.traj.dataOriginal(1:2, :, :) = BehaveData.traj.data(1:2, :, :);
    
    for event_i = 1:length(generalProperty.traj3DLabels)
        eventsL{event_i} = NAMES_BEHAVE(contains(NAMES_BEHAVE, generalProperty.traj3DLabels{event_i}));
    end
    
     for index_events = 0:length(classes)
        if index_events == 0
            trails_list = examinedInds;
            eventName = 'all';
        else
            trails_list = examinedInds(labels==classes(index_events));
            eventName = labelsLUT{index_events};
        end
        
        fig = figure;
%         hold on;
%         set(fig,'Units','normalized')

         axes1 = axes('Parent',fig);
         hold(axes1,'on');   
        view(3);
         grid(axes1,'on');
        axis(axes1,'ij');

        set(axes1,'ZDir','reverse');
% 
        xlim([0 600]);
%         ylim([-50 400]);
%         zlim([-50 150]);
         
        h = zeros(size(generalProperty.traj3DColors,1),1);
        for colorIndex = 1:length(generalProperty.traj3DColors)
            h(colorIndex) = plot(NaN,NaN,'color',generalProperty.traj3DColors{colorIndex});
        end

        leg = legend(h, generalProperty.traj3DLabels);
%         legend(axes1, 'show');

        set(leg,'Position', [0.1 + 0.1, 0.1 - 0.25, 0.05, 0.05])
        
        BehaveData.traj.data(1:2, :, :) = BehaveData.traj.dataOriginal(1:2, :, :) - 400; 

        for trails_i = 1:length(trails_list)
%             BehaveData.traj.data(1,framesSelected,trails_list(trails_i)) = BehaveData.traj.data(1,framesSelected,trails_list(trails_i)) - 400;
%             BehaveData.traj.data(1,framesSelected,trails_list(trails_i)) = BehaveData.traj.data(1,framesSelected,trails_list(trails_i)) - BehaveData.traj.data(1,framesSelected(1),trails_list(trails_i));
%             BehaveData.traj.data(3,framesSelected,trails_list(trails_i)) = BehaveData.traj.data(3,framesSelected,trails_list(trails_i)) - BehaveData.traj.data(3,framesSelected(1),trails_list(trails_i));
%             BehaveData.traj.data(4,framesSelected,trails_list(trails_i)) = BehaveData.traj.data(4,framesSelected,trails_list(trails_i)) - BehaveData.traj.data(4,framesSelected(1),trails_list(trails_i)); 
%             
            framesSelected = findClosestDouble(t, generalProperty.traj3D_startTime) : findClosestDouble(t,generalProperty.traj3D_endTime);
    
            indexAcordingToLikelyhood = BehaveData.traj.data(5, framesSelected, trails_list(trails_i)) < 0.9 | BehaveData.traj.data(6, framesSelected, trails_list(trails_i)) < 0.9;            
            framesSelected(indexAcordingToLikelyhood) = [];
            
            plot3(axes1, BehaveData.traj.data(1, framesSelected, trails_list(trails_i)), BehaveData.traj.data(3, framesSelected, trails_list(trails_i)),  BehaveData.traj.data(4, framesSelected, trails_list(trails_i)),'color', 'black', 'LineWidth', 2.0, 'HandleVisibility','off');
%             hold on;
            for event_i = 1:length(eventsL)
               for index = 1:length(eventsL{event_i})
                    locationI = BehaveData.(eventsL{event_i}{index}).eventTimeStamps{trails_list(trails_i)};
                    locationI = round((locationI .* frameRateRatio) + generalProperty.BehavioralDelay); 
                    
                    if (isempty(locationI))
                        continue;
                    end
                    
                    locationI = locationI(1):locationI(2);
                    locationI = locationI(locationI <= framesSelected(end) & locationI >= framesSelected(1)); 
                    indexAcordingToLikelyhood = BehaveData.traj.data(5, locationI, trails_list(trails_i)) < 0.9 | BehaveData.traj.data(6, locationI, trails_list(trails_i)) < 0.9;            
                    locationI(indexAcordingToLikelyhood) = [];
                    
                    if (~isempty(locationI)) 
                        plot3(axes1, BehaveData.traj.data(1, locationI, trails_list(trails_i)),  BehaveData.traj.data(3, locationI, trails_list(trails_i)), BehaveData.traj.data(4, locationI, trails_list(trails_i)),'color', generalProperty.traj3DColors{event_i}, 'LineWidth', 2.0, 'HandleVisibility','off');
%                         hold all;
                    end
                end

           end
        end 
        
        mysave(gcf, fullfile(outputPath, ['traj_alltrials_colors_noavg_event_'  eventName]));                
        
        fig = figure;
%         hold on;
%         set(fig,'Units','normalized')

         axes1 = axes('Parent',fig);
         hold(axes1,'on');   
        view(3);
         grid(axes1,'on');
        axis(axes1,'ij');

        set(axes1,'ZDir','reverse');
% 
        xlim([0 600]);

       
%         xlim([-100 300]);
%         ylim([-50 400]);
%         zlim([-50 150]);
        
%         set(leg,'Position', [0.1 + 0.1, 0.1 - 0.25, 0.05, 0.05])
%         legend(axes1, 'show');
        framesSelected = findClosestDouble(t, generalProperty.traj3D_startTime) : findClosestDouble(t,generalProperty.traj3D_endTime);
        indexAcordingToLikelyhood = [];
        indexAcordingToLikelyhood(:, :, :) = BehaveData.traj.data(5, framesSelected, trails_list) < 0.9 | BehaveData.traj.data(6, framesSelected, trails_list) < 0.9;            
        results = sum(indexAcordingToLikelyhood, 3);
        
        framesSelected(results > 0) = [];
            
        plot3(squeeze(BehaveData.traj.data(1,framesSelected,trails_list)),squeeze(BehaveData.traj.data(3,framesSelected,trails_list)),squeeze(BehaveData.traj.data(4,framesSelected,trails_list)),'blue');
        plot3(mean(BehaveData.traj.data(1,framesSelected,trails_list),3),mean(BehaveData.traj.data(3,framesSelected,trails_list),3),mean(BehaveData.traj.data(4,framesSelected,trails_list),3),'k', 'LineWidth', 2)
        
        mysave(gcf, fullfile(outputPath, ['traj_alltrials_nocolors_avg_event_'  eventName]));                
        indexAcordingToLikelyhood = [];
     end
end