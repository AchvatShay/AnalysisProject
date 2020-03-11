function SingleNeuronAnalysisAverageAnalysis(outputPath, generalProperty, analysisRes, BehaveData)

[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
    generalProperty.labels2cluster, generalProperty.includeOmissions);
% [prevcurlabs, prevCurrLUT] = getPrevCurrLabels(labels, labelsLUT);

foldsnum = generalProperty.foldsNum;
islin = generalProperty.linearSVN;
duration = generalProperty.Duration;
[winstSec, winendSec] = getFixedWinsFine(duration, generalProperty.slidingWinLen, generalProperty.slidingWinHop);
tmid = (winstSec+winendSec)/2;
foldstr = ['folds' num2str(foldsnum)];
if islin
    linstr = 'lin';
else
    linstr = 'Rbf';
end

labelsFontSz = generalProperty.visualization_labelsFontSize;
    xlimmin = generalProperty.visualization_startTime2plot;
    toneTime = generalProperty.ToneTime;

for k=1:length(analysisRes)

    
    
   Nnrns = size(analysisRes(k).isindicative,1);
    percentage=hist(analysisRes(k).isindicative,0:1);
    finalNum(:,k) = percentage(2,:)/Nnrns*100;
end

M=mean(finalNum,2);
S=std(finalNum,[],2);
N=size(finalNum,2);
      errorbarbar(tmid-toneTime, M, [M-S/sqrt(N) M+S/sqrt(N)]', [], labelsFontSz);
 xlim([xlimmin, tmid(end)+1]-toneTime);
    % xlabel('Time [sec]');ylabel('% Indicative Neurons');
    placeToneTime(0, 2);
    xlabel('Time [sec]');
    ylabel('Indicative Neurons [%]');
    set(gca, 'Box','off');
    mysave(gcf, fullfile(outputPath, ['SummaryIndicativeNrs' foldstr linstr eventsStr]));
    
  
end

   
