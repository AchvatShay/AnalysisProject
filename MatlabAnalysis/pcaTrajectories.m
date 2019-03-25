function pcaTrajectories(outputPath, generalProperty, imagingData, BehaveData)
% analysis
[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
generalProperty.labels2cluster, generalProperty.includeOmissions);
[prevcurlabs, prevCurrLUT] = getPrevCurrLabels(labels, labelsLUT);

X = imagingData.samples(:, :, examinedInds);
if exist(fullfile(outputPath, ['pca_traj_res' eventsStr 'energy' num2str(generalProperty.analysis_pca_thEffDim*100) '.mat']), 'file')
    load(fullfile(outputPath, ['pca_traj_res' eventsStr 'energy' num2str(generalProperty.analysis_pca_thEffDim*100) '.mat']));
else
    for k=1:size(X,1)
        alldataNT(:, k) = reshape(X(k,:,:), size(X,3)*size(X,2),1);
    end
    [pcaTrajres.kernel, pcaTrajres.mu, pcaTrajres.eigs] = mypca(alldataNT);
    pcaTrajres.effectiveDim = getEffectiveDim(pcaTrajres.eigs, generalProperty.analysis_pca_thEffDim);
    [recon_m, projeff] = linrecon(alldataNT, pcaTrajres.mu, pcaTrajres.kernel, 1:pcaTrajres.effectiveDim);
    if pcaTrajres.effectiveDim < 3
        [~, projeff] = linrecon(alldataNT, pcaTrajres.mu, pcaTrajres.kernel, 1:3);
    end
    for l=1:size(recon_m,2)
    pcaTrajres.recon(l,:,:) = reshape(recon_m(:,l),size(X,2),size(X,3));
    end
    for l=1:size(projeff,2)
        pcaTrajres.projeff(l,:,:) = reshape(projeff(:,l),size(X,2),size(X,3));
        
    end
    save(fullfile(outputPath, ['pca_traj_res' eventsStr 'energy' num2str(generalProperty.analysis_pca_thEffDim*100)  '.mat']), 'pcaTrajres');
end

startBehaveTime = generalProperty.startBehaveTime4trajectory*generalProperty.ImagingSamplingRate;
endBehaveTime = generalProperty.endBehaveTime4trajectory*generalProperty.ImagingSamplingRate;

% BehaveDatagrab
tindicator = zeros(size(X, 2), 1);
tindicator(startBehaveTime:endBehaveTime) = 1;
[tstampFirst.grab, tstampLast.grab] = getStartEndEventTimes(examinedInds, BehaveData, 'grab', tindicator);
[tstampFirst.atmouth, tstampLast.atmouth] = getStartEndEventTimes(examinedInds, BehaveData, 'atmouth', tindicator);


%% visualize
switch lower(generalProperty.PelletPertubation)
    case 'none'
        visualizeTrajectories(generalProperty.visualization_bestpcatrajectories2plot, generalProperty.prevcurrlabels2clusterClrs, generalProperty.labels2clusterClrs, eventsStr, prevCurrLUT, labelsLUT, tstampFirst, tstampLast, labels, prevcurlabs, outputPath, generalProperty, pcaTrajres.projeff, pcaTrajres.recon, pcaTrajres.eigs, pcaTrajres.effectiveDim, X, 'PCA');
    case 'taste'
         [labelsTaste, examinedIndsTaste, eventsStrTaste, labelsLUTTaste] = getLabels4clusteringFromEventslist(BehaveData, ...
            generalProperty.tastesLabels, generalProperty.includeOmissions);
        % mark failures - because then we do not know the tastes
