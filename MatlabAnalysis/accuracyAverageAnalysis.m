function accuracyAverageAnalysis(outputPath, generalProperty, analysisRes, eventsList)


labelsFontSz = generalProperty.visualization_labelsFontSize;
toneTime = generalProperty.ToneTime;
xlimmin = generalProperty.visualization_startTime2plot-toneTime;
tmid = analysisRes(1).tmid - toneTime;
foldsnum = generalProperty.foldsNum;
islin = generalProperty.linearSVN;

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


%% Acc averaged over experiments
allAccTot = collectAcc([analysisRes.accSVM], [analysisRes.trialsNum], [analysisRes.chanceLevel]);
plotAccRes(analysisRes(1).tmid-toneTime, allAccTot, [], allAccTot.chanceLevel, [], [], [], 0);
mysave(gcf, fullfile(outputPath, 'AverageAnalysis_accuracy'));
%% S/F Clustering - Linear Classifier (SVM) of previous and next trial
allAccTotConseq = collectAcc([analysisRes.accSVMlinseq], [analysisRes.trialsNumseq], [analysisRes.chanceLevelseq]);
allAccTotPrev = collectAcc([analysisRes.accSVMlinPrev], [analysisRes.trialsNumPrev], [analysisRes.chanceLevelPrev]);

chanceLevels = [allAccTotConseq.chanceLevel allAccTot.chanceLevel allAccTotPrev.chanceLevel];
plotAccUnion(tmid, allAccTotConseq, allAccTot, allAccTotPrev, chanceLevels, 0, labelsFontSz);
mysave(gcf, fullfile(outputPath, 'AverageAnalysis_accuracyPrevNext'));

%% Fig. 1 - Mean and STD, Fig. 2 - Mean and 5% Confidence Interval
[a1,a2]=plotAccUnionCurrNext(tmid, allAccTot, allAccTotPrev, chanceLevels(2:end), toneTime, labelsFontSz, xlimmin);
mysave(gcf, fullfile(outputPath, 'AverageAnalysis_accuracyNext'));
[aleft,aright]=plotAccUnionCurrNext(tmid, allAccTot, allAccTotPrev, chanceLevels(2:end), 0, labelsFontSz, xlimmin);
cc=get(aleft,'Children');
set(cc(1),'Visible','off');
set(aleft,'XLim',[0,max(get(aleft,'XLim'))]);
set(aleft,'XTick',0:2:6);
set(aright,'XLim',[min(get(aright,'XLim')) toneTime]);
mysave(gcf, fullfile(outputPath, 'AverageAnalysis_accuracyNextStartingAtZero'));

time4confplotNext = generalProperty.visualization_time4confplotNext;
tind = findClosestDouble(time4confplotNext, tmid);
w = [analysisRes.trialsNumPrev];
f = myplotConfMat({analysisRes.confMatsPrev}, tind, w, eventsList);
title(['Confusion matrix for next trial t = ' num2str(time4confplotNext) 'secs']);
mysave(gcf, fullfile(outputPath, ['confNext_' foldstr linstr eventsStr]));
time4confplot = generalProperty.visualization_time4confplot;
w = [analysisRes.trialsNum];
f = myplotConfMat({analysisRes.confMats}, tind, w, eventsList);
title(['Confusion matrix for current trial t = ' num2str(time4confplot) 'secs']);
mysave(f, fullfile(outputPath, ['conf_' foldstr linstr eventsStr]));
% %% Accuracy with behave
% plotAccResFinalCI(tmid, allAccTot,  chanceLevels(2), Sbehave, Fbehave, t, 0, labelsFontSz, xlimmin-toneTime)
% mysave(gcf, fullfile(outputPath, 'accNoLegend'));
% c=get(gcf, 'Children');
% ind=0;
% for ci=1:length(c)
%     if strcmp(c(ci).Tag, 'legend')
%         ind = ci;
%     end
% end
% if ind~=0
% set(c(ind), 'Visible','on','Location','BestOutside');
% end
% mysave(gcf, fullfile(outputPath, 'accWithLegend'));
% 
% 
% 
