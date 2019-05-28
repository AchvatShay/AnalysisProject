function isindicative = getIndicatives(outputPath, generalProperty, imagingData, BehaveData, perc)
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
ts = tinv(1-perc*2, (trialsNum)-1);      % T-Score

isindicative = SVMsingle.raw.acc.mean-ts*SEM > chanceLevel;