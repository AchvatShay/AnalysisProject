function RoiAllAnalysisRunner2

addpath('../');

xmlfile = 'RoiXmlByBoth.xml';


folderAnimalOutputPath='\\jackie-analysis\e\Shay\CT35\22_01_12-Treadmill-tuft';
% if you want to run only one date from the animal experiments change the 
% value here to the date you want. but if you want all dates in the foulder
% use specific_experiment = '';
% if you want to run only one date from the animal experiments change the 
% value here to the date you want. but if you want all dates in the foulder
% use specific_experiment = '';

trajpth = '';
BDAfolder = '\\jackie-analysis\F\LayerV\Analysis\CT35\22_01_12-Treadmill-tuft_glm\Running';
TPAfolder = '\\jackie-analysis\F\LayerV\Analysis\CT35\22_01_12-Treadmill-tuft_glm\Running';


roiListNamesPath = '\\jackie-analysis\e\Shay\CT35\22_01_12-Treadmill-tuft\Analysis\N2\Structural_VS_Functional\final\Run1\no_behave\Pearson\SP\roiActivityRawData.mat';
% roiListNamesPath = '';
predictor = '\\jackie-analysis\F\LayerV\Analysis\CT35\22_01_12-Treadmill-tuft_glm\Running\predictor_Running.mat';
NeuronNumber = 'N2';


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

outputPath = strcat(folderAnimalOutputPath, '\Analysis\', NeuronNumber ,'\glmAnalysis_Running_newLasso');
mkNewFolder(outputPath);
runAnalysis(outputPath, xmlfile, BdaTpaList, 'glmAnalysisTreadMil', 'RoiSplit');