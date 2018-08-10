function [imagingData, BehaveData] = loadData(BdaTpaList, generalProperty)
% % this list should be a property of the system, when adding a new event,
% % the system nee
% eventNameList      = {'Lift','Grab','Sup','Atmouth','Chew','Sniff','Handopen','Botharm',...
%     'Tone','Table','Failure','Success', 'Trying','failure+1','success+1','nopellet', 'Lick', ...
%     'Regular', 'sucrose','Quinine', 'Sucrose S','Sucrose F' 'BackToPerch' ...
%     'Failure Perch' 'Success Perch' 'T-Failure','P-Failure' 'T-Success' 'P-Success'...
%     'MouthFront' 'Perch' 'Reach' 'Attable','MovmentSuccess','LickAttempt'};

frameRateRatio = generalProperty.BehavioralSamplingRate/generalProperty.ImagingSamplingRate;

fileNumRoi = length(BdaTpaList);
[fileNamesRoi{1:fileNumRoi,1}] = deal(BdaTpaList.TPA);

for trialInd = 1:fileNumRoi
    usrData                    = load(fileNamesRoi{trialInd});
    if ~isfield(usrData, 'strROI')
        error([fileNamesRoi{trialInd} ' has no ROI']);
    end
    for m = 1:length(usrData.strROI)
        imagingData.roiNames(m, trialInd)       = extractROIstr(usrData.strROI{m}.Name);
        % match new format to old format, the deltaF over F is saved in Data(:,2)
        % instead of procROI
        if ~isfield(usrData.strROI{m}, 'Data') && ~isprop(usrData.strROI{m}, 'Data')
            if ~isfield(usrData.strROI{m}, 'procROI')
                error([fileNamesRoi{trialInd} ' unfamiliar TPA file, cannot extract data';]);
            else
                imagingData.samples(m,:, trialInd) = usrData.strROI{m}.procROI;
            end
        else
            imagingData.samples(m,:, trialInd) = usrData.strROI{m}.Data(:,2);
        end
    end
    
end

if any(any(diff(imagingData.roiNames.')))
    error('ROI names are inconsistent through trials');
end

[fileNamesEvent{1:fileNumRoi,1}] = deal(BdaTpaList.BDA);

eventNameList = [];
allTrialEvents                = cell(fileNumRoi,1);
for trialInd = 1:fileNumRoi
    usrData                    = load(fileNamesEvent{trialInd});
    allTrialEvents{trialInd}   = usrData.strEvent;
    for event_i = 1:length(allTrialEvents{trialInd})
        if isempty(eventNameList) || ~any(strcmpi(eventNameList, allTrialEvents{trialInd}{event_i}.Name))
            eventNameList{end+1} = lower(allTrialEvents{trialInd}{event_i}.Name);
        end
    end
end
framNum = size(imagingData.samples,2);
for eventName_i = 1:length(eventNameList)
    eventNameList{eventName_i}(eventNameList{eventName_i}==':') = '_';
    eventNameList{eventName_i}(eventNameList{eventName_i}=='-') = '_';
    BehaveData.(eventNameList{eventName_i}).indicator = zeros(size(imagingData.samples,3), framNum);
end

for trial_i = 1:fileNumRoi
    for m = 1:length(allTrialEvents{trial_i}) 
        eventname = lower(allTrialEvents{trial_i}{m}.Name);
        eventname(eventname==':') = '_';
        eventname(eventname=='-') = '_';
        if length(allTrialEvents{trial_i}{m}.tInd) ==2
            timeInd     = allTrialEvents{trial_i}{m}.tInd;
        else
            timeInd     = allTrialEvents{trial_i}{m}.TimeInd;
        end
        if isempty(timeInd)
            continue;
        end
        %             frameRateRatio=size(allTrialEvents{trial_i}{end}.Data,1)/size(eventDataArray,1);
        %                 frameRateRatio=18
        timeInd     = round((timeInd-generalProperty.BehavioralDelay)./frameRateRatio); % transfers to time of the two photon
        timeInd     = max(1,min(framNum,timeInd));
        % assign to vector
        BehaveData.(eventname).indicator(trial_i, timeInd(1):timeInd(2)) = 1;
        BehaveData.(eventname).eventTimeStamps{trial_i} = timeInd;
    end
end
if isfield(BehaveData, 'failure')
    [I,~] = find(BehaveData.failure.indicator);
    BehaveData.failure = zeros(fileNumRoi,1);
    BehaveData.failure(unique(I)) = 1;
end
if isfield(BehaveData, 'success')
    [I,~] = find(BehaveData.success.indicator);
    BehaveData.success = zeros(fileNumRoi,1);
    BehaveData.success(unique(I)) = 1;
end

if generalProperty.Neurons2keep ~= 0
    imagingData.samples=imagingData.samples(generalProperty.Neurons2keep, :,:);
    imagingData.roiNames = imagingData.roiNames(generalProperty.Neurons2keep);
end
% if generalProperty.Trials2keep == 0
%     return;
% end

for event_i = 1:length(eventNameList)
    switch eventNameList{event_i}
        case {'failure', 'success'}
            BehaveData.(eventNameList{event_i})=BehaveData.(eventNameList{event_i})(:);
        otherwise
            BehaveData.(eventNameList{event_i}).indicator=BehaveData.(eventNameList{event_i}).indicator(:, :);
    end
end
imagingData = imagingData(:, :, :);
