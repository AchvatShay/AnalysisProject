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
    
    NAMES_BEHAVE = fields(BehaveData);
   
    for event_i = 1:length(generalProperty.traj3DLabels)
        eventsL{event_i} = NAMES_BEHAVE(contains(NAMES_BEHAVE, generalProperty.traj3DLabels{event_i}));
    end
    
        fig6 = figure;
        axes6 = axes('Parent',fig6);
        hold(axes6,'on');   
        view(3);
        grid(axes6,'on');
        axis(axes6,'ij');
        xlim([-50, 350]);
        ylim([-50, 350]);
        zlim([-200,50]);
        
        set(axes6,'ZDir','reverse');

        fig7 = figure;
        axes7 = axes('Parent',fig7);
        hold(axes7,'on');   
        grid(axes7,'on');
        axis(axes7,'ij');
        xlim([-50, 350]);
        ylim([-50, 350]);
        set(axes7,'YDir','normal');


        fig8 = figure;
        axes8 = axes('Parent',fig8);
        hold(axes8,'on');   
        grid(axes8,'on');
        axis(axes8,'ij');
        xlim([-50, 350]);
        ylim([-200,50]);
        
        fig9 = figure;
        axes9 = axes('Parent',fig9);
        hold(axes9,'on');   
        grid(axes9,'on');
        axis(axes9,'ij');
        xlim([-50, 350]);
        ylim([-200,50]);
        
       
     for index_events = 0:length(classes)
        if index_events == 0
            trails_list = examinedInds;
            eventName = 'all';
            eventColor = 'black';
        else
            trails_list = examinedInds(labels==classes(index_events));
            eventName = labelsLUT{index_events};
            eventColor = generalProperty.labels2clusterClrs{index_events}{1};
        end
        
        fig = figure;
        axes1 = axes('Parent',fig);
        hold(axes1,'on');   
        view(3);
        grid(axes1,'on');
        axis(axes1,'ij');
        xlim([-50, 350]);
        ylim([-50, 350]);
        zlim([-200,50]);
        
        set(axes1,'ZDir','reverse');

%         xlim([0 600]);
        
        fig2 = figure;
        axes2 = axes('Parent',fig2);
        hold(axes2,'on');   
        grid(axes2,'on');
        axis(axes2,'ij');
        xlim([-50, 350]);
        ylim([-50, 350]);
        set(axes2,'YDir','normal');


        fig3 = figure;
        axes3 = axes('Parent',fig3);
        hold(axes3,'on');   
        grid(axes3,'on');
        axis(axes3,'ij');
        xlim([-50, 350]);
        ylim([-200,50]);
        
        fig4 = figure;
        axes4 = axes('Parent',fig4);
        hold(axes4,'on');   
        grid(axes4,'on');
        axis(axes4,'ij');
        xlim([-50, 350]);
        ylim([-200,50]);
        
        fig5 = figure;
        axes5 = axes('Parent',fig5);
        hold(axes5,'on');   
        view(3);
        grid(axes5,'on');
        axis(axes5,'ij');
        xlim([-50, 350]);
        ylim([-50, 350]);
        zlim([-200,50]);
        
        set(axes5,'ZDir','reverse');        
%         xlim([0 600]);
     
        
        h = zeros(size(generalProperty.traj3DColors,1),1);
        for colorIndex = 1:length(generalProperty.traj3DColors)
            h(colorIndex) = plot(NaN,NaN,'color',generalProperty.traj3DColors{colorIndex});
        end

        leg = legend(h, generalProperty.traj3DLabels);
%         legend(axes1, 'show');

        set(leg,'Position', [0.1 + 0.1, 0.1 - 0.25, 0.05, 0.05])
        
        BehaveData.traj.data(1, :, :) = BehaveData.traj.data(1, :, :) - 400; 
        
        average_traj = zeros(3, 121);
        trailsincludscount = zeros(1, 121);
%         trailsincludscount = 0;
        
        for trails_i = 1:length(trails_list)
            
            alignedEvent = NAMES_BEHAVE(contains(NAMES_BEHAVE, 'lift'));
            startTimeIndex = findClosestDouble(t, generalProperty.traj3D_startTime);
            
