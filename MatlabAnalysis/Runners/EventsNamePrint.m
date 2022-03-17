function EventsNamePrint()
 addpath('../');
 
folderExperiment = '\\192.114.21.82\d\Layer V\Analysis\#2\09.02.20_Soma';

listExperiments = dir(strcat(folderExperiment,'\BDA*'));

for i = 1 : length(listExperiments)
    BDAList{i} = strcat(listExperiments(i).folder, '\', listExperiments(i).name); 
end

results = getAllExperimentLabels(BDAList);

disp(results);
end