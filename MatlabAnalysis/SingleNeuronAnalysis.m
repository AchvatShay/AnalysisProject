function SingleNeuronAnalysis(outputPath, generalProperty, imagingData, BehaveData)

[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(...
    BehaveData, generalProperty.labels2cluster, generalProperty.includeOmissions);

foldsnum = generalProperty.foldsNum;
islin = generalProperty.linearSVN;
duration = generalProperty.Duration;
[winstSec, winendSec] = getFixedWinsFine(duration, generalProperty.slidingWinLen, generalProperty.slidingWinHop);

foldstr = ['folds' num2str(foldsnum)];
if islin
    linstr = 'lin';
else
    linstr = 'Rbf';
end

resfile_curr = fullfile(outputPath, ['acc_res_SN_curr_' foldstr linstr eventsStr '.mat']);
data4Svm = imagingData.samples(:, :, examinedInds);
if exist(resfile_curr, 'file')
    load(resfile_curr);
else
    [chanceLevel, tmid, SVMsingle, trialsNum] = slidingWinAccSN(data4Svm, resfile_curr, ...
        labels, winstSec, winendSec, foldsnum, islin, duration);
end
% indicative: above chance with 5% or 1% confidence interval
SEM = SVMsingle.raw.acc.std/sqrt(trialsNum);               % Standard Error
pvalues = generalProperty.indicativePvalues;
for pii = 1:length(pvalues)
    
    ts = tinv(1-2*pvalues(pii), (trialsNum)-1);      % T-Score
    isindicative = SVMsingle.raw.acc.mean-ts*SEM > chanceLevel;
    t = linspace(0, generalProperty.Duration, size(data4Svm, 2));
    % to run only on two label clustering
    classes = unique(labels);
    
    % visualize
    labelsFontSz = generalProperty.visualization_labelsFontSize;
    xlimmin = generalProperty.visualization_startTime2plot;
    conf_percent4acc = generalProperty.visualization_conf_percent4acc;
    toneTime = generalProperty.ToneTime;
    duration = generalProperty.Duration;
    time2st = findClosestDouble(tmid-toneTime, generalProperty.indicativeNrnsMeanStartTime);
    time2end = findClosestDouble(tmid-toneTime, generalProperty.indicativeNrnsMeanEndTime);
    maxbinnum = generalProperty.indicativeNrns_maxbinnum;
    
    
    fid = fopen(fullfile(outputPath, ['indicative_report' foldstr linstr eventsStr '.txt']), 'a+');
    fprintf(fid, 'chance is: %2.2f\n',chanceLevel);
    for binsnum = 2:maxbinnum
        count = getIndicativeNrnsMean(isindicative, 'consecutive', maxbinnum, time2st, time2end);
        fprintf(fid, 'mean indicative nrns  starting from %f to %f with %d consecutive bins and %f percent confidence: %f\n',...
            generalProperty.indicativeNrnsMeanStartTime, generalProperty.indicativeNrnsMeanEndTime, maxbinnum, 100*pvalues(pii), count);
    end
    for binsnum = 1:maxbinnum
        count = getIndicativeNrnsMean(isindicative, 'any', binsnum, time2st, time2end);
        fprintf(fid, 'mean indicative nrns  starting from %f to %f with any %d bins and %f percent confidence: %f\n',...
            generalProperty.indicativeNrnsMeanStartTime, generalProperty.indicativeNrnsMeanEndTime, binsnum, 100*pvalues(pii), count);
        
    end
    fclose(fid);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    percentage=hist(isindicative,0:1);
    errorbarbar(tmid-toneTime, percentage(2,:)/size(data4Svm,1)*100, zeros(size(percentage)), [], labelsFontSz);
    xlim([xlimmin, tmid(end)+1]-toneTime);
    % xlabel('Time [sec]');ylabel('% Indicative Neurons');
    placeToneTime(0, 2);
    xlabel('Time [sec]');
    ylabel('Indicative Neurons [%]');
    set(gca, 'Box','off');
    mysave(gcf, fullfile(outputPath, ['indicativeNrs' num2str(100*pvalues(pii)) 'percent' foldstr linstr eventsStr]));
    
    loclabels = zeros(size(imagingData.samples,1),1);
    for nrni = 1:size(imagingData.samples,1)
        if any(isindicative(nrni, tmid >= generalProperty.indicativeNrnsMeanStartTime & tmid <=generalProperty.indicativeNrnsMeanEndTime))
            loclabels(nrni) = 1;
            
        end
        
    end
    [estimateX, estimateY] = plotLocationByLabels(imagingData.loc, loclabels, generalProperty.locations_stripesNum);
    
    title('Blue - Indicativee by 5%; Black - Rest');
    
    mysave(gcf, fullfile(outputPath, ['Location_indicativeNrs' 100*pvalues(pii) 'percent'  eventsStr]));
    
    
    
    
    fid = fopen(fullfile(outputPath, ['indicative_report' foldstr linstr eventsStr '.txt']), 'a+');
    fprintf(fid, 'Stats for pvalue of: %f\n',100*pvalues(pii));
    fprintf(fid, 'location mean stats - stripes along x axis location: mean: %2.3f std: %2.3f\n',...
        estimateX.meanRatio, estimateX.stdRatio);
    fprintf(fid, 'location mean stats - stripes along y axis location: mean: %2.3f std: %2.3f\n',...
        estimateY.meanRatio, estimateY.stdRatio);
    fprintf(fid, 'location regression stats - stripes along x axis location: constant: %2.3f slope: %2.3f R2 %f with p %2.3f\n',...
        estimateX.constant, estimateX.slope, estimateX.Rsquare.Ordinary, estimateX.pvalue);
    fprintf(fid, 'location regression stats - stripes along y axis location: constant: %2.3f slope: %2.3f R2 %f with p %2.3f\n',...
        estimateY.constant, estimateY.slope, estimateY.Rsquare.Ordinary, estimateY.pvalue);
    fprintf(fid, 'ratios in stripes along x axis location: %2.3f \n',...
        estimateX.ratio);
    fprintf(fid, 'ratios in stripes along y axis location: %2.3f \n',...
        estimateY.ratio);
    fclose(fid);
    figure;subplot(2,1,1);plot(estimateX.ratio);title('Ratio vs X location');
    subplot(2,1,2);plot(estimateY.ratio);title('Ratio vs Y location');
    suptitle(['Indicative pvalue=' num2str(100*pvalues(pii))]);
    mysave(gcf, fullfile(outputPath, ['RatioOfindicativeVsStrips' num2str(100*pvalues(pii))]));
    
end