function [delays] = alignedDataAccordingToEvent(eventName, eventNum, BehaveData)
    fields = fieldnames(BehaveData);
    ind = find(strcmpi(eventName, fields), 1);
    if isempty(ind)
        eventnumber = num2str(eventNum, '%02d');
        ind = find(strcmp([eventName eventnumber], fields), 1);
        
        if isempty(ind)
            error('Event selected for aligned data is incorrect');
        end
    end
    
    if (length(BehaveData.(fields{ind}).eventTimeStamps) < size(BehaveData.(fields{ind}).indicator, 1))
        BehaveData.(fields{ind}).eventTimeStamps(end+1:size(BehaveData.(fields{ind}).indicator, 1)) = {[]};
    end
    
    for index = 1:length(BehaveData.(fields{ind}).eventTimeStamps)
        currentR = BehaveData.(fields{ind}).eventTimeStamps{index};
        
        if (isempty(currentR))
            delays(index) = nan;
        else
            delays(index) = BehaveData.(fields{ind}).eventTimeStamps{index}(1);
        end
    end
end