%             framesSelected =  startTimeIndex : startTimeIndex + 150;
            framesSelected = [];
            for indexE = 1:length(alignedEvent)
                event_time = BehaveData.(alignedEvent{indexE}).eventTimeStamps{trails_list(trails_i)};
                event_time = round((event_time .* frameRateRatio) + generalProperty.BehavioralDelay); 
                    
                if (~isempty(event_time) && event_time(1) >= startTimeIndex && (event_time(1) + 120) <= size(BehaveData.traj.data, 2))
                    framesSelected = event_time(1) : (event_time(1) + 120);
                    break;
                end
            end
            
            if isempty(framesSelected)
                continue;
            end
            
            indexAcordingToLikelyhood = BehaveData.traj.data(5, framesSelected, trails_list(trails_i)) < 0.9 | BehaveData.traj.data(6, framesSelected, trails_list(trails_i)) < 0.9;            
            framesSelected(indexAcordingToLikelyhood) = [];
            
            if (isempty(framesSelected))
                continue;
            end
%             if sum(indexAcordingToLikelyhood) > 0
%                 continue;
%             else
%                 trailsincludscount = trailsincludscount + 1;
%             end
%             
            BehaveData.traj.data(1, :, trails_list(trails_i)) = BehaveData.traj.data(1, :, trails_list(trails_i)) - BehaveData.traj.data(1, framesSelected(1), trails_list(trails_i)); 
            BehaveData.traj.data(3, :, trails_list(trails_i)) = BehaveData.traj.data(3, :, trails_list(trails_i)) - BehaveData.traj.data(3, framesSelected(1), trails_list(trails_i)); 
            BehaveData.traj.data(4, :, trails_list(trails_i)) = BehaveData.traj.data(4, :, trails_list(trails_i)) - BehaveData.traj.data(4, framesSelected(1), trails_list(trails_i)); 
            
%             indexAcordingToLikelyhood = [];
%                     
%             indexAcordingToLikelyhood = BehaveData.traj.data(5, framesSelected, trails_list(trails_i)) < 0.9 | BehaveData.traj.data(6, framesSelected, trails_list(trails_i)) < 0.;            
            trailsincludscount(1:length(framesSelected)) = trailsincludscount(1:length(framesSelected)) + 1;
           
            average_traj(1, 1:length(framesSelected)) = average_traj(1, 1:length(framesSelected)) + BehaveData.traj.data(1, framesSelected, trails_list(trails_i));
            average_traj(2, 1:length(framesSelected)) = average_traj(2, 1:length(framesSelected)) + BehaveData.traj.data(3, framesSelected, trails_list(trails_i));
            average_traj(3, 1:length(framesSelected)) = average_traj(3, 1:length(framesSelected)) + BehaveData.traj.data(4, framesSelected, trails_list(trails_i));
           
            
            plot3(axes1, BehaveData.traj.data(1, framesSelected, trails_list(trails_i)), BehaveData.traj.data(3, framesSelected, trails_list(trails_i)),  BehaveData.traj.data(4, framesSelected, trails_list(trails_i)),'color', [0.3,0.3,0.3], 'LineWidth', 1.0, 'HandleVisibility','off');
            plot(axes2, BehaveData.traj.data(1, framesSelected, trails_list(trails_i)), BehaveData.traj.data(3, framesSelected, trails_list(trails_i)),'color', [0.3,0.3,0.3], 'LineWidth', 1.0, 'HandleVisibility','off');
            plot(axes3, BehaveData.traj.data(3, framesSelected, trails_list(trails_i)), BehaveData.traj.data(4, framesSelected, trails_list(trails_i)),'color', [0.3,0.3,0.3], 'LineWidth', 1.0, 'HandleVisibility','off');
            plot(axes4, BehaveData.traj.data(1, framesSelected, trails_list(trails_i)), BehaveData.traj.data(4, framesSelected, trails_list(trails_i)),'color', [0.3,0.3,0.3], 'LineWidth', 1.0, 'HandleVisibility','off');
            plot3(axes5, BehaveData.traj.data(1, framesSelected, trails_list(trails_i)), BehaveData.traj.data(3, framesSelected, trails_list(trails_i)),  BehaveData.traj.data(4, framesSelected, trails_list(trails_i)),'color', [0.3,0.3,0.3], 'LineWidth', 1.0, 'HandleVisibility','off');
           
            for event_i = 1:length(eventsL)
               for index = 1:length(eventsL{event_i})
