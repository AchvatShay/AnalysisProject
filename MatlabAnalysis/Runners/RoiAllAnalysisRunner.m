function RoiAllAnalysisRunner

addpath('../');

xmlfile = 'RoiXmlByBoth.xml';


folderAnimalOutputPath='\\jackie-analysis10\e\Shay\OTF21\10.1.22_Tuft_treadmill';
% if you want to run only one date from the animal experiments change the 
% value here to the date you want. but if you want all dates in the foulder
% use specific_experiment = '';
% if you want to run only one date from the animal experiments change the 
% value here to the date you want. but if you want all dates in the foulder
% use specific_experiment = '';

trajpth = '';
BDAfolder = '\\jackie-analysis10\f\LayerV\Analysis\OTF21\10.1.22_Tuft_treadmill_glm\Running';
TPAfolder = '\\jackie-analysis10\f\LayerV\Analysis\OTF21\10.1.22_Tuft_treadmill_glm\Running';


roiListNamesPath = '\\jackie-analysis10\e\Shay\OTF21\10.1.22_Tuft_treadmill\Analysis\N1\Structural_VS_Functional\final\Run1\no_behave\Pearson\SP\roiActivityRawData.mat';
% roiListNamesPath = '';
predictor = '\\jackie-analysis10\f\LayerV\Analysis\OTF21\10.1.22_Tuft_treadmill_glm\Running\predictor_Running.mat';
NeuronNumber = 'N1';


BdaFiles = dir([BDAfolder, '\BDA*.mat']);
TPAFiles = dir([TPAfolder, '\TPA_', NeuronNumber, '*.mat']);

for i = 1:length(BdaFiles)
    BdaTpaList(i).TPA = [TPAFiles(i).folder , '\', TPAFiles(i).name] ;
    BdaTpaList(i).BDA = [BdaFiles(i).folder , '\', BdaFiles(i).name] ; 
end

% BdaTpaList = getTrajFiles(BdaTpaList, trajpth, '');

trialsInclude = [1:size(BdaTpaList, 2)];

BdaTpaList = BdaTpaList(trialsInclude);

BdaTpaList(1).roiListNamesPath = roiListNamesPath;
BdaTpaList(1).predictor = predictor;
BdaTpaList(1).trialsToIncluse = trialsInclude;

outputPath = strcat(folderAnimalOutputPath, '\Analysis\', NeuronNumber ,'\glmAnalysis_Running_new');
mkNewFolder(outputPath);
runAnalysis(outputPath, xmlfile, BdaTpaList, 'glmAnalysisTreadMil', 'RoiSplit');