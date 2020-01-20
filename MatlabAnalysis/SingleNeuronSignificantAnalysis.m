function SingleNeuronSignificantAnalysis(outputPath, generalProperty, imagingData, BehaveData)

[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(...
    BehaveData, generalProperty.labels2cluster, generalProperty.includeOmissions);

foldsnum = generalProperty.foldsNum;
duration = generalProperty.Duration;
[winstSec, winendSec] = getFixedWinsFine(duration, generalProperty.slidingWinLen, generalProperty.slidingWinHop);
data4Svm = imagingData.samples(:, :, examinedInds);

foldstr = ['folds' num2str(foldsnum)];

pvalueth = generalProperty.significantPvalue;

t = linspace(0, generalProperty.Duration, size(data4Svm, 2));
tmid = (winendSec + winstSec)/2;

% to run only on two label clustering
classes = unique(labels);
if length(classes) == 2
    % significant - just being from two different gaussians with 5% or 1%
    H=[];pval=[];
    for win_i = 3:length(tmid)
        for nr=1:size(data4Svm,1)
            Xs = squeeze(mean(data4Svm(nr,t >= winstSec(win_i) & t <= winendSec(win_i),labels==classes(1)),2));
            Xf = squeeze(mean(data4Svm(nr,t >= winstSec(win_i) & t <= winendSec(win_i),labels==classes(2)),2));
            [H(nr, win_i), pval(nr, win_i)] = ttest2(Xs,Xf, 'vartype', 'unequal','alpha',pvalueth );
        end
        sigHist(win_i, :) = hist(H(:, win_i), 0:1);
    end
    chanceLevel = sum(labels==classes(1))/length(labels);
    chanceLevel = max(chanceLevel, 1-chanceLevel);
end
% visualize
labelsFontSz = generalProperty.visualization_labelsFontSize;
toneTime = generalProperty.ToneTime;
time2st = findClosestDouble(tmid-toneTime, generalProperty.indicativeNrnsMeanStartTime);
time2end = findClosestDouble(tmid-toneTime, generalProperty.indicativeNrnsMeanEndTime);
maxbinnum = generalProperty.indicativeNrns_maxbinnum;

% [behaveHist, allbehave]= getHistEventsByDynamicLabels(generalProperty, BehaveData, generalProperty.Events2plot, examinedInds);

fid = fopen(fullfile(outputPath, ['significant_report'   eventsStr '.txt']), 'w');
fprintf(fid, 'chance is: %2.2f\n',chanceLevel);
for binsnum = 2:maxbinnum
    count = getIndicativeNrnsMean(H, 'consecutive', maxbinnum, time2st, time2end);
    fprintf(fid, 'mean significant nrns  starting from %f to %f with %d consecutive bins and %2.2f percent confidence: %f\n',...
        generalProperty.significantNrnsMeanStartTime, generalProperty.significantNrnsMeanEndTime, maxbinnum, 100*pvalueth, count);
end
for binsnum = 1:maxbinnum
    count = getIndicativeNrnsMean(H, 'any', binsnum, time2st, time2end);
    fprintf(fid, 'mean significant nrns  starting from %f to %f with any %d bins and %2.2f percent confidence: %f\n',...
        generalProperty.significantNrnsMeanStartTime, generalProperty.significantNrnsMeanEndTime, binsnum, 100*pvalueth, count);
    
end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if length(classes) == 2
    
    %% Significant Neurons - 1percent
    errorbarbar(tmid(3:end)-toneTime, sigHist(3:end,2)/size(data4Svm,1)*100, zeros(size(sigHist.')), [], labelsFontSz);
    placeToneTime(0, 2);
    
    xlabel('Time [sec]', 'FontSize',labelsFontSz);
    ylabel('Significant Neurons [%]', 'FontSize',labelsFontSz);
    set(gca, 'Box','off');
    a=get(gcf,'Children');
    setAxisFontSz(a(end), labelsFontSz);
    mysave(gcf, fullfile(outputPath, ['significantNrs' num2str(pvalueth*100) 'percent'  eventsStr]));
     
     loclabels = zeros(size(imagingData.samples,1),1);
    for nrni = 1:size(imagingData.samples,1)
    if any(H(nrni, tmid >= generalProperty.significantNrnsMeanStartTime & tmid <=generalProperty.significantNrnsMeanEndTime))
        loclabels(nrni) = 1;
        
    end
    end
    cent = plotLocationByLabels(imagingData.loc, loclabels);
    mysave(gcf, fullfile(outputPath, ['Location_significantNrs' num2str(pvalueth*100) 'percent'  eventsStr]));
% 
%     [ acc, accrand, scoresall, scoresallrand, confMat, confMatrand, ...
%     accclasses, accclassesrand, Yhat, SVMModel] = svmClassifyAndRand(cent, loclabels, loclabels, 10, 'temp', 1, 0);
    
   
    end
    
    
%     disp('delay2events');
%     generalProperty4indicative = generalProperty;
%     generalProperty4indicative.Neurons2plot = [];
%     dataIndicative.samples = imagingData.samples(sum(isindicative5, 2) > 1, :, :);
%     dataIndicative.roiNames = imagingData.roiNames;
%     delay2events([outputPath 'Significant' num2str(pvalueth*100)], generalProperty4indicative, dataIndicative, BehaveData)
end