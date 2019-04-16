function delay2eventsRunner

addpath('../');
xmlfile = 'XmlByBoth.xml';

folderAnimal = '\\192.114.20.85\d\Maria\Layer 2-3\Analysis\M26';
folderAnimalOutputPath = 'C:\Users\Jackie.MEDICINE\Dropbox (Technion Dropbox)\AnalysisResultsShay\Jackie\Delay2eventsResults\M26';


% if you want to run only one date from the animal experiments change the 
% value here to the date you want. but if you want all dates in the foulder
% use specific_experiment = '';
specific_experiment = '1_8_18'  ;

listExperiments = dir (folderAnimal);

for index = 1: length(listExperiments)      
    if ~strcmp(listExperiments(index).name, '..') && ~strcmp(listExperiments(index).name, '.') && ~contains(listExperiments(index).name, '_NOT') && isfolder([listExperiments(index).folder, '\',listExperiments(index).name])
        
        if (sum(strcmp(specific_experiment, listExperiments(index).name))== 1)
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

                outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\delay2events');
                mkdir(outputPath);
                runAnalysis(outputPath, xmlfile, BdaTpaList, 'delay2events', 'imaging');

                close all;
                BdaTpaList = [];
            end
        end
    end
end