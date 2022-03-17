function KurtamAnalysisRunner

addpath('../');

xmlfile = 'KurtamXmlByBoth.xml';


folderAnimalOutputPath='D:\Kurtam\experiments\Results';
BDATPAfolder = 'D:\Kurtam\experiments\Analysis\OTF15\22_01_11\';

predictor = [BDATPAfolder, '\predictor_Running.mat'];

BdaFiles = dir([BDATPAfolder, '\BDA*.mat']);
TPAFiles = dir([BDATPAfolder, '\TPA_*.mat']);

for i = 1:length(BdaFiles)
    BdaTpaList(i).TPA = [TPAFiles(i).folder , '\', TPAFiles(i).name] ;
    BdaTpaList(i).BDA = [BdaFiles(i).folder , '\', BdaFiles(i).name] ; 
end

trialsInclude = [1:size(BdaTpaList, 2)];

BdaTpaList = BdaTpaList(trialsInclude);
BdaTpaList(1).trialsToIncluse = trialsInclude;
BdaTpaList(1).predictor = predictor;

outputPath = strcat(folderAnimalOutputPath, '\glmAnalysis');
mkNewFolder(outputPath);
runAnalysis(outputPath, xmlfile, BdaTpaList, 'glmAnalysisTreadMil', 'treadmill_run');