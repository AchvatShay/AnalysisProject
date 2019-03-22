
function f=plotAlignedDataHist(currfigs, firstlaststr,sfstr, eventName, delays, behaveDat, t, imagingData, toneTime, labelsFontSz, plotUnalignedData, neurons2plotList)
validinds=~isnan(delays) ;
if all(validinds==0)
    f=[];
    return;
end

currBehave = behaveDat(:, validinds).';
onsetdiffvalid=max(delays(validinds))-delays(validinds);
currBehaveAl= zeros(size(onsetdiffvalid,1), size(imagingData,2)+max(onsetdiffvalid));


for m=1:length(onsetdiffvalid)
    currBehaveAl(m, 1:(size(imagingData,2)+onsetdiffvalid(m))) = [zeros(1, onsetdiffvalid(m)) currBehave(m, :)];
end

histbehaveAl = mean(currBehaveAl);

[~,ic]=max(histbehaveAl);
eventTime = t(ic-max(onsetdiffvalid));


currData = imagingData(:, :, validinds);
dataAlltimesAl = zeros(size(currData,1), size(imagingData,2)+max(onsetdiffvalid), length(onsetdiffvalid));
for m=1:length(onsetdiffvalid)
    tAl{m}= linspace(-onsetdiffvalid(m)*t(2), t(end), size(imagingData,2)+onsetdiffvalid(m));
    dataAlltimesAl(:, 1:(size(currData,2)+onsetdiffvalid(m)), m) = [zeros(size(currData,1), onsetdiffvalid(m)) currData(:, :, m)];
    tAlcrop{m} = tAl{m}(findClosestDouble(tAl{m}, 1.5) + onsetdiffvalid(m):end);
    
end
tglobalcrop = t(findClosestDouble(t, 1.5):end);
dataAlltimesAlcrop=dataAlltimesAl(:, findClosestDouble(t, 1.5) + max(onsetdiffvalid):end,:);
meanDat = mean(dataAlltimesAlcrop,3);
meanbase = mean(dataAlltimesAlcrop(:, 1:findClosestDouble(tglobalcrop, toneTime-.1)),2);
stdbase = std(meanDat(:, 1:findClosestDouble(tglobalcrop, toneTime-.1)),[],2);


