function plotGLMResults(typesU, timesegments, energyTh, R2full_te, R2p_test, outputpath, imagingData, generalProperty)
    for seg_i = 1:size(timesegments, 2)
        inds{seg_i}=find(mean(R2full_te{seg_i},2)>energyTh);

        cont{seg_i}=max(0, 1-bsxfun(@rdivide, mean(R2p_test{seg_i}(inds{seg_i},:,:),3),mean(R2full_te{seg_i}(inds{seg_i},:),2)));
        cont{seg_i}=bsxfun(@rdivide, cont{seg_i}, sum(cont{seg_i},2));

        f = plotMeanCont(seg_i, cont, typesU, generalProperty.RoiSplit_I1, inds{seg_i}, generalProperty.RoiSplit_d1);
        mysave(f, fullfile(outputpath, sprintf('SegmentMeanCont_ts%d_split1', seg_i)));
        close(f);

        f = plotMeanCont(seg_i, cont, typesU, generalProperty.RoiSplit_I2, inds{seg_i}, generalProperty.RoiSplit_d2);
        mysave(f, fullfile(outputpath, sprintf('SegmentMeanCont_ts%d_split2', seg_i)));
        close(f);
        
        f = plotMeanContAll(seg_i, cont, typesU);
        mysave(f, fullfile(outputpath, sprintf('SegmentMeanCont_ts%d_All', seg_i)));
        close(f);
        
        f = plotPerRoiCont(seg_i, cont, imagingData, generalProperty.RoiSplit_d1, inds{seg_i}, R2full_te, typesU);   

    %     suptitle(sprintf('Segment %d', seg_i));
        mysave(f, fullfile(outputpath, sprintf('NeuronAll_ts%d_Contribute_colo1', seg_i)));
        close(f);

        f = plotPerRoiCont(seg_i, cont, imagingData, generalProperty.RoiSplit_d2, inds{seg_i}, R2full_te, typesU);        

    %     suptitle(sprintf('Segment %d', seg_i));
        mysave(f, fullfile(outputpath, sprintf('NeuronAll_ts%d_Contribute_colo2', seg_i)));
        close(f);
        
        f = plotRHistogram(seg_i, R2full_te, imagingData, generalProperty.RoiSplit_d1);
        mysave(f, fullfile(outputpath, sprintf('NeuronAll_ts%d_R2_colo1', seg_i)));
        close(f);
        
        f = plotRHistogram(seg_i, R2full_te, imagingData, generalProperty.RoiSplit_d2);
        mysave(f, fullfile(outputpath, sprintf('NeuronAll_ts%d_R2_colo2', seg_i)));
        close(f);
    end

    roiNamesL = imagingData.roiNames(:, 1);
    save(fullfile(outputpath, 'glmResultsSummary'), 'cont', 'inds', 'roiNamesL');   
end

function f = plotRHistogram(seg_i, R2full_te, imagingData, RoiSplit)
    f = figure;
    hold on;
    title('R^2 For ROI"s Full Model');
    
    for k=1:(size(R2full_te{seg_i},1))
        binH(k) = mean(R2full_te{seg_i}(k,:),2);
    end
    
    [sortBin, sortIndex] = sort(binH);
    b = bar(sortBin);
    xtickangle(90);
    xticks(1:length(binH));
    xticklabels(imagingData.roiNames(sortIndex,1));
    b.FaceColor = 'flat';
    b.CData = RoiSplit(sortIndex,:);
    xlabel('ROI#');
    ylabel('R^2');
end

function f = plotPerRoiCont(seg_i, cont, imagingData, RoiSplit, inds, R2full_te, typesU)
    subplot_rows = 5;
    subplotsize = ceil(length(inds) ./ (subplot_rows));

    f = figure;
    hold on;

    for k=1:(size(cont{seg_i},1))
        s = subplot(5,subplotsize,k);
        bar(cont{seg_i}(k,:), 'FaceColor',[230,230,250] ./ 255);
        title({'', [sprintf('{\\color[rgb]{%f,%f,%f}', RoiSplit(inds(k), 1), ...
            RoiSplit(inds(k), 2), RoiSplit(inds(k), 3)) ,...
            'ROI ' num2str(imagingData.roiNames(inds(k), 1)) ' R^2=' num2str(mean(R2full_te{seg_i}(inds(k),:),2)) , '}']});

        set(gca,'XTick',1:length(typesU));
        xtickangle(90);
        xticklabels(typesU);
        ax = gca;
        ax.FontSize = 8;
        s.Position = [s.Position(1), s.Position(2), s.Position(3), s.Position(4) * 0.7];
    end   
end

function f = plotMeanCont(seg_i, cont, typesU, split, inds, colorMat)
    classU = unique(split);
    
    f = figure;
    hold on;
    suptitle(['Contribution Averaged Across ROI''s',' Segment ' num2str(seg_i)]);
    
    rowCount = ceil(length(classU) / 3);
    
    if rowCount == 1
        rowCount = 2;
    end
    
    for i = 1:length(classU)
        locationL = find(split == classU(i));
        locationL = ismember(inds, locationL); 
        
        if ~any(locationL)
            continue;
        end
        
        subplot(rowCount,3,(i));       
        hold on;
        if sum(locationL) == 1
            M = cont{seg_i}(locationL,:);
        else
            M = mean(cont{seg_i}(locationL,:));
            S=std(cont{seg_i}(locationL, :))/sqrt(size(cont{seg_i}(locationL, :),1)-1);
            errorbar(1:length(M),M,S,'LineStyle','none','Color','k');
        end
        
        bar(M, 'FaceColor',[230,230,250] ./ 255);hold all;
        
        tColorI = inds(locationL);
        title([sprintf('{\\color[rgb]{%f,%f,%f}', colorMat(tColorI(1), 1), ...
                colorMat(tColorI(1), 2), colorMat(tColorI(1), 3)), 'ROI"s Subtree}']);
        set(gca,'XTick',1:length(typesU));
        xtickangle(90);
        xticklabels(typesU);
    end
    
    subplot(rowCount,3,length(classU)+1);
    M=mean(cont{seg_i});
    S=std(cont{seg_i})/sqrt(size(cont{seg_i},1)-1);
    bar(M, 'FaceColor',[230,230,250] ./ 255);hold all;
    errorbar(1:length(M),M,S,'LineStyle','none','Color','k')
    title(['ROI"s All']);
    set(gca,'XTick',1:length(typesU));
    xtickangle(90);
    xticklabels(typesU);
end

function f = plotMeanContAll(seg_i, cont, typesU)
    f = figure;
    hold on;
    suptitle(['Contribution Averaged Across ROI''s',' Segment ' num2str(seg_i)]);

    subplot(2,1,1);
    M=mean(cont{seg_i});
    S=std(cont{seg_i})/sqrt(size(cont{seg_i},1)-1);
    bar(M, 'FaceColor',[230,230,250] ./ 255);hold all;
    errorbar(1:length(M),M,S,'LineStyle','none','Color','k')
    title(['ROI"s All']);
    set(gca,'XTick',1:length(typesU));
    xtickangle(90);
    xticklabels(typesU);
end