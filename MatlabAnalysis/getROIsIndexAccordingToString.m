function savedT = getROIsIndexAccordingToString(roiStr, roisArray)         
    splitR = split(roiStr, ';');
    savedT = zeros(1,length(roisArray));
    for i = 1: length(splitR)
        currentT = split(splitR{i}, ':');

        if (length(currentT) < 2)
            error('');
        end

        startI = str2double(currentT{1});
        endI = str2double(currentT{2});

        if isnan(startI)
            error('');
        elseif isnan(endI)
            if strcmp(currentT{2}, 'end')
                savedT(find(roisArray == startI):end) = 1;
            else
                error('');
            end
        else
            savedT(find(roisArray == startI):find(roisArray == endI)) = 1;
        end
    end
end