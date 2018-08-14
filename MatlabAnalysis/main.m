function main

xmlfile = 'XmlPT3.xml';
xmlfile = 'XmlPT3_1nrn.xml';
xmlfile = 'XmlPT3_nonrns.xml';


outputPath = 'res';
BdaTpaList(1).TPA = 'D:\Shay\work\PT3\3_13_18_1\TPA_TSeries_03132018_0944_001_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(2).TPA = 'D:\Shay\work\PT3\3_13_18_1\TPA_TSeries_03132018_0944_002_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(3).TPA = 'D:\Shay\work\PT3\3_13_18_1\TPA_TSeries_03132018_0944_003_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(4).TPA = 'D:\Shay\work\PT3\3_13_18_1\TPA_TSeries_03132018_0944_004_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(5).TPA = 'D:\Shay\work\PT3\3_13_18_1\TPA_TSeries_03132018_0944_005_Cycle00001_Ch2_000001_ome.mat';

BdaTpaList(1).BDA = 'D:\Shay\work\PT3\3_13_18_1\BDA_TSeries_03132018_0944_001_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(2).BDA = 'D:\Shay\work\PT3\3_13_18_1\BDA_TSeries_03132018_0944_002_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(3).BDA = 'D:\Shay\work\PT3\3_13_18_1\BDA_TSeries_03132018_0944_003_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(4).BDA = 'D:\Shay\work\PT3\3_13_18_1\BDA_TSeries_03132018_0944_004_Cycle00001_Ch2_000001_ome.mat';
BdaTpaList(5).BDA = 'D:\Shay\work\PT3\3_13_18_1\BDA_TSeries_03132018_0944_005_Cycle00001_Ch2_000001_ome.mat';

% this is just an example to see how to extract the neurons' names from a
% tpa file
[Neurons] = getAllExperimentNeurons(BdaTpaList(1).TPA);
% just checking if this code works with 1 neuron to plot or none
xmlfile = 'XmlPT3_1nrn.xml';
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');

xmlfile = 'XmlPT3_nonrns.xml';
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');
% now for more than 1 neuron
xmlfile = 'XmlPT3.xml';
runAnalysis(outputPath, xmlfile, BdaTpaList, 'pcaTrajectories');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotAllNrnsAcrossTrials');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'Pca2D');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMap2D');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMapTrajectories');


 [ res.quest.Trees{numConsecTrials}, ~, ~, res.quest.embedding{numConsecTrials}, dataN, vals] = RunGenericDimsQuestionnaire( params, permute(dataConsec{numConsecTrials},(runningOrder) ) );
    [~, ic]=sort(runningOrder);
    dataN = permute(dataN, ic);
    res.quest.eigs = vals;
    for k=1:size(dataConsec{numConsecTrials},3)
        alldata{numConsecTrials}(:, k) = reshape(dataN(:,:,k), size(dataConsec{numConsecTrials},1)*size(dataConsec{numConsecTrials},2),1);
    end
    for nr=1:size(dataConsec{numConsecTrials},1)
        alldataNT{numConsecTrials}(:, nr) = reshape(dataN(nr,:,:), size(dataConsec{numConsecTrials},2)*size(dataConsec{numConsecTrials},3),1);
    end
    
    res.quest.effectiveDim = max(getEffectiveDim(diag(vals{runningOrder== 1}), thEffDim),3);
    %     for nr = 1:res.quest.effectiveDim
    %         recon{nr} = linrecon(alldataNT{numConsecTrials}, mean(alldataNT{numConsecTrials},1),res.quest.embedding{numConsecTrials}{runningOrder==1}, nr);
    %         for l=1:size(recon{nr},2)
    %             res.quest.recon{numConsecTrials}{nr}(l,:,:) = reshape(recon{nr}(:,l),size(dataConsec{numConsecTrials},2),size(dataConsec{numConsecTrials},3));
    %         end
    %     end
    [reconeff, projeff] = linrecon(alldataNT{numConsecTrials}, mean(alldataNT{numConsecTrials},1),res.quest.embedding{numConsecTrials}{runningOrder==1}, 1:res.quest.effectiveDim);
    for l=1:size(reconeff,2)
        res.quest.reconeff{numConsecTrials}(l,:,:) = reshape(reconeff(:,l),size(dataConsec{numConsecTrials},2),size(dataConsec{numConsecTrials},3));
    end
    for l=1:size(projeff,2)
        res.quest.projeff{numConsecTrials}(l,:,:) = reshape(projeff(:,l),size(dataConsec{numConsecTrials},2),size(dataConsec{numConsecTrials},3));
    end


