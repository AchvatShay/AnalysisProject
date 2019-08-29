function savedT = getTrialsIndexAccordingToString(trialsStr, trailsArray, labels)     
    errorStr = 'The generalProperty trailsToRun is incorrect';
    if (~isempty(trialsStr))
        splitR = split(trialsStr, ';');
        savedT = zeros(1,length(trailsArray));
        for i = 1: length(splitR)
            currentT = split(splitR{i}, ':');
            
            if (length(currentT) < 2)
                error(errorStr);
            end
            
            startI = str2double(currentT{1});
            endI = str2double(currentT{2});
            
            if isnan(startI)
                error('The generalProperty trailsToRun is incorrect');
            elseif isnan(endI)
                if strcmp(currentT{2}, 'end')
                    savedT(find(trailsArray == startI):end) = 1;
                else
                    error(errorStr);
                end
            else
                savedT(find(trailsArray == startI):find(trailsArray == endI)) = 1;
            end
        end
    else
        savedT = ones(1,length(trailsArray));
    end
end