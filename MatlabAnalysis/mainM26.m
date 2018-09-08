function mainM26

xmlfile = 'XmlM26.xml';
% xmlfile = 'XmlPT3_1nrn.xml';
% xmlfile = 'XmlPT3_nonrns.xml';


outputPath = 'resM26';
modeShai = false;
if modeShai
    pth = 'D:\Shay\work\PT3\3_13_18_1\';
else
    pth = 'C:\Users\Hadas\Dropbox\biomedData\M26\9_28_17\';
mkNewFolder(outputPath);
end
for k=1:70
BdaTpaList(k).TPA = fullfile(pth, ['TPA_TSeries_09282017_1010_' sprintf('%03d',k) '_Cycle00001_Ch2_000001_ome.mat']);
BdaTpaList(k).BDA = fullfile(pth, ['BDA_TSeries_09282017_1010_' sprintf('%03d',k) '_Cycle00001_Ch2_000001_ome.mat']);
end
MatList={ 'C:\Users\Hadas\Dropbox\Results\Den6Analysis\23_27Cat\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat' ...
        'C:\Users\Hadas\Dropbox\Results\Den6Analysis\23_27Cat\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat'...
    'C:\Users\Hadas\Dropbox\Results\Den6Analysis\2_21_17_1\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat'...
    'C:\Users\Hadas\Dropbox\Results\Den6Analysis\2_22_17_1\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat'...
    'C:\Users\Hadas\Dropbox\Results\Den6Analysis\2_23_17_1\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat'...
    'C:\Users\Hadas\Dropbox\Results\Den6Analysis\2_27_17_1\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat'...
    'C:\Users\Hadas\Dropbox\Results\Den6Analysis\3_1_17_1\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat'
};

outputPath='resDen6all';
mkNewFolder(outputPath);

runAverageAnalysis(outputPath, xmlfile, BdaTpaList(1:10), MatList, 'accuracy');

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
