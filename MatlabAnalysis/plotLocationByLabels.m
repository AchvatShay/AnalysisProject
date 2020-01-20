function cent = plotLocationByLabels(locations, labels)



figure;
hold all;M = round(max(locations(:)));
for nrni = 1:length(labels)
    if labels(nrni)
        clr = 'b';
    else
        clr = 'k';
    end
    
    x = locations(nrni, :, 1,1);
    y = locations(nrni, :, 2,1);
    BW = poly2mask(x,y,M,M);
    [x1,y1]=find(BW==1);
    plot(x1, y1, ['.' clr]);
    cent(nrni, 1) = mean(x1);
    cent(nrni, 2) = mean(y1);
end
title('Blue - Significant; Black - Rest');
xlabel('X Location');ylabel('Y Location');
