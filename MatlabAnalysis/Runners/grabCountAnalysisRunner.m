function grabCountAnalysisRunner
addpath(genpath('../'));

xmlfile = 'XmlBothAMwithSF.xml';

folderAnimal = 'C:\Users\Hadas Ben Esti\Documents\biomedData\M26';
folderAnimalOutputPath = 'C:\Users\Hadas Ben Esti\Documents\biomedresults\M26';


% if you want to run only one date from the animal experiments change the 
% value here to the date you want. but if you want all dates in the foulder
% use specific_experiment = '';
% specific_experiment = '3_13_18';
specific_experiment = '9_28_17';

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

                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\grabCountAnalysis');
                mkdir(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'grabCountAnalysis', 'imaging');

                close all;
                BdaTpaList = [];
            end
        end
    end
end