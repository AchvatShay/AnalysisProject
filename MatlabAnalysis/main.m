function main

xmlfile = 'XmlPT3.xml';
% xmlfile = 'XmlPT3_1nrn.xml';
% xmlfile = 'XmlPT3_nonrns.xml';


outputPath = 'resPT3';
modeShai = false;
if modeShai
    pth = 'D:\Shay\work\PT3\3_13_18_1\';
else
    pth = 'C:\Users\Hadas\Dropbox\biomedData\PT3\3_13_18\3_13_18_1';
mkNewFolder(outputPath);
end
for k=1:70
BdaTpaList(k).TPA = fullfile(pth, ['TPA_TSeries_03132018_0944_' sprintf('%03d',k) '_Cycle00001_Ch2_000001_ome.mat']);
BdaTpaList(k).BDA = fullfile(pth, ['BDA_TSeries_03132018_0944_' sprintf('%03d',k) '_Cycle00001_Ch2_000001_ome.mat']);
end
outputPath = 'resPT3';mkNewFolder(outputPath);
% files = {'2_21_17\2_21_17_1','2_22_17/2_22_17_1' '4_2_17/4_2_17_1'  '2_27_17/2_27_17_1stAndThird' '3_1_17/3_1_17_1' ...
%              '2_23_17\2_23_17_1_1stAndThird'};
%    pth = 'C:\Users\Hadas\Dropbox\biomedData\Den6';
%  BdaTpaList = getallBDATPA(pth, files);
% outputPath = 'resDen6All';mkNewFolder(outputPath);

% BdaTpaList=BdaTpaList(1:20);

runAnalysis(outputPath, xmlfile, BdaTpaList, 'Pca2D');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'pcaTrajectories');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotAllNrnsAcrossTrials');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMap2D');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'svmAccuracy');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'SingleNeuronAnalysis');
return;
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMapTrajectories');









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
MatList = {'res/acc_res_folds10lin_success_failure.mat' 'res/acc_res_folds10lin_success_failure.mat'};
runAverageAnalysis(outputPath, xmlfile, MatList, analysisName, eventsList);