%                     indexAcordingToLikelyhood = [];
                    locationI = BehaveData.(eventsL{event_i}{index}).eventTimeStamps{trails_list(trails_i)};
                    locationI = round((locationI .* frameRateRatio) + generalProperty.BehavioralDelay); 
                    
                    if (isempty(locationI))
                        continue;
                    end
                    
                    
                    locationI = locationI(1):locationI(2);
                    indexAcordingToLikelyhoodEvent = BehaveData.traj.data(5, locationI, trails_list(trails_i)) < 0.9 | BehaveData.traj.data(6, locationI, trails_list(trails_i)) < 0.9;
            
                    locationI(indexAcordingToLikelyhoodEvent) = [];
                    locationI = locationI(locationI <= framesSelected(end) & locationI >= framesSelected(1)); 
                    
                    if (~isempty(locationI)) 
                        plot3(axes1, BehaveData.traj.data(1, locationI, trails_list(trails_i)),  BehaveData.traj.data(3, locationI, trails_list(trails_i)), BehaveData.traj.data(4, locationI, trails_list(trails_i)),'color', generalProperty.traj3DColors{event_i}, 'LineWidth', 1.0, 'HandleVisibility','off');
                        plot(axes2, BehaveData.traj.data(1, locationI, trails_list(trails_i)),  BehaveData.traj.data(3, locationI, trails_list(trails_i)),'color', generalProperty.traj3DColors{event_i}, 'LineWidth', 1.0, 'HandleVisibility','off');
                        plot(axes3, BehaveData.traj.data(3, locationI, trails_list(trails_i)),  BehaveData.traj.data(4, locationI, trails_list(trails_i)),'color', generalProperty.traj3DColors{event_i}, 'LineWidth', 1.0, 'HandleVisibility','off');
                        plot(axes4, BehaveData.traj.data(1, locationI, trails_list(trails_i)),  BehaveData.traj.data(4, locationI, trails_list(trails_i)),'color', generalProperty.traj3DColors{event_i}, 'LineWidth', 1.0, 'HandleVisibility','off');
                    end
                end

            end
           
        end
        
        average_goodframes = trailsincludscount > (length(trails_list) * 0.5);
        
        average_traj(1, :) = average_traj(1, :) ./ trailsincludscount;  
        average_traj(2, :) = average_traj(2, :) ./ trailsincludscount;  
        average_traj(3, :) = average_traj(3, :) ./ trailsincludscount;  
        
        plot3(axes1, average_traj(1, average_goodframes), average_traj(2, average_goodframes),  average_traj(3, average_goodframes),'color', 'black', 'LineWidth', 2.0, 'HandleVisibility','off');
        plot3(axes5, average_traj(1, average_goodframes), average_traj(2, average_goodframes),  average_traj(3, average_goodframes),'color', 'black', 'LineWidth', 2.0, 'HandleVisibility','off');
        plot3(axes6, average_traj(1, average_goodframes), average_traj(2, average_goodframes),  average_traj(3, average_goodframes),'color', eventColor, 'LineWidth', 2.0, 'HandleVisibility','off');
        
        plot(axes2, average_traj(1, average_goodframes), average_traj(2, average_goodframes), 'color', 'black', 'LineWidth', 2.0, 'HandleVisibility','off');
        plot(axes3, average_traj(2, average_goodframes), average_traj(3, average_goodframes), 'color', 'black', 'LineWidth', 2.0, 'HandleVisibility','off');
        plot(axes4, average_traj(1, average_goodframes), average_traj(3, average_goodframes), 'color', 'black', 'LineWidth', 2.0, 'HandleVisibility','off');
%       

        plot(axes7, average_traj(1, average_goodframes), average_traj(2, average_goodframes), 'color', eventColor, 'LineWidth', 2.0, 'HandleVisibility','off');
        plot(axes8, average_traj(2, average_goodframes), average_traj(3, average_goodframes), 'color', eventColor, 'LineWidth', 2.0, 'HandleVisibility','off');
        plot(axes9, average_traj(1, average_goodframes), average_traj(3, average_goodframes), 'color', eventColor, 'LineWidth', 2.0, 'HandleVisibility','off');
%       
        
        mysave(fig, fullfile(outputPath, ['traj_colors_alignedtoevent' 'lift' '_event'  eventName]));
        mysave(fig2, fullfile(outputPath, ['traj_2D(1,2)colors_alignedtoevent' 'lift' '_event'  eventName]));
        mysave(fig3, fullfile(outputPath, ['traj_2D(2,3)colors_alignedtoevent' 'lift' '_event'  eventName]));
        mysave(fig4, fullfile(outputPath, ['traj_2D(1,3)colors_alignedtoevent' 'lift' '_event'  eventName]));
        mysave(fig5, fullfile(outputPath, ['traj_alignedtoevent' 'lift' '_event'  eventName]));
     end
     
     
        mysave(fig6, fullfile(outputPath, ['averageTraj_alignedtoevent' 'lift']));
        mysave(fig7, fullfile(outputPath, ['averageTraj_2D(1,2)_alignedtoevent' 'lift']));
        mysave(fig8, fullfile(outputPath, ['averageTraj_2D(2,3)_alignedtoevent' 'lift']));
        mysave(fig9, fullfile(outputPath, ['averageTraj_2D(1,3)_alignedtoevent' 'lift']));
end