function TestRunner

xmlfile = 'XmlTest2.xml';
% 
folderAnimal = 'E:\Data\M26\';
folderAnimalOutputPath = 'E:\Data\Shahar\AnalysisResults\M26-11_16_17-plotAllNrnsAcrossTrials-ByBoth';
listExperiments = dir (folderAnimal);

for index = 1: length(listExperiments)
%     strcmp(listExperiments(index).name, '8_26_18') &&
    if strcmp(listExperiments(index).name, '11_16_17') && ~strcmp(listExperiments(index).name, 'All') && ~strcmp(listExperiments(index).name, '..') && ~contains(listExperiments(index).name, 'NOT') && ~strcmp(listExperiments(index).name, '.')
        bda_tpa_folder = strcat(listExperiments(index).folder, '\',listExperiments(index).name, '\Trials');
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

%              outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\pcaTrajectories');
%              mkdir(outputPath);
%             runAnalysis(outputPath, xmlfile, BdaTpaList, 'pcaTrajectories');
%               
%             outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\plotSingleNrnAcrossTrials');
%             mkdir(outputPath);
%             runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');
% 
% 
            outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\plotAllNrnsAcrossTrials');
            mkdir(outputPath);
            runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotAllNrnsAcrossTrials');
% % 
%             outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\Pca2D');
%             mkdir(outputPath);
%             runAnalysis(outputPath, xmlfile, BdaTpaList, 'Pca2D');
% 
%             outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\diffMap2D');
%             mkdir(outputPath);
%             runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMap2D');

%             outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\diffMapTrajectories');
%             mkdir(outputPath);
%             runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMapTrajectories');
% %             
%             outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\svmAccuracy');
%             mkdir(outputPath);
%             runAnalysis(outputPath, xmlfile, BdaTpaList, 'svmAccuracy');
%            
%             outputPath = strcat(folderAnimalOutputPath , '\' , listExperiments(index).name ,'\Analysis\SingleNeuronAnalysis');
%             mkdir(outputPath);
%             runAnalysis(outputPath, xmlfile, BdaTpaList, 'SingleNeuronAnalysis');
% % %             
            close all;
            BdaTpaList = [];
        end
    end
end


% outputPath = strcat(folderAnimalOutputPath , '\All\svmAccuracy');
% mkdir(outputPath);
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'svmAccuracy');

% 
% folderAnimal = 'E:\Data\Shahar\Den6Analysis\';
% folderAnimalOutputPath = 'E:\Data\Shahar\Den6Analysis\All\PostAnalysis\Accuracy';
% listExperiments = dir (folderAnimal);
%  bdaCount = 1;
% for index = 1: length(listExperiments)
%     if ~strcmp(listExperiments(index).name, 'All') && ~strcmp(listExperiments(index).name, '..') && ~strcmp(listExperiments(index).name, '.') && ~contains(listExperiments(index).name, 'Cat')
%         bda_tpa_folder = strcat(listExperiments(index).folder, '\',listExperiments(index).name, '\Analysis\Accuracy\');
%         listFiles = dir(bda_tpa_folder);
%         
%         if ~isempty(listFiles)
%             for i = 1: length(listFiles)
%                 testBDA = listFiles(i).name;
%                 if strcmp(testBDA, 'acc_res_folds10lin_success_failure.mat')
%                     MatFiles{bdaCount} = [bda_tpa_folder '\' testBDA]; 
%                     bdaCount = bdaCount + 1;
%                 end
%             end
%         end
%     end
% end
% 
% mkdir(folderAnimalOutputPath);
% runAverageAnalysis(folderAnimalOutputPath, xmlfile, MatFiles, 'accuracy', {'success','failure'});
% close all;
% MatFiles = [];
% 
% 


% bda_tpa_folder = 'E:\Data\Feedi\L5_PT_PD\HR5-3\05_29_17_S\Trials';
% listFiles = dir(bda_tpa_folder);
% 
% bdaCount = 1;
% tpaCount = 1;
% for i = 1: length(listFiles)
%     testBDA = listFiles(i).name;
%     if contains(testBDA, 'BDA')
%         BdaTpaList(bdaCount).BDA = [bda_tpa_folder '\' testBDA]; 
%         
%         for k = 1: length(listFiles)
%             if contains(listFiles(k).name, 'TPA')
%                 testTPA = strrep(listFiles(k).name,'TPA','BDA');
%                 if (strcmp(testTPA, testBDA))
%                     BdaTpaList(bdaCount).TPA = [bda_tpa_folder '\' listFiles(k).name]; 
%                     bdaCount = bdaCount + 1;
%                 end
%             end
%         end
%     end
% end

% now for more than 1 neuron
% xmlfile = 'XmlPT3.xml';
% 
% outputPath = 'E:\Data\Feedi\L5_PT_PD\HR5-3Results\05_29_17_S\Analysis\pcaTrajectories';
% mkdir(outputPath);
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'pcaTrajectories');
% 
% outputPath = 'E:\Data\Feedi\L5_PT_PD\HR5-3Results\05_29_17_S\Analysis\plotAllNrnsAcrossTrials';
% mkdir(outputPath);
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotAllNrnsAcrossTrials');
% % runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');
% 
% outputPath = 'E:\Data\Feedi\L5_PT_PD\HR5-3Results\05_29_17_S\Analysis\Pca2D';
% mkdir(outputPath);
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'Pca2D');
% 
% outputPath = 'E:\Data\Feedi\L5_PT_PD\HR5-3Results\05_29_17_S\Analysis\diffMap2D';
% mkdir(outputPath);
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMap2D');
% 
% outputPath = 'E:\Data\Feedi\L5_PT_PD\HR5-3Results\05_29_17_S\Analysis\diffMapTrajectories';
% mkdir(outputPath);
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMapTrajectories');
% 
% outputPath = 'E:\Data\Feedi\L5_PT_PD\HR5-3Results\05_29_17_S\Analysis\Accuracy';
% mkdir(outputPath);
% runAccuracy(outputPath, xmlfile, BdaTpaList, {'success','failure'});
% close all;
% outputPath = 'E:\Data\Shahar\PT3Analysis\All\Analysis\Accuracy';
% runAccuracy(outputPath, xmlfile, BdaTpaList, {'success','failure'});
% % 
% outputPath = 'E:\Data\Shahar\AnalysisResults\new\Den6Analysis\All\PostAnalysis';
% mkdir(outputPath);
% folderAnimal = 'E:\Data\Shahar\PT3\';
% listExperiments = dir (folderAnimal);
% count = 1;
% for index = 1: length(listExperiments)    
%     if ~strcmp(listExperiments(index).name, 'All')
%         Matlist{count} = strcat('E:\Data\Shahar\PT3Results\', listExperiments(index).name, '\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat');
%     end
% % end
% 
% outputPath = 'E:\Data\Shahar\J\Den6\PostAnalysisNewBy-Suc-Cat23';
% mkdir(outputPath);
% 
% pth = 'E:\Data\Shahar\Den6\2_21_17_1\Trials';
% 
% for k=36:46
% BdaTpaList(k).TPA = fullfile(pth, ['TPA_TSeries_02212017_1040_' sprintf('%03d',k) '_Cycle00001_Ch2_000001_ome.mat']);
% BdaTpaList(k).BDA = fullfile(pth, ['BDA_TSeries_02212017_1040_' sprintf('%03d',k) '_Cycle00001_Ch2_000001_ome.mat']);
% end

% Matlist{1} = 'E:\Results9_9_17\Den6Analysis\2_21_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{1} = 'E:\Results9_9_17\Den6Analysis\2_22_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{2} = 'E:\Results9_9_17\Den6Analysis\2_27_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{3} = 'E:\Results9_9_17\Den6Analysis\2_23_17_1_1stAndThird\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{5} = 'E:\Results9_9_17\Den6Analysis\3_1_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{5} = 'E:\Results9_9_17\Den6Analysis\4_2_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{7} = 'E:\Results9_9_17\Den6Analysis\2_21_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{8} = 'E:\Data\Results\Den6Analysis\8_13_17_1\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{9} = 'E:\Data\Results\Den7Analysis\8_10_17_1 (1)\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{10} = 'E:\Data\Results\Den7Analysis\8_13_17_1 (1)\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';

% Matlist{8} = 'E:\Data\Feedi\L5_PT_PD\HR5-10Results\8_13_17_1 (1)\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{7} = 'E:\Data\Shahar\Den6Results\8_7_17_1 (1)\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{8} = 'E:\Data\Shahar\Den6Results\8_9_17_1 (1)\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{9} = 'E:\Data\Shahar\Den6Results\8_10_17_1 (1)\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{9} = 'E:\Data\Shahar\Den6Results\8_13_17_1 (1)\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat';

% runAverageAnalysis(outputPath, xmlfile,BdaTpaList(36:46), Matlist, 'accuracy');

% 
% 
% 
% 
%  [ res.quest.Trees{numConsecTrials}, ~, ~, res.quest.embedding{numConsecTrials}, dataN, vals] = RunGenericDimsQuestionnaire( params, permute(dataConsec{numConsecTrials},(runningOrder) ) );
%     [~, ic]=sort(runningOrder);
%     dataN = permute(dataN, ic);
%     res.quest.eigs = vals;
%     for k=1:size(dataConsec{numConsecTrials},3)
%         alldata{numConsecTrials}(:, k) = reshape(dataN(:,:,k), size(dataConsec{numConsecTrials},1)*size(dataConsec{numConsecTrials},2),1);
%     end
%     for nr=1:size(dataConsec{numConsecTrials},1)
%         alldataNT{numConsecTrials}(:, nr) = reshape(dataN(nr,:,:), size(dataConsec{numConsecTrials},2)*size(dataConsec{numConsecTrials},3),1);
%     end
%     
%     res.quest.effectiveDim = max(getEffectiveDim(diag(vals{runningOrder== 1}), thEffDim),3);
%     %     for nr = 1:res.quest.effectiveDim
%     %         recon{nr} = linrecon(alldataNT{numConsecTrials}, mean(alldataNT{numConsecTrials},1),res.quest.embedding{numConsecTrials}{runningOrder==1}, nr);
%     %         for l=1:size(recon{nr},2)
%     %             res.quest.recon{numConsecTrials}{nr}(l,:,:) = reshape(recon{nr}(:,l),size(dataConsec{numConsecTrials},2),size(dataConsec{numConsecTrials},3));
%     %         end
%     %     end
%     [reconeff, projeff] = linrecon(alldataNT{numConsecTrials}, mean(alldataNT{numConsecTrials},1),res.quest.embedding{numConsecTrials}{runningOrder==1}, 1:res.quest.effectiveDim);
%     for l=1:size(reconeff,2)
%         res.quest.reconeff{numConsecTrials}(l,:,:) = reshape(reconeff(:,l),size(dataConsec{numConsecTrials},2),size(dataConsec{numConsecTrials},3));
%     end
%     for l=1:size(projeff,2)
%         res.quest.projeff{numConsecTrials}(l,:,:) = reshape(projeff(:,l),size(dataConsec{numConsecTrials},2),size(dataConsec{numConsecTrials},3));
%     end