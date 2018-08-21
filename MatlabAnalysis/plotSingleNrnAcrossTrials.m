function plotSingleNrnAcrossTrials(outputPath, generalProperty, imagingData, BehaveData)
% extract behavioral data stats
% 1. grab counts per trial
% grabCount = getGrabCounts(eventTimeGrab{end}, findClosestDouble(t, toneTime), findClosestDouble(t, toneTime+2), frameRateRatio{1});
grabCount = getGrabCounts(BehaveData, generalProperty.time2startCountGrabs, generalProperty.time2endCountGrabs, generalProperty.ImagingSamplingRate);
% 2. discard trials with no suc or fail 
tryinginds = find(BehaveData.success | BehaveData.failure);
grabCount = grabCount(tryinginds);
% 3. obtain histograms of behave events
[Sbehave, Fbehave, allbehave] = getHistEvents(BehaveData, generalProperty.Events2plot, tryinginds);
X = imagingData.samples;
X=X(:,:,tryinginds);
[~, igrabs] = sort(grabCount);        
X=X(:,:,igrabs);

faillabels = BehaveData.failure(tryinginds);
faillabels = faillabels(igrabs);

t = linspace(0, generalProperty.Duration, size(X,2)) - generalProperty.ToneTime;
nerons2plot = generalProperty.Neurons2plot;
% visualize
M=2;   
m=-.15;
xlimmin = generalProperty.visualization_startTime2plot-generalProperty.ToneTime;
for nrind=1:length(nerons2plot)
    curr_nrn2plot = nerons2plot(nrind);
    currnrnind = find(imagingData.roiNames-curr_nrn2plot==0);
    
    if isempty(currnrnind)
        error('the neuron selected for ploting is not exists in the neurons selected for analysis');
    end
    
    x = squeeze(X(currnrnind,:,:))';
    
    
    mA1 = min(mean(X(currnrnind,:,faillabels==0),3));
    MA1 = max(mean(X(currnrnind,:,faillabels==0),3));
    mA2 = min(mean(X(currnrnind,:,faillabels==1),3));
    MA2 = max(mean(X(currnrnind,:,faillabels==1),3));
    mA = min(mA1, mA2);
    MA = max(MA1, MA2);
    DN = MA-mA;
    mA=mA-DN*.1;
    MA=MA+DN*.1;
    plotsinglNrnPerTrials('Success', mA, MA,imagingData.roiNames, currnrnind, x, outputPath, 'SucNr', faillabels, 0, xlimmin, t,...
        m, M, X, Sbehave, generalProperty);
    plotsinglNrnPerTrials('Failure', mA, MA,imagingData.roiNames, currnrnind, x, outputPath, 'FailNr', faillabels, 1, xlimmin, t,...
        m, M, X, Fbehave, generalProperty);
    
   
end

