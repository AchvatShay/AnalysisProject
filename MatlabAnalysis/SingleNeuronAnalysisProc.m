function [resfile_curr, resfile_prev, data4Svm, data4Svmprev] = SingleNeuronAnalysisProc(outputPath, generalProperty, imagingData, BehaveData)

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
if ~exist(resfile_curr, 'file')
      
    [chanceLevel, tmid, SVMsingle, trialsNum] = slidingWinAccSN(data4Svm, resfile_curr, ...
        labels, winstSec, winendSec, foldsnum, islin, duration);
end


[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(...
BehaveData, generalProperty.prevcurrlabels2cluster, generalProperty.includeOmissions);
eventsStr = [eventsStr 'PrevCurr'];
resfile_prev = fullfile(outputPath, ['prev_acc_res_SN_curr_' foldstr linstr eventsStr '.mat']);
data4Svmprev = imagingData.samples(:, :, examinedInds);
data4Svmprev=data4Svmprev(:,:,1:end-1);
if ~exist(resfile_prev, 'file')
      
    [chanceLevel, tmid, SVMsingle, trialsNum] = slidingWinAccSN(data4Svmprev, resfile_prev, ...
        labels(2:end), winstSec, winendSec, foldsnum, islin, duration);
end


