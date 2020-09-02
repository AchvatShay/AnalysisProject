function runAnalysis(outputPath, xmlfile, BdaTpaList, analysisName, runOnWhat, structuralTreeLabels)
if nargin < 6
    structuralTreeLabels = [];
end

% mkNewFolder(outputPath);
if ~exist('runOnWhat','var')
    runOnWhat = 'imaging';
end

generalProperty = Experiment(xmlfile);

[imagingData, BehaveData] = loadData(BdaTpaList, generalProperty);
switch runOnWhat
    case 'NotindicativeNrns'
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
            Notindicativpth = fullfile(outputPath, ['NotindicativeAnalysis_pvalue' num2str(pvalue)]);
            r=load(fullfile(indicativefiles(fi).folder, indicativefiles(fi).name));
            mkNewFolder(Notindicativpth);
            
            [winstSec, winendSec] = getFixedWinsFine(generalProperty.Duration, generalProperty.slidingWinLen, generalProperty.slidingWinHop);
            tmid = (winstSec+winendSec)/2 - generalProperty.ToneTime;
            isindicativeLabel = sum(r.isindicative(:, tmid>=generalProperty.indicativeNrnsMeanStartTime & tmid<= generalProperty.indicativeNrnsMeanEndTime),2)>0;
            imagingDataIndicative.samples = imagingData.samples(isindicativeLabel==0, :, :);
            imagingDataIndicative.roiNames = imagingData.roiNames(isindicativeLabel==0, :);
            imagingDataIndicative.loc = imagingData.loc(isindicativeLabel==0);
            feval(analysisName,Notindicativpth, generalProperty, imagingDataIndicative, BehaveData);
        end
    case 'indicativeNrns'
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
            tmid = (winstSec+winendSec)/2 - generalProperty.ToneTime;
            isindicativeLabel = sum(r.isindicative(:, tmid>=generalProperty.indicativeNrnsMeanStartTime & tmid<= generalProperty.indicativeNrnsMeanEndTime),2)>0;
            imagingDataIndicative.samples = imagingData.samples(isindicativeLabel, :, :);
            imagingDataIndicative.roiNames = imagingData.roiNames(isindicativeLabel, :);
            imagingDataIndicative.loc = imagingData.loc(isindicativeLabel);
            feval(analysisName,indicativpth, generalProperty, imagingDataIndicative, BehaveData);
        end
    case 'significantNrns'
        significantfiles = dir(fullfile(outputPath,'../SingleNeuronSignificantAnalysis/significantNrs*percent_success_failure.mat'));
        if isempty(significantfiles)
        error('Cannot find significant files, please run SingleNeuronSignificantAnalysis');
        end
        for fi=1:length(significantfiles)
            pvalue = sscanf(significantfiles(fi).name, 'significantNrs%fpercent_success_failure.mat');
            significantpath = fullfile(outputPath, ['significantAnalysis_pvalue' num2str(pvalue)]);
            r=load(fullfile(significantfiles(fi).folder, significantfiles(fi).name));
            mkNewFolder(significantpath);
            
            [winstSec, winendSec] = getFixedWinsFine(generalProperty.Duration, generalProperty.slidingWinLen, generalProperty.slidingWinHop);
            tmid = (winstSec+winendSec)/2 - generalProperty.ToneTime;
            issignificantLabel = sum(r.issignificant(:, tmid>=generalProperty.indicativeNrnsMeanStartTime & tmid<= generalProperty.indicativeNrnsMeanEndTime),2)>0;
            imagingDataSignificant.samples = imagingData.samples(issignificantLabel, :, :);
            imagingDataSignificant.roiNames = imagingData.roiNames(issignificantLabel, :);
            imagingDataSignificant.loc = imagingData.loc(issignificantLabel);
            feval(analysisName,significantpath, generalProperty, imagingDataSignificant, BehaveData);
        end
        case 'NotsignificantNrns'
        significantfiles = dir(fullfile(outputPath,'../SingleNeuronSignificantAnalysis/significantNrs*percent_success_failure.mat'));
        if isempty(significantfiles)
        error('Cannot find significant files, please run SingleNeuronSignificantAnalysis');
        end
        for fi=1:length(significantfiles)
            pvalue = sscanf(significantfiles(fi).name, 'significantNrs%fpercent_success_failure.mat');
            Notsignificantpath = fullfile(outputPath, ['NotsignificantAnalysis_pvalue' num2str(pvalue)]);
            r=load(fullfile(significantfiles(fi).folder, significantfiles(fi).name));
            mkNewFolder(Notsignificantpath);
            
            [winstSec, winendSec] = getFixedWinsFine(generalProperty.Duration, generalProperty.slidingWinLen, generalProperty.slidingWinHop);
            tmid = (winstSec+winendSec)/2 - generalProperty.ToneTime;
            issignificantLabel = sum(r.issignificant(:, tmid>=generalProperty.indicativeNrnsMeanStartTime & tmid<= generalProperty.indicativeNrnsMeanEndTime),2)>0;
            imagingDataSignificant.samples = imagingData.samples(issignificantLabel==0, :, :);
            imagingDataSignificant.roiNames = imagingData.roiNames(issignificantLabel==0, :);
            imagingDataSignificant.loc = imagingData.loc(issignificantLabel==0);
            feval(analysisName,Notsignificantpath, generalProperty, imagingDataSignificant, BehaveData);
        end
    case 'imaging'
        if isempty(structuralTreeLabels)
            feval(analysisName,outputPath, generalProperty, imagingData, BehaveData);
        else
            indexingROI = zeros(size(structuralTreeLabels.roiNames, 1), 1);
            roi_i = 1;
            roiToExcludeFromTheTPA = [];
            roiToExcludeFromTheTPA_indexing = 1;
            for i = 1:size(imagingData.roiNames, 1)
                locationCurrentROI = find(strcmp(structuralTreeLabels.roiNames, sprintf('roi%05d',imagingData.roiNames(i, 1))));
                
                if isempty(locationCurrentROI)
                    roiToExcludeFromTheTPA(roiToExcludeFromTheTPA_indexing) = i;
                    roiToExcludeFromTheTPA_indexing = roiToExcludeFromTheTPA_indexing + 1;
                    continue;
                end
                
                indexingROI(roi_i) = locationCurrentROI;
                roi_i = roi_i + 1;
            end
            
            imagingData.samples(roiToExcludeFromTheTPA, :, :) = [];
            imagingData.roiNames(roiToExcludeFromTheTPA, :) = [];
            imagingData.loc(roiToExcludeFromTheTPA) = [];
            
            roiTableNew.roiNames = structuralTreeLabels.roiNames(indexingROI);
            roiTableNew.eventsStr = structuralTreeLabels.eventsStr;
            roiTableNew.labels = structuralTreeLabels.labels(indexingROI);
            roiTableNew.labelsLUT = structuralTreeLabels.labelsLUT;
            roiTableNew.cls = structuralTreeLabels.cls;
            roiTableNew.activity.dataEvents = structuralTreeLabels.activity.dataEvents(indexingROI, :, :);
            roiTableNew.activity.labels = structuralTreeLabels.activity.labels';
            roiTableNew.activity.dataTrials = structuralTreeLabels.activity.dataTrials(indexingROI, :, :);
            
            feval(analysisName,outputPath, generalProperty, imagingData, BehaveData, roiTableNew);
        end
    case 'traj'
        
        if ~isfield(BehaveData, 'traj')
            error('Could not find trajectories in this path');
        else
            trajData.samples = BehaveData.traj.data;
            for k=1:size(trajData.samples,1)
            trajData.roiNames{k} = num2str(k);
            end
            outputPath = [outputPath 'Traj'];
            mkNewFolder(outputPath);
            generalProperty.ImagingSamplingRate = generalProperty.BehavioralSamplingRate;
            feval(analysisName,outputPath, generalProperty, trajData, BehaveData);
            
        end
    case 'both'
        feval(analysisName,outputPath, generalProperty, imagingData, BehaveData);
        if ~isfield(BehaveData, 'traj')
            error('Could not find trajectories in this path');
        else
            trajData.samples = BehaveData.traj.data;
            trajData.roiNames = {'frontx','fronty','sidex','sidey'};
            outputPath = [outputPath 'Traj'];
            mkNewFolder(outputPath);
            generalProperty.ImagingSamplingRate = generalProperty.BehavioralSamplingRate;
            feval(analysisName,outputPath, generalProperty, trajData, BehaveData);
            
        end
end
