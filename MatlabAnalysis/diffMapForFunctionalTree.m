function diffMapForFunctionalTree(outputPath, generalProperty, imagingData, BehaveData, structuralTreeLabels)

        % requested labels
        [labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
        generalProperty.labels2cluster, generalProperty.includeOmissions);
        [prevcurlabs, prevCurrLUT] = getPrevCurrLabels(labels, labelsLUT);

        labelsFontSz = generalProperty.visualization_labelsFontSize;
        legendLoc = generalProperty.visualization_legendLocation;        

        % analysis
        X = imagingData.samples(:, :, examinedInds);
        
        [cls, ~] = cellClr2matClrs(generalProperty.labels2clusterClrs, generalProperty.prevcurrlabels2clusterClrs);

        mkdir([outputPath , '\AllTimeAllTrialsOriginalData\']);
        
        plotEmbedding(labelsFontSz, legendLoc, [outputPath , '\AllTimeAllTrialsOriginalData\'], X, generalProperty.analysis_pca_thEffDim, generalProperty.foldsNum, labels, structuralTreeLabels.labels, examinedInds, eventsStr, ...
            structuralTreeLabels.eventsStr, labelsLUT,  structuralTreeLabels.labelsLUT, cls, structuralTreeLabels.cls, 'allTrial', imagingData.roiNames(:,1), 'Trial')
        
        mkdir([outputPath , '\AllTimeAllTrialsFilterData\']);
        
        plotEmbedding(labelsFontSz, legendLoc,[outputPath , '\AllTimeAllTrialsFilterData\'], structuralTreeLabels.activity.dataTrials, generalProperty.analysis_pca_thEffDim, generalProperty.foldsNum, labels, structuralTreeLabels.labels, examinedInds, eventsStr, ...
            structuralTreeLabels.eventsStr, labelsLUT,  structuralTreeLabels.labelsLUT, cls, structuralTreeLabels.cls, 'allTrial', imagingData.roiNames(:,1), 'Trial')
       
        classesE = unique(structuralTreeLabels.activity.labels);
        for index = 1:length(classesE)
            clrsE(index, :) = rand(1,3);
            nameLUTE(index) = {sprintf('cluster %0d', index)};
            
            mkdir([outputPath , '\AllTimesFilterData_' , nameLUTE{index} , '\']);
        
            loactionIndexLabels = structuralTreeLabels.activity.labels == classesE(index);
            
            if sum(loactionIndexLabels) <= 2
                continue;
            end
            
            plotEmbedding(labelsFontSz, legendLoc,[outputPath , '\AllTimesFilterData_' , nameLUTE{index} , '\'], structuralTreeLabels.activity.dataEvents(:,:, loactionIndexLabels),...
                generalProperty.analysis_pca_thEffDim, generalProperty.foldsNum, structuralTreeLabels.activity.labels(loactionIndexLabels),...
                structuralTreeLabels.labels, 1:size( structuralTreeLabels.activity.labels(loactionIndexLabels),1), 'EventsCluster', ...
                structuralTreeLabels.eventsStr, nameLUTE(index),  structuralTreeLabels.labelsLUT, clrsE, structuralTreeLabels.cls, 'allEvents', imagingData.roiNames(:,1), 'Event')

        end
        
        mkdir([outputPath , '\AllTimeAllEventsFilterData\']);
        
        plotEmbedding(labelsFontSz, legendLoc,[outputPath , '\AllTimeAllEventsFilterData\'], structuralTreeLabels.activity.dataEvents, generalProperty.analysis_pca_thEffDim, generalProperty.foldsNum, structuralTreeLabels.activity.labels, structuralTreeLabels.labels, 1:size( structuralTreeLabels.activity.labels,1), 'EventsCluster', ...
            structuralTreeLabels.eventsStr, nameLUTE,  structuralTreeLabels.labelsLUT, clrsE, structuralTreeLabels.cls, 'allEvents', imagingData.roiNames(:,1), 'Event')
      
end

function plotFunctionalTreeROI(roiTree, roiNames, X, outputPath)
    for t=2:length(roiTree)
        for le = 1:roiTree{t}.folder_count
            nrns2plot = find(roiTree{t}.clustering==le);
            if length(nrns2plot)>16
                continue;
            end

            f = figure;
            R = ceil(sqrt(length(nrns2plot)));
            for r = 1:length(nrns2plot)
                subplot(R,R,r);
                imagesc(squeeze(X(nrns2plot(r),:,:))', [-0.15,2]);
                title(roiNames(nrns2plot(r)));% replace with nrn's name
            end

            suptitle(['Tree level' num2str(t) ' folder label' num2str(le)]);
            
            mysave(f, [outputPath '\RoiInTreeBylevel' num2str(t) '_folderlabel' num2str(le)]);       
        end
    end
end

function plotEmbedding(labelsFontSz, legendLoc, outputPath, dataMatrix, analysis_pca_thEffDim, foldsNum, labels, labels_roi, examinedInds, eventsStr,eventsStr_roi, labelsLUT,  labelsLUT_roi, cls, cls_roi, methodRun, roiNames, splitType)
    if exist(fullfile(outputPath, ['diff_map_res_by' methodRun eventsStr '.mat']), 'file')
        load(fullfile(outputPath, ['diff_map_res_by' methodRun eventsStr '.mat']));
    else
        [resDiffMap, runningOrder] = diffMapAnalysis(dataMatrix, analysis_pca_thEffDim);
        embedding_ROI = resDiffMap.embedding{runningOrder==1}(:,1:2);
        embedding = resDiffMap.embedding{runningOrder==3}(:,1:2);
        
        ACC2D_ROI = svmClassifyAndRand(embedding_ROI, labels_roi, labels_roi, foldsNum, '', 1, 0);
        ACC2D = svmClassifyAndRand(embedding, labels, labels, foldsNum, '', 1, 0);

        save(fullfile(outputPath, ['diff_map_res_by' methodRun eventsStr '.mat']), 'resDiffMap', 'ACC2D_ROI', 'ACC2D', 'runningOrder');
    end

    embedding_order_1 = resDiffMap.embedding{runningOrder==1};
    plot2Dembedding(roiNames, outputPath, eventsStr_roi, labelsLUT_roi, labels_roi, embedding_order_1, cls_roi, 'diffMapByROI', legendLoc, labelsFontSz);
    
    embedding_order_3 = resDiffMap.embedding{runningOrder==3};
    plot2Dembedding(examinedInds, outputPath, eventsStr, labelsLUT, labels, embedding_order_3, cls, ['diffMapBy', splitType], legendLoc, labelsFontSz);
       
    fid = fopen(fullfile(outputPath, 'diffMap_accuracy2D.txt'), 'w');
    fprintf(fid, 'Accuracy of %s:\t\tmean = %f std = %f\n', 'diffMapByROI', ACC2D_ROI.mean, ACC2D_ROI.std);
    fprintf(fid, 'Accuracy of %s:\t\tmean = %f std = %f\n', ['diffMapBy' , splitType], ACC2D.mean, ACC2D.std);
    b1 = hist(labels_roi, unique(labels_roi));
    b1=b1/sum(b1);

    b2 = hist(labels, unique(labels));
    b2=b2/sum(b2);

    fprintf(fid, '%s Chance:\t %f\n','diffMapByROI', max(b1));
    fprintf(fid, '%s Chance:\t %f\n', ['diffMapBy' , splitType], max(b2));
    
    fclose(fid);
    
    roiTree = resDiffMap.Trees{runningOrder==1};

    f3 = figure;
    plotTreeWithColors(resDiffMap.Trees{runningOrder==3}, labels);
    title(['Tree of ' splitType]);
    mysave(f3, [outputPath, '\diffmap_treeBy', splitType]);

    f2 = figure;
    plotTreeWithColors(resDiffMap.Trees{runningOrder==2}, 1:size(dataMatrix,2));
    title('Tree of Time');
    mysave(f2, [outputPath, '\diffmap_treeByTime']);

    f1 = figure;
    plotTreeWithColorsROIS(resDiffMap.Trees{runningOrder==1}, labels_roi, roiNames, cls_roi, labelsLUT_roi);
    title('Tree of ROI');
    mysave(f1, [outputPath, '\diffmap_treeByROI']);

    plotFunctionalTreeROI(roiTree, roiNames, dataMatrix, outputPath);
end

