function runAnalysis(outputPath, xmlfile, BdaTpaList, analysisName, runOnWhat)
% mkNewFolder(outputPath);
if ~exist('runOnWhat','var')
    runOnWhat = 'imaging';
end

generalProperty = Experiment(xmlfile);

[imagingData, BehaveData] = loadData(BdaTpaList, generalProperty);
switch runOnWhat
    case 'imaging'
        feval(analysisName,outputPath, generalProperty, imagingData, BehaveData);
    case 'traj'
        
        if ~isfield(BehaveData, 'traj')
            error('Could not find trajectories in this path');
        else
            trajData.samples = BehaveData.traj.data;
            for k=1:size(trajData.samples,1)
            trajData.roiNames{k} = num2str(k);
            end
            outputPath = [outputPath 'Traj'];
            mkNewFolder(outputPath);
            generalProperty.ImagingSamplingRate = generalProperty.BehavioralSamplingRate;
            feval(analysisName,outputPath, generalProperty, trajData, BehaveData);
            
        end
    case 'both'
        feval(analysisName,outputPath, generalProperty, imagingData, BehaveData);
        if ~isfield(BehaveData, 'traj')
            error('Could not find trajectories in this path');
        else
            trajData.samples = BehaveData.traj.data;
            trajData.roiNames = {'frontx','fronty','sidex','sidey'};
            outputPath = [outputPath 'Traj'];
            mkNewFolder(outputPath);
            generalProperty.ImagingSamplingRate = generalProperty.BehavioralSamplingRate;
            feval(analysisName,outputPath, generalProperty, trajData, BehaveData);
            
        end
end
