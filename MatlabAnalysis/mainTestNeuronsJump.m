function main

xmlfile = 'XmlPT3.xml';
% xmlfile = 'XmlPT3_1nrn.xml';
% xmlfile = 'XmlPT3_nonrns.xml';


outputPath = 'res';
modeShai = false;
if modeShai
    pth = 'D:\Shay\work\PT3\3_13_18_1\';
else
    pth = 'C:\Users\Hadas\Downloads\tryshay\ForHadas';
end
for k=1:3
BdaTpaList(k).BDA = fullfile(pth, ['BDA_TSeries_02232017_1034_' sprintf('%03d',k) '_Cycle00001_Ch2_000001_ome.mat']);
BdaTpaList(k).TPA = fullfile(pth, ['TPA_TSeries_02232017_1034_' sprintf('%03d',k) '_Cycle00001_Ch2_000001_ome.mat']);
end
for k=1:3
BdaTpaList(k+3).BDA = fullfile(pth, ['BDA_TSeries_02272017_0935_' sprintf('%03d',k) '_Cycle00001_Ch2_000001_ome.mat']);
BdaTpaList(k+3).TPA = fullfile(pth, ['TPA_TSeries_02272017_0935_' sprintf('%03d',k) '_Cycle00001_Ch2_000001_ome.mat']);
end

eventsList = {'success','failure'}; % this is a list to to the accuracy on
runAccuracy(outputPath, xmlfile, BdaTpaList, eventsList);

% running analysis averaging
analysisName = 'accuracy';
generalProperty = Experiment(xmlfile);
MatList = {'res/acc_res_folds10lin_success_failure.mat' 'res/acc_res_folds10lin_success_failure.mat'};
runAverageAnalysis(outputPath, generalProperty, MatList, analysisName, eventsList);

% this is just an example to see how to extract the events' labels from a
% bda file
eventsLabels = getAllExperimentLabels({BdaTpaList.BDA});



% this is just an example to see how to extract the neurons' names from a
% tpa file
[Neurons] = getAllExperimentNeurons(BdaTpaList(1).TPA);
% just checking if this code works with 1 neuron to plot or none
xmlfile = 'XmlPT3_1nrn.xml';
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');

xmlfile = 'XmlPT3_nonrns.xml';
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');
% now for more than 1 neuron
xmlfile = 'XmlPT3.xml';
runAnalysis(outputPath, xmlfile, BdaTpaList, 'pcaTrajectories');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotAllNrnsAcrossTrials');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'Pca2D');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMap2D');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMapTrajectories');