[peakVal, peakTime] = max(meanDat.');
keepNrs = peakVal(:) > meanbase+3*stdbase & peakTime(:) +findClosestDouble(tglobalcrop, 1.5)< length(tglobalcrop);
if all(keepNrs==0)
    return;
end
for nr=1:size(dataAlltimesAlcrop,1)
    if keepNrs(nr)
        
        [maxval, peakIndd(nr)] = max(meanDat(nr,:));
        
        meanDatmask=meanDat(nr,:);
        meanDatmask(peakIndd(nr):end)=nan;
        [val, onset(nr)] = max(meanDatmask(6:end)-meanDatmask(1:end-5));
        if isnan(val)
            keepNrs(nr) = false;
            continue;
        end
        onset(nr)=onset(nr)+5;
        %             meanDatmask=meanDat(nr,:);
        %             meanDatmask(1:peakIndd(nr))=nan;
        %             meanDatmask(peakIndd(nr)+4/t(2):end);
        %             find(meanDatmask < maxval*.5,1)
        %             meanDatmask=meanDat(nr,:);
        %             meanDatmask(peakIndd(nr):end)=nan;
        %             meanDatmask(peakIndd(nr)-2/t(2):end);
        %              find(meanDatmask < maxval*.5,1)
        [~, inds4onset] = sort(abs(meanDatmask - maxval*.2),'ascend');
        peakelays2event(nr) = tglobalcrop( peakIndd(nr)+findClosestDouble(tglobalcrop, 1.5))-eventTime;
        onsetdelays2event(nr) = tglobalcrop( onset(nr)+findClosestDouble(tglobalcrop, 1.5))-eventTime;
        
        %             delays2event(nr) = round(eventTime-peakIndd(nr)+findClosestDouble(tglobalcrop, 1.5) );
    end
end
if all(keepNrs==0)
    return;
end
[hist2onset,bins] = hist(onsetdelays2event(keepNrs),100);
f(1)=figure;

bins_values_percentage = hist2onset/size(imagingData,1)*100;
bar(bins, bins_values_percentage, 'FaceColor',[192,192,192]/255);

xlabel('Delay Time [sec]', 'FontSize',labelsFontSz);
ylabel('Neurons [%]', 'FontSize',labelsFontSz);
set(gca, 'Box','off');
a=get(gcf,'Children');
setAxisFontSz(a(end), labelsFontSz);
suptitle(['Delay to Onset, ' firstlaststr ' ' eventName ' ' sfstr]);
placeToneTime(0,2);
c=get(gca,'Children');
set(c(1),'Color','r')
mysave(f(1), fullfile(currfigs, ['histOnsetDelay' firstlaststr eventName sfstr '_allnrns']));


sum_percentage_before_event = sum(bins_values_percentage(bins < 0 & bins >= -0.2));
sum_percentage_after_event_halfsec = sum(bins_values_percentage(bins > 0 & bins <= 0.5));
sum_percentage_after_event_sec = sum(bins_values_percentage(bins > 0 & bins <= 1));

fid=fopen(fullfile(currfigs, ['histOnsetDelay' eventName sfstr '_allnrns_sum_percentage.txt']),'w');
fprintf(fid, '%% of neurons -0.2-0.5 sec %.4f \r\n', sum_percentage_before_event + sum_percentage_after_event_halfsec);
fprintf(fid, '%% of neurons -0.2-1 sec %.4f \r\n', sum_percentage_before_event + sum_percentage_after_event_sec);
fprintf(fid, '%% of neurons -0.2-0 sec %.4f \r\n', sum_percentage_before_event);
fprintf(fid, '%% of neurons 0-0.5 sec %.4f \r\n', sum_percentage_after_event_halfsec);
fprintf(fid, '%% of neurons 0-1 sec %.4f \r\n', sum_percentage_after_event_sec);
fclose(fid);

% set(c(1),'Visible','off');
% xlim([.12, max(get(gca,'XLim'))])
% mysave(f(1), fullfile(currfigs, ['histOnsetDelay' eventName sfstr '_allnrnsStartingFromZero']));
% 
% 
% [hist2peak,bins] = hist(peakelays2event(keepNrs),100);
% f(2)=figure;
% bar(bins, hist2peak/size(imagingData,1)*100, 'FaceColor',[192,192,192]/255);
% 
% xlabel('Delay Time [sec]', 'FontSize',labelsFontSz);
% ylabel('Neurons [%]', 'FontSize',labelsFontSz);
% set(gca, 'Box','off');
% a=get(gcf,'Children');
% setAxisFontSz(a(end), labelsFontSz);
% placeToneTime(0,2);
% c=get(gca,'Children');
% set(c(1),'Color','r')
% suptitle(['Delay to Peak, ' eventName ' ' sfstr]);
% mysave(f(2), fullfile(currfigs, ['histPeakDelay' eventName sfstr '_allnrns']));
% set(c(1),'Visible','off');
% xlim([.15, max(get(gca,'XLim'))])
% mysave(f(2), fullfile(currfigs, ['histPeakDelay' eventName sfstr '_allnrnsStartingFromZero']));
% 
% 
% 
% 
% 
% 
% 
% 
[~,i]=sort(onsetdelays2event);
tnew = linspace(-eventTime, t(end)-eventTime, size(dataAlltimesAlcrop,2));
f(3) = figure;
subplot(2,1,1);
imagesc(tglobalcrop(1:end-max(onsetdiffvalid))-eventTime, 1:size(dataAlltimesAlcrop,1),mean(dataAlltimesAlcrop(i,1:end-max(onsetdiffvalid),:),3), [-.15 2]);
xlabel('Time [sec]', 'FontSize', 12);
ylabel('Neurons', 'FontSize', 12);
set(gca,'XTick', -2:2:7)
xticks=get(gca,'XTick');
for h=1:length(xticks)
    if xticks(h) > 0
        xticklabels{h} = [eventName '+' num2str(xticks(h)) ];
    elseif xticks(h) == 0
        xticklabels{h} = eventName;
    else
        xticklabels{h} = [eventName num2str(xticks(h)) ];
    end
end
   
set(gca,'XTickLabel',xticklabels);
placeToneTime(0,3);
colormap jet;
title(get(f(3),'Children'), ['aligned Data ' firstlaststr ' ' eventName ' ' sfstr]);
set(gca,'Position',[0.1300    0.4095    0.7750    0.5155]);
subplot(4,1,4);
plot(tglobalcrop(1:end-max(onsetdiffvalid))-eventTime, mean(mean(dataAlltimesAlcrop(i,1:end-max(onsetdiffvalid),:)),3),'k','LineWidth',2);
set(gca,'XTick', -2:2:7)
set(gca,'XTickLabel',xticklabels);
placeToneTime(0,3);
axis tight;
ylabel('Average', 'FontSize', 12);
xlabel('Time [sec]', 'FontSize', 12);

mysave(f(3), fullfile(currfigs, ['alignedData' firstlaststr eventName sfstr '_allnrns']));


for nrni = neurons2plotList
    ff = figure;
    imagesc(tglobalcrop(1:end-max(onsetdiffvalid))-eventTime, 1:size(dataAlltimesAlcrop,3),squeeze((dataAlltimesAlcrop(nrni,1:end-max(onsetdiffvalid),:)))', [-.15 2]);
xlabel('Time [sec]', 'FontSize', 12);
ylabel('Trials', 'FontSize', 12);
set(gca,'XTick', -2:2:7)
  
set(gca,'XTickLabel',xticklabels);
placeToneTime(0,3);
colormap jet;
set(gca,'Position',[0.1300    0.4095    0.7750    0.5155]);
title(['aligned Neuron #' num2str(nrni) ' ' firstlaststr ' ' eventName ' ' sfstr]);

subplot(4,1,4);
plot(tglobalcrop(1:end-max(onsetdiffvalid))-eventTime, mean(dataAlltimesAlcrop(nrni,1:end-max(onsetdiffvalid),:),3),'k','LineWidth',2);
set(gca,'XTick', -2:2:7)
set(gca,'XTickLabel',xticklabels);
placeToneTime(0,3);
axis tight;
ylabel('Average', 'FontSize', 12);
xlabel('Time [sec]', 'FontSize', 12);
mysave(ff, fullfile(currfigs, ['alignedNeuron' num2str(nrni) firstlaststr eventName sfstr '_allnrns']));

end

if plotUnalignedData
f(4) = figure;
subplot(2,1,1);
imagesc(t(findClosestDouble(t,1.5):end)-toneTime, 1:size(imagingData,1),mean(imagingData(i,findClosestDouble(t,1.5):end,validinds),3), [-.15 2]);
xlabel('Time [sec]', 'FontSize', 12);
ylabel('Neurons', 'FontSize', 12);
colormap jet;
set(gca,'XTick', -2:2:8)

placeToneTime(0,3);
colormap jet;
title(get(f(4),'Children'), ['Unaligned Data ' firstlaststr ' ' eventName ' ' sfstr]);
set(gca,'Position',[0.1300    0.4095    0.7750    0.5155]);

subplot(4,1,4);
plot(t(findClosestDouble(t,1.5):end)-toneTime, mean(mean(imagingData(i,findClosestDouble(t,1.5):end,validinds),3)),'k','LineWidth',2);
axis tight;
xlabel('Time [sec]', 'FontSize', 12);
ylabel('Average', 'FontSize', 12);
placeToneTime(0,3);

mysave(f(4), fullfile(currfigs, ['unalignedData' eventName sfstr '_allnrns']));
end