%         labelsTaste(labels == find(strcmp(labelsLUT, 'failure'))) = max(labelsTaste)+1;
        labelsFontSz = generalProperty.visualization_labelsFontSize;
        legendLoc = generalProperty.visualization_legendLocation;        
        clrs = getColors(generalProperty.tastesColors);
        
      
        XTaste = imagingData.samples(:, :, examinedIndsTaste);
        if exist(fullfile(outputPath, ['pca_traj_res' eventsStrTaste '.mat']), 'file')
            load(fullfile(outputPath, ['pca_traj_res' eventsStrTaste '.mat']));
        else
            for k=1:size(XTaste,1)
                alldataNTTaste(:, k) = reshape(XTaste(k,:,:), size(XTaste,3)*size(XTaste,2),1);
            end
            [pcaTrajresTaste.kernel, pcaTrajresTaste.mu, pcaTrajresTaste.eigs] = mypca(alldataNTTaste);
            pcaTrajresTaste.effectiveDim = max(getEffectiveDim(pcaTrajresTaste.eigs, generalProperty.analysis_pca_thEffDim), 3);

            [~, projeffTaste] = linrecon(alldataNTTaste, pcaTrajresTaste.mu, pcaTrajresTaste.kernel, 1:pcaTrajresTaste.effectiveDim);
            for l=1:size(projeffTaste,2)
                pcaTrajresTaste.projeffTaste(l,:,:) = reshape(projeffTaste(:,l),size(XTaste,2),size(XTaste,3));
            end
            save(fullfile(outputPath, ['pca_traj_res' eventsStrTaste '.mat']), 'pcaTrajresTaste');
        end      
        
        visualizeTrajectories(generalProperty.visualization_bestpcatrajectories2plot, ...
            generalProperty.prevcurrlabels2clusterClrs, generalProperty.labels2clusterClrs, ...
            eventsStr, prevCurrLUT, labelsLUT, tstampFirst, tstampLast, labels, prevcurlabs, outputPath, ...
            generalProperty, pcaTrajres.projeff, X, 'PCA', labelsTaste, labelsLUTTaste, clrs, eventsStrTaste, pcaTrajresTaste.projeffTaste);
 
        
    case 'ommisions'
        error('under constraction');
    otherwise
        error('Unfamiliar pellet pertrubation');