% %% all trials
% mA1 = min(mean(mean(X(:,:,faillabels==0),3),1));
% MA1 = max(mean(mean(X(:,:,faillabels==0),3),1));
% mA2 = min(mean(mean(X(:,:,faillabels==1),3),1));
% MA2 = max(mean(mean(X(:,:,faillabels==1),3),1));
% mA = min(mA1, mA2);
% MA = max(MA1, MA2);
% DN = MA-mA;
% mA=mA-DN*.1;
% MA=MA+DN*.1;
% figure;
% % 1
% htop = subplot(2,1,1);
% imagesc(t, 1:size(X,1),mean(X,3),[-.15 2]);
% colormap jet;ylabel('Neurons','FontSize',10);
% placeToneTime(toneTime, 3);xlim([xlimmin,tending])
% 
% c=colorbar;
% set(c,'Position',[0.9196    0.5810    0.0402    0.3452]);
% % set(htop,'Position',[0.1300    0.5071    0.7750    0.4179]);
% set(gca, 'YTick', unique([1 get(gca, 'YTick')]))
% % 2
% hmid=subplot(4,1,3);
% plot(t,mean(mean(X,3),1), 'LineWidth',3, 'Color','k');
% ylabel('Average','FontSize',10);
% set(gca, 'YLim', [mA MA]);
% placeToneTime(toneTime, 2);
% set(gca, 'Box','off');
% set(gca, 'XTick',[]);
% % set(hmid, 'Position', [0.1300    0.3291    0.7750    0.1066]);
% xlim([xlimmin,tending])
% xa=get(gca, 'XAxis');
% set(xa,'Visible', 'off')
% % 3
% wfail = sum(faillabels)/length(faillabels);
% subplot(4,1,4);
% l=plotBehaveHist(t, (1-wfail)*Sbehave+Fbehave*wfail, toneTime);
% set(l, 'Visible','off');
% xlabel('Time [sec]','FontSize',10);
% xlim([xlimmin,tending])
% mysave(gcf, fullfile(currfolder, 'alltrialsActivity'));
% 
% figure;
% % 1
% htop = subplot(2,1,1);
% imagesc(t, 1:size(X,1),mean(X(:,:,faillabels==0),3),[-.15 2]);
% colormap jet;ylabel('Neurons','FontSize',10);
% placeToneTime(toneTime, 3);xlim([xlimmin,tending])
% 
% c=colorbar;
% set(c,'Position',[0.9196    0.5810    0.0402    0.3452]);
% % set(htop,'Position',[0.1300    0.5071    0.7750    0.4179]);
% set(gca, 'YTick', unique([1 get(gca, 'YTick')]))
% % 2
% hmid=subplot(4,1,3);
% plot(t,mean(mean(X(:,:,faillabels==0),3),1), 'LineWidth',3, 'Color','k');
% ylabel('Average','FontSize',10);
% set(gca, 'YLim', [mA MA]);
% placeToneTime(toneTime, 2);
% set(gca, 'Box','off');
% set(gca, 'XTick',[]);
% % set(hmid, 'Position', [0.1300    0.3291    0.7750    0.1066]);
% xlim([xlimmin,tending])
% xa=get(gca, 'XAxis');
% set(xa,'Visible', 'off')
% % 3
% subplot(4,1,4);
% l=plotBehaveHist(t, Sbehave, toneTime);
% set(l, 'Visible','off');
% xlabel('Time [sec]','FontSize',10);
% xlim([xlimmin,tending])
% mysave(gcf, fullfile(currfolder, 'sucTrialsActivity'));
% 
% 
% 
% figure;
% % 1
% htop = subplot(2,1,1);
% imagesc(t, 1:size(X,1),mean(X(:,:,faillabels==1),3),[-.15 2]);
% colormap jet;ylabel('Neurons','FontSize',10);
% placeToneTime(toneTime, 3);xlim([xlimmin,tending])
% 
% c=colorbar;
% set(c,'Position',[0.9196    0.5810    0.0402    0.3452]);
% % set(htop,'Position',[0.1300    0.5071    0.7750    0.4179]);
% set(gca, 'YTick', unique([1 get(gca, 'YTick')]))
% % 2
% hmid=subplot(4,1,3);
% plot(t,mean(mean(X(:,:,faillabels==1),3),1), 'LineWidth',3, 'Color','k');
% ylabel('Average','FontSize',10);
% set(gca, 'YLim', [mA MA]);
% placeToneTime(toneTime, 2);
% set(gca, 'Box','off');
% set(gca, 'XTick',[]);
% % set(hmid, 'Position', [0.1300    0.3291    0.7750    0.1066]);
% xlim([xlimmin,tending]);
% xa=get(gca, 'XAxis');
% set(xa,'Visible', 'off')
% % 3
% subplot(4,1,4);
% l=plotBehaveHist(t, Fbehave, toneTime);
% set(l, 'Visible','off');
% xlabel('Time [sec]','FontSize',10);
% xlim([xlimmin,tending])
% mysave(gcf, fullfile(currfolder, 'failTrialsActivity'));


