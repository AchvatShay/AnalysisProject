function BdaTpaList = getTrajFiles(BdaTpaList, trajpth, expname)
trajdirs = dir(fullfile(trajpth, expname, '*.csv'));
if isempty(trajdirs)
    disp('No trajectories')
else
    if length(trajdirs) ~= length(BdaTpaList)
        error('Amount of trials in BDA and TPA does not agree with amount of trials in trajectories');
    end
    
    for l = 1:length(trajdirs)
        filecsv = dir(fullfile(trajpth,  expname, trajdirs(l).name));
        BdaTpaList(l).traj = fullfile(filecsv.folder, filecsv.name);
    end
end