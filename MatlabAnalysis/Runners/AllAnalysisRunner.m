function AllAnalysisRunner

addpath('../');

xmlfile = 'XmlByBoth.xml';

folderAnimal = '\\192.114.20.85\d\Maria\Layer 2-3\Analysis\M27\';
trajpth = 'C:\Users\Jackie.MEDICINE\Dropbox (Technion Dropbox)\AnalysisResultsShay\Hadas\trajectoriesData\M27\';
folderAnimalOutputPath='C:\Users\Jackie.MEDICINE\Dropbox (Technion Dropbox)\AnalysisResultsShay\Hadas\analysisRes\M27';
% if you want to run only one date from the animal experiments change the 
% value here to the date you want. but if you want all dates in the foulder
% use specific_experiment = '';
% if you want to run only one date from the animal experiments change the 
% value here to the date you want. but if you want all dates in the foulder
% use specific_experiment = '';
specific_experiment = '1_8_18';

listExperiments = dir (folderAnimal);

for index = 1: length(listExperiments)      
    if ~strcmp(listExperiments(index).name, '..') && ~strcmp(listExperiments(index).name, '.')
        
        if strcmp(specific_experiment, '') || (~strcmp(specific_experiment, '') && strcmp(listExperiments(index).name, specific_experiment))

            bda_tpa_folder = strcat(listExperiments(index).folder, '\',listExperiments(index).name);
            listFiles = dir(bda_tpa_folder);

            if ~isempty(listFiles)
                bdaCount = 1;
                for i = 1: length(listFiles)
                    testBDA = listFiles(i).name;
                    if contains(testBDA, 'BDA')
                        BdaTpaList(bdaCount).BDA = [bda_tpa_folder '\' testBDA]; 

                        for k = 1: length(listFiles)
                            if contains(listFiles(k).name, 'TPA')
                                testTPA = strrep(listFiles(k).name,'TPA','BDA');
                                if (strcmp(testTPA, testBDA))
                                    BdaTpaList(bdaCount).TPA = [bda_tpa_folder '\' listFiles(k).name]; 
                                    bdaCount = bdaCount + 1;
                                end
                            end
                        end
                    end
                end
                BdaTpaList = getTrajFiles(BdaTpaList, trajpth, listExperiments(index).name);

                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\pcaTrajectories');
                mkNewFolder(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'pcaTrajectories', 'both');

                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\plotSingleNrnAcrossTrials');
                mkNewFolder(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials', 'imaging');


                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\plotAllNrnsAcrossTrials');
                mkNewFolder(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotAllNrnsAcrossTrials', 'imaging');

                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\Pca2D');
                mkNewFolder(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'Pca2D', 'both');
                
                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\delay2events');
                mkNewFolder(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'delay2events', 'imaging');

                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\diffMap2D');
                mkNewFolder(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMap2D', 'both');

                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\svmAccuracy');
                mkNewFolder(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'svmAccuracy', 'both');

                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\SingleNeuronAnalysis');
                mkNewFolder(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'SingleNeuronAnalysis', 'imaging');

                close all;
                BdaTpaList = [];
            end
        end
    end
end