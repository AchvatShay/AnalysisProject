function accuracyAnalysis(outputPath, generalProperty, imagingData, BehaveData, eventsList)

examinedInds = [];
for event_i = 1:length(eventsList)
    examinedInds = cat(1, examinedInds, find(BehaveData.(eventsList{event_i})));
end
if length(examinedInds) ~= length(unique(examinedInds))
    error('The events you chose for accuracy are true for the same trial. Please choose non-overlapping trials');
end
examinedInds = sort(examinedInds);

labels = zeros(length(examinedInds), 1);
for event_i = 1:length(eventsList)
    labels = labels + BehaveData.(eventsList{event_i})(examinedInds)*2^(event_i-1);
end
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
eventsStr = ['_' eventsList{1}];
for event_i = 2:length(eventsList)
    eventsStr = [eventsStr '_' eventsList{event_i}];
end
resfileTot = fullfile(outputPath, ['acc_res_' foldstr linstr eventsStr '.mat']);
if exist(resfileTot, 'file')
    load(resfileTot);
else
    resfile_curr = fullfile(outputPath, ['acc_res_curr_' foldstr linstr eventsStr '.mat']);
    data4Svm = imagingData.samples(:, :, examinedInds);
    [chanceLevel, tmid, accSVM, accRandSVM, confMats, trialsNum] = slidingWinAcc(data4Svm, resfile_curr, ...
        labels, winstSec, winendSec, foldsnum, islin, duration);
    
    resfile_seq = fullfile(outputPath, ['acc_res_seq_' foldstr linstr eventsStr '.mat']);
    data4Svm = imagingData.samples(:, :, examinedInds(1:end-1));
    [chanceLevelseq, ~, accSVMlinseq, accRandSVMlinseq, confMatsseq, trialsNumseq] = slidingWinAcc(data4Svm, resfile_seq, ...
        labels(2:end), winstSec, winendSec, foldsnum, islin, duration);
    
    resfile_prev = fullfile(outputPath, ['acc_res_prev_' foldstr linstr eventsStr '.mat']);
    data4Svm = imagingData.samples(:, :, examinedInds(2:end));
    [chanceLevelPrev, ~, accSVMlinPrev, ~, confMatsPrev, trialsNumPrev] = slidingWinAcc(data4Svm, resfile_prev, ...
        labels(1:end-1), winstSec, winendSec, foldsnum, islin, duration);
    save(resfileTot, 'chanceLevel', 'tmid', 'accSVM', 'accRandSVM', 'confMats', 'trialsNum', ...
        'chanceLevelseq', 'accSVMlinseq', 'accRandSVMlinseq', 'confMatsseq', 'trialsNumseq', ...
        'chanceLevelPrev', 'accSVMlinPrev', 'confMatsPrev', 'trialsNumPrev');
    delete(resfile_curr);
    delete(resfile_seq);
    delete(resfile_prev);
end
% visualize
labelsFontSz = generalProperty.visualization_labelsFontSize;
xlimmin = generalProperty.visualization_startTime2plot;
conf_percent4acc = generalProperty.visualization_conf_percent4acc;
toneTime = generalProperty.ToneTime;
duration = generalProperty.Duration;
tryinginds = find(BehaveData.success | BehaveData.failure);
[Sbehave, Fbehave] = getHistEvents(BehaveData, generalProperty.Events2plot, tryinginds);
Sbehave=Sbehave.';
Fbehave=Fbehave.';

t=linspace(0,duration, size(Fbehave,1))-toneTime;
[atop, htoneLine]=plotAccResFinal(tmid-toneTime, accSVM, chanceLevel, Sbehave.', Fbehave.', t, 0, labelsFontSz, xlimmin-toneTime, generalProperty.Events2plot);
mysave(gcf, fullfile(outputPath, ['accNoLegendSTD_' foldstr linstr eventsStr]));
ylim(atop,[0 max(get(atop, 'YLim'))]);
set(htoneLine, 'YData',[0 max(get(atop, 'YLim'))]);
mysave(gcf, fullfile(outputPath, ['accNoLegendSTD01_' foldstr linstr eventsStr]));

