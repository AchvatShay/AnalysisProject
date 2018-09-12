function BdaTpaList = main(pth, outputPath)

xmlfile = 'XmlM26.xml';
xmlfile = 'XmlBoth.xml';
% xmlfile = 'XmlPT3_1nrn.xml';
% xmlfile = 'XmlPT3_nonrns.xml';




mkNewFolder(outputPath);

filesTPA = dir([pth, '\TPA*.mat']);
filesBDA = dir([pth, '\BDA*.mat']);

for k=1:length(filesTPA)
BdaTpaList(k).TPA = fullfile(filesTPA(1).folder, filesTPA(k).name);
BdaTpaList(k).BDA = fullfile(filesBDA(1).folder, filesBDA(k).name);
end



runAnalysis(outputPath, xmlfile, BdaTpaList, 'Pca2D');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'pcaTrajectories');
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotAllNrnsAcrossTrials');
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMap2D');
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'svmAccuracy');
close all;
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'SingleNeuronAnalysis');
return;
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMapTrajectories');
runAverageAnalysis(outputPath, xmlfile, BdaTpaList(1:10), MatList, 'accuracy');









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
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');

% this is just an example to see how to extract the events' labels from a
% bda file
eventsLabels = getAllExperimentLabels({BdaTpaList.BDA});

% running analysis averaging
analysisName = 'accuracy';
% generalProperty = Experiment(xmlfile);
