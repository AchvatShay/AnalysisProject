function diffMapTrajectories(outputPath, generalProperty, imagingData, BehaveData)
% analysis
error('Under construction');
[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
generalProperty.labels2cluster, generalProperty.includeOmissions);
[prevcurlabs, prevCurrLUT] = getPrevCurrLabels(labels, labelsLUT);

X = imagingData.samples(:, :, examinedInds);
if exist(fullfile(outputPath, ['diff_map_res' eventsStr '.mat']), 'file')
    load(fullfile(outputPath, ['diff_map_res' eventsStr '.mat']));
else
    [resDiffMap, runningOrder] = diffMapAnalysis(X, generalProperty.analysis_pca_thEffDim);
    labsOmissions = BehaveData.failure;    
    embedding = resDiffMap.embedding{runningOrder==3}(:,1:2);
    foldsNum = generalProperty.foldsNum;
    ACC2D = svmClassifyAndRand(embedding(labsOmissions(examinedInds)~=2,:), labsOmissionstrying(labsOmissionstrying~=2), labsOmissionstrying(labsOmissionstrying~=2), foldsNum, '', 1, 0);
    save(fullfile(outputPath, ['diff_map_res' eventsStr '.mat']), 'resDiffMap', 'ACC2D', 'runningOrder');
end



faillabels = BehaveData.failure(examinedInds);
[prevcurlabs, ~, ~] = getLabelsSeq(faillabels);

startBehaveTime = generalProperty.startBehaveTime4trajectory*generalProperty.ImagingSamplingRate;
endBehaveTime = generalProperty.endBehaveTime4trajectory*generalProperty.ImagingSamplingRate;

% BehaveDatagrab
tindicator = zeros(size(X, 2), 1);
tindicator(startBehaveTime:endBehaveTime) = 1;
[tstampFirst.grab, tstampLast.grab] = getStartEndEventTimes(examinedInds, BehaveData, 'grab', tindicator);
[tstampFirst.atmouth, tstampLast.atmouth] = getStartEndEventTimes(examinedInds, BehaveData, 'atmouth', tindicator);


%% visualize
visualizeTrajectories(tstampFirst, tstampLast, prevcurlabs, outputPath, faillabels, generalProperty, resDiffMap.projeff, X, 'diffMap');



% if ~isempty(prevcurlabs)
% amtime1 = tstampFirst.atmouth.start{l}(2:end);
% lift1 = tstampFirst.lift.start{l}(2:end);
% grab1 = tstampFirst.grab.start{l}(2:end);
% ttestTrajRes = getTtestTrajOnTime(pcaTrajSmooth1(:,11:end, :), prevcurlabs, t(16:end), toneTime);
%
% fid = fopen(fullfile(figspath, 'ttestTrajectories.txt'),'a');
% fprintf(fid,'%s %d %d %d %1.2f %1.2f %1.2f %d %d %d %1.2f %1.2f %1.2f %d %d %d %1.2f %1.2f %1.2f %d %d %d %1.2f %1.2f %1.2f %d %d %d %1.2f %1.2f %1.2f %d %d %d %1.2f %1.2f %1.2f\n', currfolder{l},...
%     ttestTrajRes.Hcurr.start, ttestTrajRes.Pcurr.start,...
%     ttestTrajRes.Hcurr.tone, ttestTrajRes.Pcurr.tone,...
%     ttestTrajRes.Hcurr.end, ttestTrajRes.Pcurr.end,...
% ttestTrajRes.Hprev.start, ttestTrajRes.Pprev.start,...
%     ttestTrajRes.Hprev.tone, ttestTrajRes.Pprev.tone,...
%     ttestTrajRes.Hprev.end, ttestTrajRes.Pprev.end);
% fclose(fid);
% fid = fopen(fullfile(figspath, 'neuronsAndTrialsStats.txt'),'a');
% fprintf(fid,'%s %d %d\n', currfolder{l},...
%     size(dataAlltimes{l},1), size(dataAlltimes{l}, 3));
% fclose(fid);
% end


