function TestRunner

xmlfile = 'XmlPT3.xml';

bda_tpa_folder = 'E:\Data\Feedi\L5_PT_PD\HR5-1\02_15_16_S\Trials';

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
% [Neurons] = getAllExperimentNeurons(BdaTpaList(1).TPA);

% runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');
% now for more than 1 neuron
% xmlfile = 'XmlPT3.xml';

outputPath = 'E:\Data\Feedi\L5_PT_PD\HR5-1\02_15_16_S\Analysis\pcaTrajectories';
runAnalysis(outputPath, xmlfile, BdaTpaList, 'pcaTrajectories');

outputPath = 'E:\Data\Feedi\L5_PT_PD\HR5-1\02_15_16_S\Analysis\plotAllNrnsAcrossTrials';
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotAllNrnsAcrossTrials');
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');

outputPath = 'E:\Data\Feedi\L5_PT_PD\HR5-1\02_15_16_S\Analysis\Pca2D';
runAnalysis(outputPath, xmlfile, BdaTpaList, 'Pca2D');

outputPath = 'E:\Data\Feedi\L5_PT_PD\HR5-1\02_15_16_S\Analysis\diffMap2D';
runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMap2D');

outputPath = 'E:\Data\Feedi\L5_PT_PD\HR5-1\02_15_16_S\Analysis\diffMapTrajectories';
runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMapTrajectories');

outputPath = 'E:\Data\Feedi\L5_PT_PD\HR5-1\02_15_16_S\Analysis\Accuracy';
runAccuracy(outputPath, xmlfile, BdaTpaList, {'success','failure'});
% 
% outputPath = 'E:\Data\Shahar\Den7\All\Analysis\Accuracy';
% runAccuracy(outputPath, xmlfile, BdaTpaList, {'success','failure'});

% outputPath = 'E:\Data\Shahar\Den6\All\Analysis\PostAccuracy';

% Matlist{1} = 'E:\Data\Shahar\Den6\2_21_17_1\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{2} = 'E:\Data\Shahar\Den6\2_22_17_1\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{3} = 'E:\Data\Shahar\Den6\2_27_17_1\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{4} = 'E:\Data\Shahar\Den6\3_11_18_1\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{5} = 'E:\Data\Shahar\Den6\3_13_18_1\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{6} = 'E:\Data\Shahar\Den6\3_28_18_1\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{7} = 'E:\Data\Shahar\Den6\4_11_18_1\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{8} = 'E:\Data\Shahar\Den6\5_29_18_1\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat';
% Matlist{9} = 'E:\Data\Shahar\Den6\7_11_18_1\Analysis\Accuracy\acc_res_folds10lin_success_failure.mat';
% 
% runAverageAnalysis(outputPath, xmlfile, Matlist, 'accuracy');



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