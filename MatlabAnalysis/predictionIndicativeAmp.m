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

for fi=1:length(indicativefiles)
    
    pvalue = sscanf(indicativefiles(fi).name, ['indicativeNrs%fpercentfolds' num2str(generalProperty.foldsNum) linstr '_success_failure.mat']);
    indicativpth = fullfile(outputPath, ['indicativeAnalysis_pvalue' num2str(pvalue)]);
    r=load(fullfile(indicativefiles(fi).folder, indicativefiles(fi).name));
    mkNewFolder(indicativpth);
    
    [winstSec, winendSec] = getFixedWinsFine(generalProperty.Duration, generalProperty.slidingWinLen, generalProperty.slidingWinHop);
    tmid = (winstSec+winendSec)/2;
    isindicativeLabel = sum(r.isindicative(:, tmid>=generalProperty.indicativeNrnsMeanStartTime & tmid<= generalProperty.indicativeNrnsMeanEndTime),2)>0;

            
            
[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(...
BehaveData, generalProperty.prevcurrlabels2cluster, generalProperty.includeOmissions);
eventsStr = [eventsStr '_contitional'];
if length(examinedInds) ~= size(imagingData.samples,3)
    imagingData.samples=imagingData.samples(:,:,examinedInds);
end

successtrials = find(labels==1);
failtrials = find(labels==2);

successtrials=setdiff(successtrials,1);
failtrials=setdiff(failtrials,1);

prev_suc = successtrials-1;
prev_fail = failtrials-1;

eventsStr1 = [eventsStr '_contitional_on_success'];
accuracyAnalysis(BehaveData, outputPath, generalProperty, imagingData, labels(prev_suc), successtrials, eventsStr1, labelsLUT, false);

eventsStr1 = [eventsStr '_contitional_on_fail'];
accuracyAnalysis(BehaveData, outputPath, generalProperty, imagingData, labels(prev_fail), failtrials, eventsStr1, labelsLUT, false);

