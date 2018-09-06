function placeTimePointsOnTraj(clrs, meansTrajs, mvStartInd, toneTime, afterToneInd)
for ci = 1:size(meansTrajs, 3)
    if ~isempty(mvStartInd)
        plot3(meansTrajs(1,mvStartInd, ci), meansTrajs(2,mvStartInd, ci), meansTrajs(3,mvStartInd, ci),'Marker', 's', 'MarkerFaceColor','w','MarkerSize',10,...
            'MarkerEdgeColor',clrs(ci,:))
    end
    if ~isempty(toneTime)
        plot3(meansTrajs(1,toneTime, ci), meansTrajs(2,toneTime, ci),meansTrajs(3,toneTime, ci),'ko','MarkerSize',10,...
            'MarkerFaceColor','w',...
            'MarkerEdgeColor',clrs(ci,:))
    end
    
    if ~isempty(afterToneInd)
        plot3(meansTrajs(1,afterToneInd, ci), meansTrajs(2,afterToneInd, ci),meansTrajs(3,afterToneInd, ci),'k^','MarkerSize',10,...
            'MarkerFaceColor','w',...
            'MarkerEdgeColor',clrs(ci,:))
    end
end
