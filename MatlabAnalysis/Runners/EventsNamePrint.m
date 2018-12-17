function EventsNamePrint()
 addpath('../');
 
folderExperiment = 'D:\Shay\work\DB Mount\Dropbox (Technion Dropbox)\AnalysisResultsShay\Jackie\M27\2_8_18\';

listExperiments = dir(strcat(folderExperiment,'\BDA*'));

for i = 1 : length(listExperiments)
    BDAList{i} = strcat(listExperiments(i).folder, '\', listExperiments(i).name); 
end

results = getAllExperimentLabels(BDAList);

disp(results);
end