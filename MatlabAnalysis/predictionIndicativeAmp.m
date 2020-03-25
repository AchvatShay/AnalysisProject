function predictionIndicativeAmp(outputPath, generalProperty, imagingData, BehaveData)
% mkNewFolder(outputPath);



if generalProperty.linearSVN
    linstr = 'lin';
else
    linstr = 'Rbf';
end
indicativefiles = dir(fullfile(outputPath, ['../SingleNeuronAnalysis/indicativeNrs*percentfolds' num2str(generalProperty.foldsNum) linstr '_success_failure.mat']));
if isempty(indicativefiles)
    error('Cannot find indicative files, please run SingleNeuronAnalysis');
end
indicativeStart = generalProperty.indicativeAmplitudeStartTime;
indicativeEnd = generalProperty.indicativeAmplitudeEndTime;
toneTime = generalProperty.ToneTime;
t = linspace(0, generalProperty.Duration, size(imagingData.samples,2)) - toneTime;
for fi=1:length(indicativefiles)
    
    pvalue = sscanf(indicativefiles(fi).name, ['indicativeNrs%fpercentfolds' num2str(generalProperty.foldsNum) linstr '_success_failure.mat']);
    indicativpth = fullfile(outputPath, ['indicativeAnalysis_pvalue' num2str(pvalue)]);
    r=load(fullfile(indicativefiles(fi).folder, indicativefiles(fi).name));
    mkNewFolder(indicativpth);
    
    [winstSec, winendSec] = getFixedWinsFine(generalProperty.Duration, generalProperty.slidingWinLen, generalProperty.slidingWinHop);
    tmid = (winstSec+winendSec)/2 - toneTime;
    isindicativeLabel = sum(r.isindicative(:, tmid>=generalProperty.indicativeNrnsMeanStartTime & tmid<= generalProperty.indicativeNrnsMeanEndTime),2)>0;

    indicativeData = imagingData.samples(isindicativeLabel,:,:);
    
    indicativeData = squeeze(mean(indicativeData(:, t<=indicativeEnd & t>=  indicativeStart,:),2));
    trialsLabelsByIndicatives = kmeans(indicativeData.', 2); 
    figure;plot(trialsLabelsByIndicatives,'x')
hold all
plot(BehaveData.success.indicatorPerTrial+1,'ro');
acc= sum(BehaveData.success.indicatorPerTrial+1 == trialsLabelsByIndicatives)/length(trialsLabelsByIndicatives);
title(['Agreement: ' num2str(max(acc, 1-acc))]);

mysave(gcf, fullfile(outputPath, ['indicativeLabelsAndSuccessAgreement_pvalue' num2str(pvalue)]));
successtrials = find(trialsLabelsByIndicatives==1);
failtrials = find(trialsLabelsByIndicatives==2);

successtrials=setdiff(successtrials,1);
failtrials=setdiff(failtrials,1);

prev_suc = successtrials-1;
prev_fail = failtrials-1;

eventsStr1 = [ 'contitional_on_indicativeLabel_1_pvalue' num2str(pvalue)];
labelsLUT=[];
accuracyAnalysis(BehaveData, outputPath, generalProperty, imagingData, trialsLabelsByIndicatives(prev_suc), successtrials, eventsStr1, labelsLUT, false);

            



eventsStr1 = [ 'contitional_on_indicativeLabel_2_pvalue' num2str(pvalue)];
accuracyAnalysis(BehaveData, outputPath, generalProperty, imagingData, trialsLabelsByIndicatives(prev_fail), failtrials, eventsStr1, labelsLUT, false);
end
