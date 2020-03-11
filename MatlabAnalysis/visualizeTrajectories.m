function visualizeTrajectories(countbesttrajs, clrscurrprev, clrs, eventsStr, prevCurrLUT, labelsLUT, ...
    tstampFirst, tstampLast, labels, prevcurlabs, outputPath, generalProperty, projeff, recon,...
    eigs, effDim, X, Method, isTaste)

b = fir1(10,.3);
trajSmooth = filter(b,1, projeff, [], 2);
trajSmooth=trajSmooth(:,6:end,:);
trajSmooth1=trajSmooth(:,:,2:end);


toneTime = generalProperty.ToneTime;
labelsFontSz = generalProperty.visualization_labelsFontSize;
viewparams = [generalProperty.visualization_viewparams1 generalProperty.visualization_viewparams2];
t = linspace(0, generalProperty.Duration, size(X,2)) - toneTime;
xlimmin = generalProperty.visualization_startTime2plot-toneTime;
[clrs, clrscurrprev] = cellClr2matClrs(clrs, clrscurrprev);
% 1. plot eig values
eigsvalue_vector = 100*cumsum(eigs.^2)/sum(eigs.^2); 
figure;plot(eigsvalue_vector);
xlabel(['# Eigen Value of ' Method]);
ylabel('% Energy');
title([num2str(effDim) ' PCs - 95% energy; 3 PCs - ' num2str(100*sum(eigs(1:3).^2)/sum(eigs.^2)) '%']);
mysave(gcf, fullfile(outputPath, ['eigenValuesTraj' Method eventsStr] ));

% save to excle the eigs valuse
filenameExcel = fullfile(outputPath, ['eigenValuesTrajExcle' Method eventsStr] );

[~, ~, excelDataRaw] = xlsread('tamplateEigsValue.xlsx');

[currentRow, currentCol] = find(strcmp(excelDataRaw, 'Title'));
excelDataRaw{currentRow, currentCol + 1} = [num2str(effDim) ' PCs - 95% energy; 3 PCs - ' num2str(100*sum(eigs(1:3).^2)/sum(eigs.^2)) '%'];

[currentRow, currentCol] = find(strcmp(excelDataRaw, 'Method'));
excelDataRaw{currentRow, currentCol + 1} = Method;

[currentRow, currentCol] = find(strcmp(excelDataRaw, '% Energy'));
excelDataRaw((currentRow + 1):(currentRow + length(eigsvalue_vector)), currentCol) = num2cell(eigsvalue_vector);

[currentRow, currentCol] = find(strcmp(excelDataRaw, '# Eigen Value'));
excelDataRaw((currentRow + 1):(currentRow + length(eigsvalue_vector)), currentCol) = num2cell(1:length(eigsvalue_vector));

xlswrite(filenameExcel,excelDataRaw);

% 2. eval dprime for smoothed data
[dprimeSmoothed, dprimeNextSmoothed] = evalDprime(recon, labels);
f = plotDprime(t, dprimeSmoothed, dprimeNextSmoothed, ...
generalProperty.visualization_labelsFontSize, generalProperty.visualization_startTime2plot-generalProperty.ToneTime, ...
0);
save(fullfile(outputPath, 'dprimeAndNext_smoothed.mat'), 'dprimeSmoothed', 'dprimeNextSmoothed');

mysave(f(1), fullfile(outputPath, ['smoothed_dprime' Method eventsStr] ));
mysave(f(2), fullfile(outputPath, ['smoothed_dprimePrevCurr' Method eventsStr]));
mysave(f(3), fullfile(outputPath, ['smoothed_dprimeNext' Method eventsStr]));

% 3. all trials averaged
allTimemean = mean(trajSmooth,3).';
plotTimeEmbedding(allTimemean, t(6:end), 0, labelsFontSz);

mysave(gcf, fullfile(outputPath, ['traj' Method eventsStr 'time']));

plotTimeEmbedding(allTimemean, t(6:end), [], labelsFontSz);
mysave(gcf, fullfile(outputPath, ['traj' Method eventsStr 'timeNoMarkers']));

