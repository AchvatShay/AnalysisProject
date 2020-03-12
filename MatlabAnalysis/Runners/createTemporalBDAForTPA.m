function createTemporalBDAForTPA(TPA_name, TPA_trials_count, outputfile)
    strEvent{1} = TPA_EventManager();
    
    for index = 1:TPA_trials_count
      save(fullfile(outputfile, sprintf('%s_%03d', replace(TPA_name, 'TPA', 'BDA'), index)), 'strEvent');
    end
end