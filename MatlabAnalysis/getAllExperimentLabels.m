function eventsLabels = getAllExperimentLabels(BDAFileList)
eventsLabels = [];
% get all Neuron names for the TPA file as a list
for file_i = 1:length(BDAFileList)
    BDAFile = BDAFileList{file_i};
    if ~exist(BDAFile, 'file')
        error(['File ' BDAFile ' does not exist']);
    end
    bdaData = load(BDAFile);
    for ev = 1:length(bdaData.strEvent)
        eventsLabels{end+1} = extractEventstr(bdaData.strEvent{ev}.Name);
    end
    
end
eventsLabels = unique(eventsLabels);
end