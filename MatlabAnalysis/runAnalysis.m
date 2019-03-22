function runAnalysis(outputPath, xmlfile, BdaTpaList, analysisName)
% mkNewFolder(outputPath);

generalProperty = Experiment(xmlfile);

[imagingData, BehaveData] = loadData(BdaTpaList, generalProperty);
feval(analysisName,outputPath, generalProperty, imagingData, BehaveData); 
if isfield(BehaveData, 'traj')
    trajData.samples = BehaveData.traj.data;
    trajData.roiNames = {'frontx','fronty','sidex','sidey'};
    outputPath = [outputPath 'Traj']; 
    mkNewFolder(outputPath);
    generalProperty.ImagingSamplingRate = generalProperty.BehavioralSamplingRate;
    feval(analysisName,outputPath, generalProperty, trajData, BehaveData); 

end