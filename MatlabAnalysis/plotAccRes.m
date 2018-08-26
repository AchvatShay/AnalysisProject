function plotAccRes(tmid, accSVM, accRandSVM, chanceLevel, Sbehave, Fbehave, t, toneTime, newfig, labelsFontSz)
if ~exist('labelsFontSz','var')
    labelsFontSz=11;
end
if ~exist('newfig','var')
    newfig = true;
end
if isfield(accSVM, 'quest')
    plotQ = 1;
else
    plotQ = 0;
end
if isfield(accSVM, 'pca')
    plotP = 1;
else
    plotP = 0;
end
if all(Sbehave(:) == 0)
    plotHist = 0;
else
    plotHist = 2;
end

r = [1+plotHist+plotP+plotQ, 1];

currplotAx = 1;
if newfig
figure;
end
if any(r > 1)
    atop = subplot(r(1),r(2),currplotAx);
end
shadedErrorBar(tmid,accSVM.raw.mean,accSVM.raw.std,'lineprops',{'-k'});

% errorbar(tmid, accSVM.raw.mean, accSVM.raw.std);title('Raw Data');
xlabel('Time [sec]','FontSize',labelsFontSz);ylabel('Accuracy','FontSize',labelsFontSz);axis tight;
hold all;
if isempty(accRandSVM)
    
    plot(tmid, ones(size(tmid))*chanceLevel, '--k');
else
    shadedErrorBar(tmid,accRandSVM.raw.mean,accRandSVM.raw.std,'lineprops',{'-b'});

%     errorbar(tmid, accRandSVM.raw.mean, accRandSVM.raw.std);
% title('Raw Data');
% xlabel('Time [sec]');
ylabel('Accuracy','FontSize',labelsFontSz);axis tight;
end
% ylim([0 1]);
ylim([min(chanceLevel*.9, min(get(gca,'YLim'))), max(1,  max(get(gca,'YLim')))]);

placeToneTime(toneTime, 2);
set(gca, 'Box','off');
currplotAx=currplotAx+1;
if plotP
    subplot(r(1),r(2),currplotAx);
    shadedErrorBar(tmid,accSVM.pca.mean,accSVM.pca.std,'lineprops',{'-b'});
%     errorbar(tmid, accSVM.pca.mean, accSVM.pca.std);
% title('pca');
xlabel('Time [sec]','FontSize',labelsFontSz);ylabel('Accuracy','FontSize',labelsFontSz);axis tight;
    hold all;
    if isempty(accRandSVM)
        plot(tmid, ones(size(tmid))*chanceLevel, '--k');
    else
            shadedErrorBar(tmid,accRandSVM.pca.mean,accRandSVM.pca.std,'lineprops',{'-b'});
%         errorbar(tmid, accRandSVM.raw.mean, accRandSVM.raw.std);title('pca');
xlabel('Time [sec]','FontSize',labelsFontSz);
ylabel('Accuracy','FontSize',labelsFontSz);axis tight;
    end
%     ylim([0 1]);
    placeToneTime(toneTime, 2);
    set(gca, 'Box','off');
    currplotAx=currplotAx+1;
    
end

if plotQ
    
    subplot(r(1),r(2),currplotAx);
    shadedErrorBar(tmid,accSVM.quest.mean,accSVM.quest.std,'lineprops',{'-b'});
%     errorbar(tmid, accSVM.quest.mean, accSVM.quest.std);
% title('Diff. Map');
xlabel('Time [sec]','FontSize',labelsFontSz);
ylabel('Accuracy','FontSize',labelsFontSz);axis tight;
    hold all;
%     errorbar(tmid, accRandSVM.quest.mean, accRandSVM.raw.std);title('Diff. Map');
    
    shadedErrorBar(tmid,accRandSVM.quest.mean,accRandSVM.quest.std,'lineprops',{'-b'});
xlabel('Time [sec]','FontSize',labelsFontSz);
ylabel('Accuracy','FontSize',labelsFontSz);axis tight;
%     ylim([0 1]);
    placeToneTime(toneTime, 2);
    set(gca, 'Box','off');
    currplotAx=currplotAx+1;
end
% subplot(r(1),r(2),4);
% errorbar(tmid, accSVM.loc.mean, accSVM.loc.std);title('Location');xlabel('Time [sec]');ylabel('Acc.');axis tight;
% hold all;
% errorbar(tmid, accRandSVM.loc.mean, accRandSVM.loc.std);title('Location');xlabel('Time [sec]');ylabel('Acc.');axis tight;
% ylim([0 1]);
% line([toneTime, toneTime], [get(gca, 'YLim')], 'Color', 'r')

if plotHist > 0
    subplot(r(1),r(2),currplotAx);
    if size(Sbehave, 2) > 3 && any(Sbehave(:,4) ~=0)
        plot(t, Sbehave.');
        c=get(gca, 'Children');
        set(c(2),'Color','g');
        set(c(3),'Color','r');
        set(c(4),'Color','b');
    else
        plot(t, Sbehave(:,1:3).');ylim([0 1]);
        c=get(gca, 'Children');
        set(c(1),'Color','g');
        set(c(2),'Color','r');
        set(c(3),'Color','b');
    end
    ylim([0 1]);
    placeToneTime(toneTime, 2);
    xlabel('Time [sec]','FontSize',labelsFontSz);
%     title('Events At Success');
%     ylabel('Empiric Probability')
%     if size(Sbehave, 2) > 3 && any(Sbehave(:,4) ~=0)
%         legend('Lift','Grab','At-Mouth', 'Lick');
%     else
%         legend('Lift','Grab','At-Mouth');
%     end
    set(gca, 'Box','off');
    currplotAx=currplotAx+1;
    subplot(r(1),r(2),currplotAx);
    if size(Fbehave, 2) > 3 &&any(Fbehave(:,4) ~=0)
        plot(t, Fbehave(:,[1:3, 4]).');
        c=get(gca, 'Children');
        set(c(2),'Color','g');
        set(c(3),'Color','r');
        set(c(4),'Color','b');
    else
        plot(t, Fbehave(:,[1:3]).');
        c=get(gca, 'Children');
        set(c(1),'Color','g');
        set(c(2),'Color','r');
        set(c(3),'Color','b');
    end
    ylim([0 1]);
    placeToneTime(toneTime, 2);
    xlabel('Time [sec]','FontSize',labelsFontSz);
%     title('Events At Failure');
    h=ylabel('Empiric Probability','FontSize',labelsFontSz);
%     if size(Fbehave, 2) > 3 &&any(Fbehave(:,4) ~=0)
%         legend('Lift','Grab','At-Mouth', 'Lick', 'Location', 'BestOutside');
%     else
%         legend('Lift','Grab','At-Mouth', 'Location', 'BestOutside');
%     end
    set(atop, 'XLim', get(gca, 'XLim'));
    set(atop, 'XTick', get(gca, 'XTick'));
    set(h, 'Position', [-0.9493    1.4014   -1.0000]);
end
end