function atogram_printer_event(outputPath, generalProperty, imagingData, BehaveData, event, examinedInds)
    fig = figure;
    hold on;
    set(fig,'Units','normalized')
       
    
    subplot1 = subplot(4,1,1:3);
    hold on;
    title({event});  
    
     h = zeros(size(generalProperty.atogramColors,1),1);
    for colorIndex = 1:length(generalProperty.atogramColors)
        h(colorIndex) = plot(NaN,NaN,'color',generalProperty.atogramColors{colorIndex});
    end
  
    legend(h, generalProperty.atogramLabels);
    legend('Location', 'best')

    
    subplot1.YGrid = 'on';
           
    trailsCount = length(examinedInds);
    t = linspace(0, generalProperty.Duration, size(imagingData.samples, 2)) - generalProperty.ToneTime;
 
   NAMES_BEHAVE = fields(BehaveData);
     
   for event_i = 1:length(generalProperty.atogramLabels)
       eventsL{event_i} = NAMES_BEHAVE(contains(NAMES_BEHAVE, generalProperty.atogramLabels{event_i}));
   end
   
   
   allbehave = zeros(length(eventsL), size(imagingData.samples, 2));
    
   for event_i = 1:length(eventsL)
       for index = 1:length(eventsL{event_i})
            for trails_i = 1:trailsCount
                locationI = find(BehaveData.(eventsL{event_i}{index}).indicator(examinedInds(trails_i),:) == 1);
                allbehave(event_i, locationI) = allbehave(event_i, locationI) + 1;
                value = zeros(1, length(locationI)) + trails_i;
                plot(t(locationI), value,'color', generalProperty.atogramColors{event_i}, 'LineWidth', 2.0, 'HandleVisibility','off');
                hold all;
            end
                    
       end
   end
    
    ylim(subplot1,[0 trailsCount]);
    xlim(subplot1,[generalProperty.atogramStartTime, generalProperty.atogramEndTime])
    yticks(0 : 4 : trailsCount)
    line([0 0], get(gca, 'YLim'), 'Color','k','LineWidth',3, 'LineStyle', ':', 'HandleVisibility','off');
    
   subplot2 = subplot(4,1,4);
   hold on;
   
   for event_i = 1:length(generalProperty.atogramLabels)
        plot(t, allbehave(event_i, :), 'color', generalProperty.atogramColors{event_i},'LineWidth',1, 'HandleVisibility','off');
        hold all;
   end
   
   xlim(subplot2,[generalProperty.atogramStartTime, generalProperty.atogramEndTime]) 
   mysave(fig, fullfile(outputPath, ['actogram_', event]));
end