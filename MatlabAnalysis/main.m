function main

xmlfile = 'XmlPT3.xml';
outputPath = 'res';
BdaTpaList(1).TPA = 'C:\Users\Hadas\Dropbox\biomedData\PT3\3_13_18\3_13_18_1\TPA_TSeries_03132018_0944_001_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(2).TPA = 'C:\Users\Hadas\Dropbox\biomedData\PT3\3_13_18\3_13_18_1\TPA_TSeries_03132018_0944_002_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(3).TPA = 'C:\Users\Hadas\Dropbox\biomedData\PT3\3_13_18\3_13_18_1\TPA_TSeries_03132018_0944_003_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(4).TPA = 'C:\Users\Hadas\Dropbox\biomedData\PT3\3_13_18\3_13_18_1\TPA_TSeries_03132018_0944_004_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(5).TPA = 'C:\Users\Hadas\Dropbox\biomedData\PT3\3_13_18\3_13_18_1\TPA_TSeries_03132018_0944_005_Cycle00001_Ch2_000001_ome.mat';

BdaTpaList(1).BDA = 'C:\Users\Hadas\Dropbox\biomedData\PT3\3_13_18\3_13_18_1\BDA_TSeries_03132018_0944_001_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(2).BDA = 'C:\Users\Hadas\Dropbox\biomedData\PT3\3_13_18\3_13_18_1\BDA_TSeries_03132018_0944_002_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(3).BDA = 'C:\Users\Hadas\Dropbox\biomedData\PT3\3_13_18\3_13_18_1\BDA_TSeries_03132018_0944_003_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(4).BDA = 'C:\Users\Hadas\Dropbox\biomedData\PT3\3_13_18\3_13_18_1\BDA_TSeries_03132018_0944_004_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(5).BDA = 'C:\Users\Hadas\Dropbox\biomedData\PT3\3_13_18\3_13_18_1\BDA_TSeries_03132018_0944_005_Cycle00001_Ch2_000001_ome.mat';

% this is just an example to see how to extract the neurons' names from a
% tpa file
[Neurons] = getAllExperimentNeurons(BdaTpaList(1).TPA);
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');

runAnalysis(outputPath, xmlfile, BdaTpaList, 'Pca2D');