c=get(gcf, 'Children');
ind=0;
for ci=1:length(c)
    if strcmp(c(ci).Tag, 'legend')
        ind = ci;
    end
end
if ind~=0
    set(c(ind), 'Visible','on','Location','BestOutside');
end
mysave(gcf, fullfile(outputPath, ['accWithLegendSTD_' foldstr linstr eventsStr]));

%  Clustering - Linear Classifier (SVM) 95% Confidence
if length(eventsList) == 2
    for ti=1:length(accSVM.raw.mean)
        accSVM.raw.C(:,ti) = getConfidenceInterval(accSVM.raw.mean(ti), accSVM.raw.std(ti), numel(accSVM.raw.accv)/foldsnum, conf_percent4acc);
        
    end
    [atop, hlabel, htoneLine] = plotAccResFinalCI(tmid-toneTime, accSVM, chanceLevel, Sbehave.', Fbehave.', t, 0, labelsFontSz, xlimmin-toneTime, generalProperty.Events2plot);
    set(hlabel,'Position', [-3.1152    1.2576   -1.0000]);
    mysave(gcf, fullfile(outputPath, ['accWithLegendStanErr_' foldstr linstr eventsStr]));
    ylim(atop,[0 max(get(atop, 'YLim'))]);
    set(htoneLine, 'YData',[0 max(get(atop, 'YLim'))]);
    
    mysave(gcf, fullfile(outputPath, ['accWithLegendStanErr01_' foldstr linstr eventsStr]));
    
    c=get(gcf, 'Children');
    ind=0;
    for ci=1:length(c)
        if strcmp(c(ci).Tag, 'legend')
            ind = ci;
        end
    end
    if ind~=0
        set(c(ind), 'Visible','on','Location','BestOutside');
    end
    mysave(gcf, fullfile(outputPath, ['accWithLegendStanErr_' foldstr linstr eventsStr]));
end





%% S/F Clustering - Linear Classifier (SVM) of previous and next trial
%% Note: Time axes for both figures is Time [secs]
chanceLevels = [chanceLevelseq chanceLevel chanceLevelPrev];
plotAccUnion(tmid-toneTime, accSVMlinseq, accSVM, accSVMlinPrev, chanceLevels, 0, labelsFontSz);
mysave(gcf, fullfile(outputPath, ['accPrevNextstanErr_' foldstr linstr eventsStr]));

for ti=1:length(accSVM.raw.mean)
    accSVMlinPrev.raw.C(:,ti) = getConfidenceInterval(accSVMlinPrev.raw.mean(ti), accSVMlinPrev.raw.std(ti), numel(accSVMlinPrev.raw.accv)/foldsnum, conf_percent4acc);
end
plotAccResFinal(tmid-toneTime, accSVMlinPrev, chanceLevelPrev, Sbehave.', Fbehave.', t, 0, labelsFontSz, xlimmin-toneTime, generalProperty.Events2plot);
mysave(gcf, fullfile(outputPath, ['accNextTrialSTD_' foldstr linstr eventsStr]));
[~, hlabel] = plotAccResFinalCI(tmid-toneTime, accSVMlinPrev, chanceLevelPrev, Sbehave.', Fbehave.', t, 0, labelsFontSz, xlimmin-toneTime, generalProperty.Events2plot);
set(hlabel,'Position', [-3.1152    1.2576   -1.0000]);

mysave(gcf, fullfile(outputPath, ['accNextTrialstanErr_' foldstr linstr eventsStr]));
time4confplotNext = generalProperty.visualization_time4confplotNext;
f = myplotConfMat({confMatsPrev}, findClosestDouble(time4confplotNext, tmid), 1, eventsList);
title(['Confusion matrix for next trial t = ' num2str(time4confplotNext) 'secs']);
mysave(f, fullfile(outputPath, ['confNext_' foldstr linstr eventsStr]));
time4confplot = generalProperty.visualization_time4confplotNext;
f=myplotConfMat({confMats}, findClosestDouble(time4confplot, tmid), 1, eventsList);
title(['Confusion matrix for current trial t = ' num2str(time4confplot) 'secs']);
mysave(f, fullfile(outputPath, ['conf_' foldstr linstr eventsStr]));
