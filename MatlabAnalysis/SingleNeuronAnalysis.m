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
ts = tinv(.9, (trialsNum)-1);      % T-Score
ts1 = tinv(0.98, (trialsNum)-1);      % T-Score

% isindicative5 = SVMsingle.raw.acc.mean-ts*SEM > chanceLevel;
% isindicative1 = SVMsingle.raw.acc.mean-ts1*SEM > chanceLevel;
t = linspace(0, generalProperty.Duration, size(data4Svm, 2));
% to run only on two label clustering
classes = unique(labels);
% if length(classes) == 2
% % significant - just being from two different gaussians with 5% or 1%
% H1=[];pval1=[];H5=[];pval5=[];
% for win_i = 3:length(tmid)
%     for nr=1:size(data4Svm,1)
%         Xs = squeeze(mean(data4Svm(nr,t >= winstSec(win_i) & t <= winendSec(win_i),labels==classes(1)),2));
%         Xf = squeeze(mean(data4Svm(nr,t >= winstSec(win_i) & t <= winendSec(win_i),labels==classes(2)),2));
%         [H1(nr, win_i), pval1(nr, win_i)] = ttest2(Xs,Xf, 'vartype', 'unequal','alpha',0.01 );
%         [H5(nr, win_i), pval5(nr, win_i)] = ttest2(Xs,Xf, 'vartype', 'unequal','alpha',0.05 );
%     end
%     sigHist1(win_i, :) = hist(H1(:, win_i), 0:1);
%     sigHist5(win_i, :) = hist(H5(:, win_i), 0:1);
% end
% 
% end
% visualize
labelsFontSz = generalProperty.visualization_labelsFontSize;
xlimmin = generalProperty.visualization_startTime2plot;
conf_percent4acc = generalProperty.visualization_conf_percent4acc;
toneTime = generalProperty.ToneTime;
duration = generalProperty.Duration;
time2st = findClosestDouble(tmid-toneTime, generalProperty.indicativeNrnsMeanStartTime);
time2end = findClosestDouble(tmid-toneTime, generalProperty.indicativeNrnsMeanEndTime);
maxbinnum = generalProperty.indicativeNrns_maxbinnum;

% [behaveHist, allbehave]= getHistEventsByDynamicLabels(generalProperty, BehaveData, generalProperty.Events2plot, examinedInds);

fid = fopen(fullfile(outputPath, ['indicative_report' foldstr linstr eventsStr '.txt']), 'w');
fprintf(fid, 'chance is: %2.2f\n',chanceLevel);
for binsnum = 2:maxbinnum
 count = getIndicativeNrnsMean(isindicative5, 'consecutive', maxbinnum, time2st, time2end);
    fprintf(fid, 'mean indicative nrns  starting from %f to %f with %d consecutive bins and 5 percent confidence: %f\n',...
        generalProperty.indicativeNrnsMeanStartTime, generalProperty.indicativeNrnsMeanEndTime, maxbinnum, count);
   count = getIndicativeNrnsMean(isindicative1, 'consecutive', maxbinnum, time2st, time2end);

    fprintf(fid, 'mean indicative nrns  starting from %f to %f with %d consecutive bins and 1 percent confidence: %f\n',...
        generalProperty.indicativeNrnsMeanStartTime, generalProperty.indicativeNrnsMeanEndTime, maxbinnum, count);
end
for binsnum = 1:maxbinnum
    count = getIndicativeNrnsMean(isindicative5, 'any', binsnum, time2st, time2end);
    fprintf(fid, 'mean indicative nrns  starting from %f to %f with any %d bins and 5 percent confidence: %f\n',...
        generalProperty.indicativeNrnsMeanStartTime, generalProperty.indicativeNrnsMeanEndTime, binsnum, count);
    
     count = getIndicativeNrnsMean(isindicative1, 'any', binsnum, time2st, time2end);
      fprintf(fid, 'mean indicative nrns  starting from %f to %f with any %d bins and 1 percent confidence: %f\n',...
        generalProperty.indicativeNrnsMeanStartTime, generalProperty.indicativeNrnsMeanEndTime, binsnum, count);
   end
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% [~,indicativeSorting] = sort(max(SVMsingle.raw.acc.mean'),'ascend');
%% Indicative Neurons - All Time Span
percentage=hist(isindicative5,0:1);
errorbarbar(tmid-toneTime, percentage(2,:)/size(data4Svm,1)*100, zeros(size(percentage)), [], labelsFontSz);
xlim([xlimmin, tmid(end)+1]-toneTime);
% xlabel('Time [sec]');ylabel('% Indicative Neurons');
placeToneTime(0, 2);
xlabel('Time [sec]');
ylabel('Indicative Neurons [%]');
set(gca, 'Box','off');
mysave(gcf, fullfile(outputPath, ['indicativeNrs5percent' foldstr linstr eventsStr]));
percentage1=hist(isindicative1,0:1);
errorbarbar(tmid-toneTime, percentage1(2,:)/size(data4Svm,1)*100, zeros(size(percentage1)), [], labelsFontSz);
xlim([xlimmin, tmid(end)+1]-toneTime);
placeToneTime(0, 2);
xlabel('Time [sec]');
set(gca, 'Box','off');
ylabel('Indicative Neurons [%]');
mysave(gcf, fullfile(outputPath, ['indicativeNrs1percent' foldstr linstr eventsStr]));

% if length(classes) == 2
% 
% %% Significant Neurons - 1percent
% errorbarbar(tmid(3:end)-toneTime, sigHist1(3:end,2)/size(data4Svm,1)*100, zeros(size(sigHist1.')), [], labelsFontSz);
% placeToneTime(0, 2);
% 
% xlabel('Time [sec]', 'FontSize',labelsFontSz);
% ylabel('Significant Neurons [%]', 'FontSize',labelsFontSz);
% set(gca, 'Box','off');
% a=get(gcf,'Children');
% setAxisFontSz(a(end), labelsFontSz);
% mysave(gcf, fullfile(outputPath, ['significantNrs1percent' foldstr linstr eventsStr]));
% 
% 
% %% Significant Neurons - 5percent
% errorbarbar(tmid(3:end)-toneTime, sigHist5(3:end,2)/size(data4Svm,1)*100, zeros(size(sigHist5.')), [], labelsFontSz);
% placeToneTime(0, 2);
% 
% xlabel('Time [sec]', 'FontSize',labelsFontSz);
% ylabel('Significant Neurons [%]', 'FontSize',labelsFontSz);
% set(gca, 'Box','off');
% a=get(gcf,'Children');
% setAxisFontSz(a(end), labelsFontSz);
% mysave(gcf, fullfile(outputPath, ['significantNrs5percent' foldstr linstr eventsStr]));
% 
% 
% 
% disp('delay2events');
% generalProperty4indicative = generalProperty;
% generalProperty4indicative.Neurons2plot = [];
% dataIndicative.samples = imagingData.samples(sum(isindicative5, 2) > 1, :, :);
% dataIndicative.roiNames = imagingData.roiNames;
% delay2events([outputPath 'Indicative5'], generalProperty4indicative, dataIndicative, BehaveData)
% end