end
% 
% 
% b = fir1(10,.3);
% trajSmooth = filter(b,1, pcaTrajres.projeff, [], 2);
% trajSmooth=trajSmooth(:,6:end,:);
% trajSmooth1=trajSmooth(:,:,2:end);
% 
% 
% toneTime = generalProperty.ToneTime;
% labelsFontSz = generalProperty.visualization_labelsFontSize;
% viewparams = [generalProperty.visualization_viewparams1 generalProperty.visualization_viewparams2];
% t = linspace(0, generalProperty.Duration, size(X,2)) - toneTime;
% xlimmin = generalProperty.visualization_startTime2plot-toneTime;
% 
% % 1. all trials averaged
% allTimemean = mean(trajSmooth,3).';
% plotTimeEmbedding(allTimemean, t(6:end), 0, labelsFontSz);
% mysave(gcf, fullfile(outputPath, ['traj' Method 'time']));
% plotTimeEmbedding(allTimemean, t(6:end), [], labelsFontSz);
% mysave(gcf, fullfile(outputPath, ['traj' Method 'timeNoMarkers']));
% 
% % 2. trajectories by labels
% 
% 
% switch generalProperty.PelletPertubation
%     case 'None'
%         f = plotTemporalTraject(trajSmooth, faillabels, t(6:end), 0, labelsFontSz, viewparams);
%         mysave(f(1), fullfile(outputPath, ['traj' Method ]));
%         mysave(f(2), fullfile(outputPath, ['traj' Method 'selected']));
%     case 'Ommisions'
%         if ~isfield(BehaveData, 'nopellet')
%             
%             warning('ommisions were not marked in BDA file!');
%             f = plotTemporalTraject(trajSmooth, faillabels, t(6:end), 0, labelsFontSz, viewparams);
%         else
%             faillabels(BehaveData.nopellet==1) = 2;
%             f = plotTemporalTraject(trajSmooth, faillabels, t(6:end), 0, labelsFontSz, viewparams);
%         end
%         mysave(f(1), fullfile(outputPath, ['traj' Method ]));
%         mysave(f(2), fullfile(outputPath, ['traj' Method 'selected']));
%     case 'Taste'
%         f = plotTemporalTraject(trajSmooth, faillabels, t(6:end), 0, labelsFontSz, viewparams);
%         mysave(f(1), fullfile(outputPath, ['traj' Method ]));
%         mysave(f(2), fullfile(outputPath, ['traj' Method 'selected']));
%         figure;
%         plotTrajTaste(trajSmooth, allLabels, faillabels, t(6:end), 0, tstampFirst.grab.start+6, tstampLast.grab.start+6, [], labelsFontSz);
%         mysave(gcf, fullfile(outputPath, ['traj' Method 'tastsmooth']));
%         
% end
% % 3. prev -curr trajectories
% f1=plotCurrPrevTraj(trajSmooth1(:,11:end, :), prevcurlabs, t(16:end), 0, tstampFirst.grab.start(2:end), tstampLast.grab.start(2:end), labelsFontSz, viewparams);
% % currently, without the movie
% % [f1, ~, ~, ~, mov]=plotCurrPrevTraj(trajSmooth1(:,11:end, :), prevcurlabs, t(16:end), 0, tstampFirst.grab.start(2:end), tstampLast.grab.start(2:end), labelsFontSz, viewparams);
% f2=plotCurrPrevTraj(trajSmooth1(:,11:end, :), prevcurlabs, t(16:end), toneTime, [], [], labelsFontSz, viewparams);
% % savemove2avi(filename, mov, reps, framerate)
% mysave(f1(1), fullfile(outputPath, ['traj' Method 'prevcurr1NoMarkers1']));
% mysave(f1(2), fullfile(outputPath, ['traj' Method 'prevcurr2NoMarkers1']));
% mysave(f1(3), fullfile(outputPath, ['traj' Method 'prevcurrNoMarkers1']));
% mysave(f2(1), fullfile(outputPath, ['traj' Method 'prevcurr1NoMarkers2']));
% mysave(f2(2), fullfile(outputPath, ['traj' Method 'prevcurr2NoMarkers2']));
% mysave(f2(3), fullfile(outputPath, ['traj' Method 'prevcurrNoMarkers2']));
% 
% % 4. Tube Plot & Dprime - ' Method ' Trajectories
% f=plotTrajectoryUsingTube(xlimmin, t, projeff, faillabels, [1 0 0; 0 0 1], 0, labelsFontSz);
% 
% mysave(f(2), fullfile(outputPath, ['dprime' Method] ));
% mysave(f(3), fullfile(outputPath, ['dprimePrevCurr' Method]));
% mysave(f(4), fullfile(outputPath, ['dprimeNext' Method]));
% 
% 
% 
% 
% % if ~isempty(prevcurlabs)
% % amtime1 = tstampFirst.atmouth.start{l}(2:end);
% % lift1 = tstampFirst.lift.start{l}(2:end);
% % grab1 = tstampFirst.grab.start{l}(2:end);
% % ttestTrajRes = getTtestTrajOnTime(pcaTrajSmooth1(:,11:end, :), prevcurlabs, t(16:end), toneTime);
% %
% % fid = fopen(fullfile(figspath, 'ttestTrajectories.txt'),'a');
% % fprintf(fid,'%s %d %d %d %1.2f %1.2f %1.2f %d %d %d %1.2f %1.2f %1.2f %d %d %d %1.2f %1.2f %1.2f %d %d %d %1.2f %1.2f %1.2f %d %d %d %1.2f %1.2f %1.2f %d %d %d %1.2f %1.2f %1.2f\n', currfolder{l},...
% %     ttestTrajRes.Hcurr.start, ttestTrajRes.Pcurr.start,...
% %     ttestTrajRes.Hcurr.tone, ttestTrajRes.Pcurr.tone,...
% %     ttestTrajRes.Hcurr.end, ttestTrajRes.Pcurr.end,...
% % ttestTrajRes.Hprev.start, ttestTrajRes.Pprev.start,...
% %     ttestTrajRes.Hprev.tone, ttestTrajRes.Pprev.tone,...
% %     ttestTrajRes.Hprev.end, ttestTrajRes.Pprev.end);
% % fclose(fid);
% % fid = fopen(fullfile(figspath, 'neuronsAndTrialsStats.txt'),'a');
% % fprintf(fid,'%s %d %d\n', currfolder{l},...
%     size(dataAlltimes{l},1), size(dataAlltimes{l}, 3));
% fclose(fid);
% end


