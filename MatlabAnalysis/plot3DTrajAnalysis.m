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
       
     for index_events = 0:length(classes)
        if index_events == 0
            trails_list = examinedInds;
            eventName = 'all';
        else
            trails_list = examinedInds(labels==classes(index_events));
            eventName = labelsLUT{index_events};
        end
        
        fig = figure;
        axes1 = axes('Parent',fig);
        hold(axes1,'on');   
        view(3);
        grid(axes1,'on');
        axis(axes1,'ij');

        set(axes1,'ZDir','reverse');

%         xlim([0 600]);
        
        fig2 = figure;
        axes2 = axes('Parent',fig2);
        hold(axes2,'on');   
        grid(axes2,'on');
        axis(axes2,'ij');

        fig3 = figure;
        axes3 = axes('Parent',fig3);
        hold(axes3,'on');   
        grid(axes3,'on');
        axis(axes3,'ij');
        
        fig4 = figure;
        axes4 = axes('Parent',fig4);
        hold(axes4,'on');   
        grid(axes4,'on');
        axis(axes4,'ij');
        
        fig5 = figure;
        axes5 = axes('Parent',fig5);
        hold(axes5,'on');   
        view(3);
        grid(axes5,'on');
        axis(axes5,'ij');

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
        
        average_traj = zeros(3, 101);
        trailsincludscount = zeros(1, 101);
%         trailsincludscount = 0;
        
        for trails_i = 1:length(trails_list)
            
            alignedEvent = NAMES_BEHAVE(contains(NAMES_BEHAVE, 'lift'));
            startTimeIndex = findClosestDouble(t, generalProperty.traj3D_startTime);
            
            framesSelected =  startTimeIndex : startTimeIndex + 100;
    
            for indexE = 1:length(alignedEvent)
                event_time = BehaveData.(alignedEvent{indexE}).eventTimeStamps{trails_list(trails_i)};
                event_time = round((event_time .* frameRateRatio) + generalProperty.BehavioralDelay); 
                    
                if (~isempty(event_time) && event_time(1) > startTimeIndex)
                    framesSelected = event_time(1) : (event_time(1) + 100);
                    break;
                end
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
        
        average_goodframes = trailsincludscount > (length(trails_list) * 0.8);
        
        average_traj(1, :) = average_traj(1, :) ./ trailsincludscount;  
        average_traj(2, :) = average_traj(2, :) ./ trailsincludscount;  
        average_traj(3, :) = average_traj(3, :) ./ trailsincludscount;  
        
%         plot3(axes1, average_traj(1, average_goodframes), average_traj(2, average_goodframes),  average_traj(3, average_goodframes),'color', 'black', 'LineWidth', 2.0, 'HandleVisibility','off');
        plot3(axes5, average_traj(1, average_goodframes), average_traj(2, average_goodframes),  average_traj(3, average_goodframes),'color', 'black', 'LineWidth', 2.0, 'HandleVisibility','off');
        
        plot(axes2, average_traj(1, average_goodframes), average_traj(2, average_goodframes), 'color', 'black', 'LineWidth', 2.0, 'HandleVisibility','off');
        plot(axes3, average_traj(2, average_goodframes), average_traj(3, average_goodframes), 'color', 'black', 'LineWidth', 2.0, 'HandleVisibility','off');
        plot(axes4, average_traj(1, average_goodframes), average_traj(3, average_goodframes), 'color', 'black', 'LineWidth', 2.0, 'HandleVisibility','off');
%           
        
        mysave(fig, fullfile(outputPath, ['traj_colors_alignedtoevent' 'lift' '_event'  eventName]));
        mysave(fig2, fullfile(outputPath, ['traj_2D(1,2)colors_alignedtoevent' 'lift' '_event'  eventName]));
        mysave(fig3, fullfile(outputPath, ['traj_2D(2,3)colors_alignedtoevent' 'lift' '_event'  eventName]));
        mysave(fig4, fullfile(outputPath, ['traj_2D(1,3)colors_alignedtoevent' 'lift' '_event'  eventName]));
        mysave(fig5, fullfile(outputPath, ['traj_alignedtoevent' 'lift' '_event'  eventName]));
     end
end