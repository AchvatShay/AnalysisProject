function PostAnalysisRunner
addpath('../');

xmlfile = 'XmlByBoth.xml';

BDA_folders{1} = '\\192.114.20.192\g\Yael\2pData\Analysis\SLC3\11_19_2015\11192015_1\';
BDA_folders{2} = '\\192.114.20.192\g\Yael\2pData\Analysis\SLC3\11_22_2015\11222015_1\';
BDA_folders{3} = '\\192.114.20.192\g\Yael\2pData\Analysis\SLC3\11_23_2015\11232015_1\';
% BDA_folders{4} = '\\192.114.20.192\g\Yael\2pData\Analysis\SLC3\11_25_2015\11252015_1\';



outputPath = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\SLC3\';
mkdir(outputPath);
BdaTpaList=[];
bdaCount = 1;
for i = 1: length(BDA_folders)
    testBDA = dir([BDA_folders{i} '/BDA*.mat']);
    testTPA = dir([BDA_folders{i} '/TPA*.mat']);
    for k=1:length(testBDA)
        BdaTpaList(bdaCount).BDA = [BDA_folders{i} '\' testBDA(k).name ];
        BdaTpaList(bdaCount).TPA = [BDA_folders{i} '\' testTPA(k).name ];
        bdaCount = bdaCount + 1;
    end
    
    
end
dirs = dir(outputPath);


%% dprime
Matlist=[];
for k=3:length(dirs)
    if  dirs(k).isdir
        filedprime = dir( fullfile(outputPath, dirs(k).name, '/**/svmAccuracy/acc_res_folds10lin_success_failure.mat') );
        if isempty(filedprime)
            continue;
        end
        Matlist{end+1} = fullfile(filedprime.folder, filedprime.name);
    end
end
runAverageAnalysis(outputPath, xmlfile,BdaTpaList, Matlist, 'svmAccuracy');
% %% dprime smooth
% clear filedprime;
% Matlist=[];
% for k=3:length(dirs)
%     if  dirs(k).isdir
%         filedprime = dir( fullfile(outputPath, dirs(k).name, '/**/pcaTrajectories/dprimeAndNext_smoothed.mat') );
%         Matlist{end+1} = fullfile(filedprime.folder, filedprime.name);
%     end
% end
% runAverageAnalysis(outputPath, xmlfile,BdaTpaList, Matlist, 'dprime');

% %% indicative
% clear filedprime;
% for l=3:length(dirs)
% temp = dir(fullfile(outputPath, dirs(l).name, '/**/SingleNeuronAnalysis/indicativeNrs*.mat'));
% if ~isempty(temp)
%     break;
% end
%     
% end
% for k=1:length(temp)
%     pvvalues(k) = sscanf(temp(k).name, 'indicativeNrs%fpercentfolds10lin_success_failure.mat');
% end
% for pii = 1:length(pvvalues)
%     Matlist=[];
%     for k=3:length(dirs)
%         if  dirs(k).isdir
%             filedprime = dir( fullfile(outputPath, dirs(k).name, ['/**/SingleNeuronAnalysis/indicativeNrs' num2str(pvvalues(pii)) 'percentfolds10lin_success_failure.mat']) );
%             if isempty(filedprime)
%                 continue;
%             end
%             Matlist{end+1} = fullfile(filedprime.folder, filedprime.name);
%         end
%     end
%     mkNewFolder([outputPath '/indicativeAllpvalue' num2str(pvvalues(pii))]);
%     runAverageAnalysis([outputPath '/indicativeAllpvalue' num2str(pvvalues(pii))], xmlfile,BdaTpaList, Matlist, 'SingleNeuronAnalysis');
% end
%% significant
clear filedprime;
for l=3:length(dirs)
temp = dir(fullfile(outputPath, dirs(l).name, '/**/SingleNeuronSignificantAnalysis/significantNrs*.mat'));
if ~isempty(temp)
    break;
end
    
end
for k=1:length(temp)
    pvvalues(k) = sscanf(temp(k).name, 'significantNrs%fpercent_success_failure.mat');
end
Matlist=[];
for pii = 1:length(pvvalues)
    Matlist=[];
    for k=3:length(dirs)
        if  dirs(k).isdir
            filedprime = dir( fullfile(outputPath, dirs(k).name, ['/**/SingleNeuronSignificantAnalysis/significantNrs' num2str(pvvalues(pii)) 'percent_success_failure.mat']) );
            if isempty(filedprime)
                continue;
            end
            Matlist{end+1} = fullfile(filedprime.folder, filedprime.name);
        end
    end
    mkNewFolder([outputPath '/significantAllpvalue' num2str(pvvalues(pii))]);
    runAverageAnalysis([outputPath '/significantAllpvalue' num2str(pvvalues(pii))], xmlfile,BdaTpaList, Matlist, 'SingleNeuronSignificantAnalysis');
end







end
