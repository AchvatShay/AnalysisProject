function changeBDAEventName(BDAFolder, oldName, newName)
    allBDA = dir([BDAFolder , '\BDA*.mat']);
    
    for index = 1:length(allBDA)
        bda_events = load(fullfile(allBDA(index).folder, allBDA(index).name));
        strEvent = bda_events.strEvent;
    
        for e = 1:length(strEvent)
            if contains(strEvent{e}.Name, oldName)
                strEvent{e}.Name = replace(strEvent{e}.Name, oldName, newName);
            end
        end
        
        save(fullfile(allBDA(index).folder, allBDA(index).name), 'strEvent');   
    end
end