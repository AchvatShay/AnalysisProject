function EventsNamePrint()
 addpath('../');
 
folderExperiment = '\\192.114.20.192\d\Maria\Analysis\M35\3_31_19_empty_BDA_TPA';

listExperiments = dir(strcat(folderExperiment,'\BDA*'));

for i = 1 : length(listExperiments)
    BDAList{i} = strcat(listExperiments(i).folder, '\', listExperiments(i).name); 
end

results = getAllExperimentLabels(BDAList);

disp(results);
end