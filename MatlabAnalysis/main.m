function main

xmlfile = 'D:\Shay\work\Dropbox\Apps\AnalysisManager\testBen\test\XmlAnalysis.xml';
outputPath = 'res';
BdaTpaList(1).TPA = 'D:\Shay\work\PT3\3_13_18_1\TPA_TSeries_03132018_0944_001_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(2).TPA = 'D:\Shay\work\PT3\3_13_18_1\TPA_TSeries_03132018_0944_002_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(3).TPA = 'D:\Shay\work\PT3\3_13_18_1\TPA_TSeries_03132018_0944_003_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(4).TPA = 'D:\Shay\work\PT3\3_13_18_1\TPA_TSeries_03132018_0944_004_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(5).TPA = 'D:\Shay\work\PT3\3_13_18_1\TPA_TSeries_03132018_0944_005_Cycle00001_Ch2_000001_ome.mat';

BdaTpaList(1).BDA = 'D:\Shay\work\PT3\3_13_18_1\BDA_TSeries_03132018_0944_001_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(2).BDA = 'D:\Shay\work\PT3\3_13_18_1\BDA_TSeries_03132018_0944_002_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(3).BDA = 'D:\Shay\work\PT3\3_13_18_1\BDA_TSeries_03132018_0944_003_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(4).BDA = 'D:\Shay\work\PT3\3_13_18_1\BDA_TSeries_03132018_0944_004_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(5).BDA = 'D:\Shay\work\PT3\3_13_18_1\BDA_TSeries_03132018_0944_005_Cycle00001_Ch2_000001_ome.mat';

% this is just an example to see how to extract the neurons' names from a
% tpa file
[Neurons] = getAllExperimentNeurons(BdaTpaList(1).TPA);
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');

runAnalysis(outputPath, xmlfile, BdaTpaList, 'Pca2D');


