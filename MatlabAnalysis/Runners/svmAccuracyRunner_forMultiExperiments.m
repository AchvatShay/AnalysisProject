function svmAccuracyRunner_forMultiExperiments

addpath('../');

xmlfile = 'XmlByBoth.xml';

% folderAnimal = 'F:\Data\M26\';
% folderAnimalOutputPath = 'F:\Data\Test\M26\';
folderAnimal = '\\192.114.20.85\d\Maria\Layer 2-3\Analysis\M27\';
folderAnimalOutputPath='C:\Users\Jackie.MEDICINE\Dropbox (Technion Dropbox)\AnalysisResultsShay\Hadas\analysisRes\M27';


listExperiments = dir (folderAnimal);
bdaCount = 1;
for index = 1: length(listExperiments)

    if ~strcmp(listExperiments(index).name, '..') && ~strcmp(listExperiments(index).name, '.')
        bda_tpa_folder = strcat(listExperiments(index).folder, '\',listExperiments(index).name);
        listFiles = dir(bda_tpa_folder);
        
        if ~isempty(listFiles)
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
        end
    end
end

    outputPath = strcat(folderAnimalOutputPath , '\All\' , '\Analysis\svmAccuracy');
    mkdir(outputPath);
    runAnalysis(outputPath, xmlfile, BdaTpaList, 'svmAccuracy', 'imaging');
end