function RoiAllAnalysisRunnerSoma

addpath('../');

xmlfile = 'SomaRoiXmlByBoth.xml';

folderAnimal = '\\192.114.21.82\g\Layer V\Analysis\PT1\';
trajpth = '\\192.114.21.82\g\Layer V\Videos\PT1\2021-06-22_PT1_Soma_Neuron1\DLC';
roiListNamesPath = '';
predictor = '';
NeuronNumber = 'SOMA';

folderAnimalOutputPath='\\jackie-analysis\e\Shay\PT1\';
% if you want to run only one date from the animal experiments change the 
% value here to the date you want. but if you want all dates in the foulder
% use specific_experiment = '';
% if you want to run only one date from the animal experiments change the 
% value here to the date you want. but if you want all dates in the foulder
% use specific_experiment = '';
specific_experiment = '06.22.21_Soma_Neuron1';

listExperiments = dir (folderAnimal);


for index = 1: length(listExperiments)      
    if ~strcmp(listExperiments(index).name, '..') && ~strcmp(listExperiments(index).name, '.')
        
        if strcmp(specific_experiment, '') || (~strcmp(specific_experiment, '') && strcmp(listExperiments(index).name, specific_experiment))

            bda_tpa_folder = strcat(listExperiments(index).folder, '\',listExperiments(index).name);
            listFilesBDA = dir([bda_tpa_folder '\BDA*']);
            listFilesTPA = dir([bda_tpa_folder '\TPA*']);
            
            if ~isempty(listFilesBDA)
                bdaCount = 1;
                for i = 1: length(listFilesBDA)
                    testBDA = listFilesBDA(i).name;
                    testTPA = listFilesTPA(i).name;

                    BdaTpaList(bdaCount).BDA = [bda_tpa_folder '\' testBDA]; 
                    BdaTpaList(bdaCount).TPA = [bda_tpa_folder '\' testTPA]; 
                    bdaCount =bdaCount+1;
                end
                
                BdaTpaList = getTrajFiles(BdaTpaList, trajpth, listExperiments(index).name);
% 
                BdaTpaList(1).roiListNamesPath = roiListNamesPath;
                BdaTpaList(1).predictor = predictor;
                
                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\', NeuronNumber ,'\atogram_printer');
                mkNewFolder(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'atogram_printer', 'imaging');


%                 outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\FWHM_analysis');
%                 mkNewFolder(outputPath);
%                 runAnalysis(outputPath, xmlfile, BdaTpaList, 'FWHM_analysis', 'imaging');

%                 outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\', NeuronNumber, '\pcaTrajectories');
%                 mkNewFolder(outputPath);
%                 runAnalysis(outputPath, xmlfile, BdaTpaList, 'pcaTrajectories', 'RoiCorrelation');

%                 outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\plotSingleNrnAcrossTrials');
%                 mkNewFolder(outputPath);
%                 runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials', 'imaging');

% % 
%                 outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\grabsCountHis');
%                 mkNewFolder(outputPath);
%                 runAnalysis(outputPath, xmlfile, BdaTpaList, 'grabsCountHis', 'imaging');

%                 outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\plotAllNrnsAcrossTrials');
%                 mkNewFolder(outputPath);
%                 runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotAllNrnsAcrossTrials', 'imaging');
% 
%                 outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\Pca2D');
%                 mkNewFolder(outputPath);
%                 runAnalysis(outputPath, xmlfile, BdaTpaList, 'Pca2D', 'imaging');
%                 
%                 outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\', NeuronNumber ,'\delay2events');
%                 mkNewFolder(outputPath);
%                 runAnalysis(outputPath, xmlfile, BdaTpaList, 'delay2events', 'imaging');

                outputPath = strcat(folderAnimalOutputPath  ,'\' , listExperiments(index).name , '\Analysis\', NeuronNumber ,'\glmAnalysis');
                mkNewFolder(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'glmAnalysis', 'imaging');               
                
                % 
%                 outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\diffMap2D');
%                 mkNewFolder(outputPath);
%                 runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMap2D', 'imaging');
% 
%                 outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\svmAccuracy');
%                 mkNewFolder(outputPath);
%                 runAnalysis(outputPath, xmlfile, BdaTpaList, 'svmAccuracy', 'imaging');
% 
%                 outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\SingleNeuronAnalysis');
%                 mkNewFolder(outputPath);
%                 runAnalysis(outputPath, xmlfile, BdaTpaList, 'SingleNeuronAnalysis', 'imaging');
% 
%                 outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\SingleNeuronSignificantAnalysis');
%                 mkNewFolder(outputPath);
%                 runAnalysis(outputPath, xmlfile, BdaTpaList, 'SingleNeuronSignificantAnalysis', 'imaging');
                  
%                 outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\SingleNeuronAnalysis');
%                 mkNewFolder(outputPath);
%                 runAnalysis(outputPath, xmlfile, BdaTpaList, 'SingleNeuronAnalysis');
                
                
%                 outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\predictionIndicativeAmp');
%                 mkNewFolder(outputPath);
%                 runAnalysis(outputPath, xmlfile, BdaTpaList, 'predictionIndicativeAmp');

             
                close all;
                BdaTpaList = [];
            end
        end
    end
end