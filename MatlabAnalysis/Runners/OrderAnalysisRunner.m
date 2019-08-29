function AllAnalysisRunner

addpath('../');

xmlfile = 'XmlByBoth.xml';

folderAnimal = 'E:\Dropbox (Technion Dropbox)\Shahar\success- failure project\PT neurons\Den7\8_13_17\';
trajpth = '';
folderAnimalOutputPath='E:\Dropbox (Technion Dropbox)\AnalysisResultsShay\Test3';
% if you want to run only one date from the animal experiments change the 
% value here to the date you want. but if you want all dates in the foulder
% use specific_experiment = '';
% if you want to run only one date from the animal experiments change the 
% value here to the date you want. but if you want all dates in the foulder
% use specific_experiment = '';
specific_experiment = '8_13_17_1';

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
                    if contains({testBDA}, 'BDA')
                        BdaTpaList(bdaCount).BDA = [bda_tpa_folder '\' testBDA]; 

                        for k = 1: length(listFiles)
                            if contains({listFiles(k).name}, 'TPA')
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

            
%                 Create Order For the Current Date
                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\getOrderOFActivationByData');
                mkNewFolder(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'getOrderOFActivationByData', 'imaging');

%                 Compare Current Date With Master Form the .mat file set
%                 in XML
                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\getOrderOfActivationByFileMat');
                mkNewFolder(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'getOrderOfActivationByFileMat', 'imaging');
                 
%                 Cross validation of Current Date
                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\crossValidationOrderAnalysis');
                mkNewFolder(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'crossValidationOrderAnalysis', 'imaging');
                
                close all;
                BdaTpaList = [];
            end
        end
    end
end