f = plotTemporalTraject(countbesttrajs, labelsLUT, clrs, trajSmooth, labels, t(6:end), 0, labelsFontSz, viewparams);
mysave(f(1), fullfile(outputPath, ['traj' Method eventsStr]));
createPushButtunTime(f(1), t(6:end));
mysave(f(1), fullfile(outputPath, ['traj' Method eventsStr 'ButtunTime']));

mysave(f(2), fullfile(outputPath, ['traj' Method 'selected' eventsStr]));
createPushButtunTime(f(2), t(6:end));
mysave(f(2), fullfile(outputPath, ['traj' Method 'selected' eventsStr 'ButtunTime']));

if ~isTaste
    fprevcurr = plotTemporalTraject(0, {prevCurrLUT.name}, clrscurrprev, trajSmooth1, prevcurlabs, t(6:end), 0, labelsFontSz, viewparams);
    % f1=            plotCurrPrevTraj(trajSmooth1(:,11:end, :), prevcurlabs, t(16:end), 0, tstampFirst.grab.start(2:end), tstampLast.grab.start(2:end), labelsFontSz, viewparams);
    createPushButtunTime(fprevcurr(2), t(6:end));
    mysave(fprevcurr(1), fullfile(outputPath, ['traj' Method eventsStr 'PrevCurr']));
    createPushButtunTime(fprevcurr(1), t(6:end));
    mysave(fprevcurr(1), fullfile(outputPath, ['traj' Method eventsStr 'PrevCurr_ButtunTime']));
% mysave(fprevcurr(2), fullfile(outputPath, ['traj' Method 'selected' 'PrevCurr' eventsStr]));
end

if length(unique(labels)) == 2
% Tube Plot & Dprime - ' Method ' Trajectories
 [f,dprime,dprimeNext]=plotTrajectoryUsingTube(xlimmin, t, projeff, labels, clrs, 0, labelsFontSz);
save(fullfile(outputPath, 'dprimeAndNext.mat'), 'dprime', 'dprimeNext');
mysave(f(2), fullfile(outputPath, ['dprime' Method eventsStr] ));
mysave(f(3), fullfile(outputPath, ['dprimePrevCurr' Method eventsStr]));
mysave(f(4), fullfile(outputPath, ['dprimeNext' Method eventsStr]));
end

end
% % 2. s/f trajectories
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
% 3. prev -curr trajectories
% f1=plotCurrPrevTraj(trajSmooth1(:,11:end, :), prevcurlabs, t(16:end), 0, tstampFirst.grab.start(2:end), tstampLast.grab.start(2:end), labelsFontSz, viewparams);
% currently, without the movie
% [f1, ~, ~, ~, mov]=plotCurrPrevTraj(trajSmooth1(:,11:end, :), prevcurlabs, t(16:end), 0, tstampFirst.grab.start(2:end), tstampLast.grab.start(2:end), labelsFontSz, viewparams);
% f2=plotCurrPrevTraj(trajSmooth1(:,11:end, :), prevcurlabs, t(16:end), toneTime, [], [], labelsFontSz, viewparams);
% savemove2avi(filename, mov, reps, framerate)
% mysave(f1(1), fullfile(outputPath, ['traj' Method 'prevcurr1NoMarkers1']));
% mysave(f1(2), fullfile(outputPath, ['traj' Method 'prevcurr2NoMarkers1']));
% mysave(f1(3), fullfile(outputPath, ['traj' Method 'prevcurrNoMarkers1']));
% mysave(f2(1), fullfile(outputPath, ['traj' Method 'prevcurr1NoMarkers2']));
% mysave(f2(2), fullfile(outputPath, ['traj' Method 'prevcurr2NoMarkers2']));
% mysave(f2(3), fullfile(outputPath, ['traj' Method 'prevcurrNoMarkers2']));

% 4. Tube Plot & Dprime - ' Method ' Trajectories
% f=plotTrajectoryUsingTube(xlimmin, t, projeff, labels, clrs, 0, labelsFontSz);
% 
% mysave(f(2), fullfile(outputPath, ['dprime' Method] ));
% mysave(f(3), fullfile(outputPath, ['dprimePrevCurr' Method]));
% mysave(f(4), fullfile(outputPath, ['dprimeNext' Method]));


