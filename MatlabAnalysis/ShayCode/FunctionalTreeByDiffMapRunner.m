addpath('E:\Code\hadas\AnalysisProject\MatlabAnalysis\');

xmlfile = 'XmlForFunctionalTree.xml';

folderAnimal = 'E:\Dropbox (Technion Dropbox)\Yara\Layer 5_Analysis\SM04';
trajpth = '';
folderAnimalOutputPath="E:\Dropbox (Technion Dropbox)\Yara\Layer 5_Analysis\Yara's Data For Shay\SM04";
folderAnimalOutputPath = char(folderAnimalOutputPath);
    
% if you want to run only one date from the animal experiments change the 
% value here to the date you want. but if you want all dates in the foulder
% use specific_experiment = '';
% if you want to run only one date from the animal experiments change the 
% value here to the date you want. but if you want all dates in the foulder
% use specific_experiment = '';
specific_experiment = '08_18_19_tuft_Final_Version';

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

                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\diffMapForFunctionalTreeDepth1\23_8_20_PKS20_cluster4\');
                mkNewFolder(outputPath);
                
                structuralTreeLabels = load(strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\Structural_VS_FunctionalAnalysis\cluster4pks20\structuralTreeLabels_depth1.mat'));
                
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMapForFunctionalTree', 'imaging', structuralTreeLabels.roiTableLabelDepth1);

                close all;
                BdaTpaList = [];
            end
        end
    end
end