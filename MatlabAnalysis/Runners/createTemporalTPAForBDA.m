function createTemporalTPAForBDA(BDA_name, BDA_trials_count, TPA_num_frames, outputfile)
    strROI{1} = TPA_RoiManager();
    strROI{1}.Name = 'ROI:Z:1:001';
    strROI{1}.Data = zeros(TPA_num_frames, 2);
    strROI{1}.xyInd = zeros(30, 2);
    strShift = zeros(TPA_num_frames, 2);
    
    for index = 1:BDA_trials_count
      save(fullfile(outputfile, sprintf('%s_%03d', replace(BDA_name, 'BDA', 'TPA'), index)), 'strROI', 'strShift');
    end
end