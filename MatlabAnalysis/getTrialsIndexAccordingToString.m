function [examinedInds, labels] = getTrialsIndexAccordingToString(trialsStr, examinedInds, labels)     
    errorStr = 'The generalProperty trailsToRunOrderByData is incorrect';
    if (~isempty(trialsStr))
        splitR = split(trialsStr, ';');
        savedT = zeros(1,length(examinedInds));
        for i = 1: length(splitR)
            currentT = split(splitR{i}, ':');
            
            if (length(currentT) < 2)
                error(errorStr);
            end
            
            startI = str2double(currentT{1});
            endI = str2double(currentT{2});
            
            if isnan(startI)
                error('The generalProperty trailsToRunOrderByData is incorrect');
            elseif isnan(endI)
                if strcmp(currentT{2}, 'end')
                    savedT(find(examinedInds == startI):end) = 1;
                else
                    error(errorStr);
                end
            else
                savedT(find(examinedInds == startI):find(examinedInds == endI)) = 1;
            end
        end
        
        examinedInds = examinedInds(savedT == 1);
        labels = labels(savedT == 1);
    end 
end