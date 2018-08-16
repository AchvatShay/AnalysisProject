function TestRunner

xmlfile = 'XmlPT3.xml';

outputPath = 'res';
bda_tpa_folder = 'D:\Shay\work\PT3\3_13_18_1';

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