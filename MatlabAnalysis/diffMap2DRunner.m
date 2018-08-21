function diffMap2DRunner

xmlfile = 'D:\Shay\work\AnalysisProject\manager\src\main\webapp\resources\AnalysisResults\Shay\MainProject\TestAn\XmlAnalysis.xml';

outputPath = 'res';
bda_tpa_folder = 'E:\Data\M26\9_28_17';

listFiles = dir(bda_tpa_folder);

bdaCount = 1;
tpaCount = 1;
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

% this is just an example to see how to extract the neurons' names from a
% tpa file
[Neurons] = getAllExperimentNeurons(BdaTpaList(1).TPA);

runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMap2D');
