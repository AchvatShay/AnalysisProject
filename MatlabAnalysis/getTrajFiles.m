function BdaTpaList = getTrajFiles(BdaTpaList, trajpth, expname)

trajdirs = dir(fullfile(trajpth, '\*\*.csv'));
if isempty(trajdirs)
    disp('No trajectories')
else
    if length(trajdirs) ~= length(BdaTpaList)
        error('Amount of trials in BDA and TPA does not agree with amount of trials in trajectories');
    end
    
    for l = 1:length(trajdirs)
        BdaTpaList(l).traj = fullfile(trajdirs(l).folder, trajdirs(l).name);
    end
end