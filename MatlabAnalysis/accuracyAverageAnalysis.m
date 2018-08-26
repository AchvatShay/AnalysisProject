function accuracyAverageAnalysis(outputPath, generalProperty, analysisRes)


labelsFontSz = generalProperty.visualization_labelsFontSize;
toneTime = generalProperty.ToneTime;
xlimmin = generalProperty.visualization_startTime2plot-toneTime;

tmid = analysisRes(1).tmid - toneTime;
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
% 
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
