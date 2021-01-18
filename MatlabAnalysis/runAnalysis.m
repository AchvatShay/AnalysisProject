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
    case 'RoiSplit'
        load(BdaTpaList(1).roiListNamesPath, 'roiActivityNames', 'colorMatrix1', 'colorMatrix2',  'selectedROISplitDepth1', 'selectedROISplitDepth3');
        cM1 = zeros(size(imagingData.roiNames, 1), 3);
        cM2 = zeros(size(imagingData.roiNames, 1), 3);
        split1 = zeros(size(imagingData.roiNames, 1), 1);
        split2 = zeros(size(imagingData.roiNames, 1), 1);
        
        roiToExcludeFromTheTPA = [];
        roiToExcludeFromTheTPA_indexing = 1;
        for i = 1:size(imagingData.roiNames, 1)
            locationCurrentROI = find(strcmp(roiActivityNames, sprintf('roi%05d',imagingData.roiNames(i, 1))));

            if isempty(locationCurrentROI)
                roiToExcludeFromTheTPA(roiToExcludeFromTheTPA_indexing) = i;
                roiToExcludeFromTheTPA_indexing = roiToExcludeFromTheTPA_indexing + 1;
                continue;
            else
                cM1(i, :) = colorMatrix1(locationCurrentROI, :);
                cM2(i, :) = colorMatrix2(locationCurrentROI, :);
                split1(i, :) = selectedROISplitDepth1(locationCurrentROI);
                split2(i, :) = selectedROISplitDepth3(locationCurrentROI);
            end

        end

        imagingData.samples(roiToExcludeFromTheTPA, :, :) = [];
        imagingData.roiNames(roiToExcludeFromTheTPA, :) = [];
        imagingData.loc(roiToExcludeFromTheTPA) = [];
        cM2(roiToExcludeFromTheTPA, :) = [];
        cM1(roiToExcludeFromTheTPA, :) = [];
        split1(roiToExcludeFromTheTPA, :) = [];
        split2(roiToExcludeFromTheTPA, :) = [];
        
        generalProperty.RoiSplit_d1 = cM1;
        generalProperty.RoiSplit_d2 = cM2;
        generalProperty.RoiSplit_I1 = split1;
        generalProperty.RoiSplit_I2 = split2;
        
        if ~isempty(BdaTpaList(1).predictor)
            load(BdaTpaList(1).predictor, 'predictor');
            BehaveData.treadmil_speed.data = predictor.speed;
            BehaveData.treadmil_accel.data = predictor.accel;
            
            BehaveData.treadmil_rest.data = predictor.rest;
            BehaveData.treadmil_walk.data = predictor.walk;
            
            BehaveData.treadmil_posaccel.data = predictor.posaccel;
            BehaveData.treadmil_negaccel.data = predictor.negaccel;
            
            BehaveData.treadmil_posaccel_t.indicator = predictor.posaccel;
            BehaveData.treadmil_negaccel_t.indicator = predictor.negaccel;
            
            BehaveData.treadmil_x_location.data = predictor.x_location;
        end
        
        feval(analysisName,outputPath, generalProperty, imagingData, BehaveData);
    case 'RoiCorrelation'
        load(BdaTpaList(1).roiListNamesPath, 'roiActivityNames','colorMatrix1', 'colorMatrix2', 'selectedROISplitDepth1');
        
        roiToExcludeFromTheTPA = [];
        roiToExcludeFromTheTPA_indexing = 1;
        roiLabels = zeros(1, size(imagingData.roiNames, 1));
        cM1 = zeros(size(imagingData.roiNames, 1), 3);
        cM2 = zeros(size(imagingData.roiNames, 1), 3);
        
        for i = 1:size(imagingData.roiNames, 1)
            locationCurrentROI = find(strcmp(roiActivityNames, sprintf('roi%05d',imagingData.roiNames(i, 1))));

            if isempty(locationCurrentROI)
                roiToExcludeFromTheTPA(roiToExcludeFromTheTPA_indexing) = i;
                roiToExcludeFromTheTPA_indexing = roiToExcludeFromTheTPA_indexing + 1;
                continue;
            else
                roiLabels(i) = selectedROISplitDepth1(locationCurrentROI);
                cM1(i, :) = colorMatrix1(locationCurrentROI, :);
                cM2(i, :) = colorMatrix2(locationCurrentROI, :);
            
            end

        end

        imagingData.samples(roiToExcludeFromTheTPA, :, :) = [];
        imagingData.roiNames(roiToExcludeFromTheTPA, :) = [];
        imagingData.loc(roiToExcludeFromTheTPA) = [];
        roiLabels(roiToExcludeFromTheTPA) = [];
        cM2(roiToExcludeFromTheTPA, :) = [];
        cM1(roiToExcludeFromTheTPA, :) = [];
        
        generalProperty.RoiSplit_d1 = cM1;
        generalProperty.RoiSplit_d2 = cM2;
      
        generalProperty.roiLabels = roiLabels;
        
        [x_data, generalProperty] = createRoiCorrelationMatrix(imagingData, generalProperty);
        imagingData.samples = x_data;
        outputPath = [outputPath, '\', generalProperty.corrTypeRoiCorrelation, '\'];
        mkdir(outputPath);
        
        feval(analysisName,outputPath, generalProperty, imagingData, BehaveData);        
        
%         if (strcmp(analysisName, 'pcaTrajectories'))
%             classesU = unique(roiLabels);
%             for i_u = 1:length(classesU)
%                 generalPropertyT = generalProperty;
%                 imagingDataTemp.samples = imagingData.samples(roiLabels == classesU(i_u), :, :);
%                 imagingDataTemp.roiNames = imagingData.roiNames(roiLabels == classesU(i_u), :);
%                 imagingDataTemp.loc = imagingData.loc(roiLabels == classesU(i_u));
%                 roiLabelsTemp = roiLabels(roiLabels == classesU(i_u));
%                 cm2T = cM2(roiLabels == classesU(i_u), :);
%                 cm1T = cM1(roiLabels == classesU(i_u), :);
% 
%                 generalPropertyT.RoiSplit_d1 = cm1T;
%                 generalPropertyT.RoiSplit_d2 = cm2T;
% 
%                 generalPropertyT.roiLabels = roiLabelsTemp;
% 
%                 [x_dataTemp, generalPropertyT] = createRoiCorrelationMatrix(imagingDataTemp, generalPropertyT);
%                 imagingDataTemp.samples = x_dataTemp;
%                 outputPath = [outputPath, '\', generalPropertyT.corrTypeRoiCorrelation, '\', num2str(i_u),'\'];
%                 mkdir(outputPath);
% 
%                 feval(analysisName,outputPath, generalPropertyT, imagingDataTemp, BehaveData);        
%             end
%         end
%         
        
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
            
%             roiTableNew.activity.rawData.cluster_0 = roiTableNew.activity.rawData.cluster_0(indexingROI, :, :); 
%             roiTableNew.activity.combData.cluster_0 = roiTableNew.activity.combData.cluster_0(indexingROI, :, :); 
            
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
