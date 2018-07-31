
eventNameList      = {'Lift','Grab','Sup','Atmouth','Chew','Sniff','Handopen','Botharm',...
    'Tone','Table','Failure','Success', 'Trying','failure+1','success+1','nopellet', 'Lick', ...
    'Regular', 'sucrose','Quinine', 'Sucrose S','Sucrose F' 'BackToPerch' ...
    'Failure Perch' 'Success Perch' 'T-Failure','P-Failure' 'T-Success' 'P-Success'...
    'MouthFront' 'Perch' 'Reach' 'Attable','MovmentSuccess','LickAttempt'}; % (do not touch)
trajEventList = {'EV:side:AverTrajX','EV:side:AverTrajY'};

if (exist(fullfile(outpth, 'sampsAndBehave.mat'), 'file') )&& ~overwrite%(exist(fullfile(analysisDirin, 'samps.mat'), 'file'))
       return;
end
if (exist(fullfile(outpth, 'samps.mat'), 'file') )&& ~overwrite%(exist(fullfile(analysisDirin, 'samps.mat'), 'file'))
      return;
end


%%%
% Load Two Photon ROI data
%%%
fileNames        = dir(fullfile(analysisDirin,'TPA_*.mat'));
fileNum          = length(fileNames);trajBehave=[];
if fileNum < 1,
    warning('TwoPhoton : Can not find data files in the directory %s. Check file or directory names.',analysisDirin);
    return;
end;
[fileNamesRoi{1:fileNum,1}] = deal(fileNames.name);
fileNumRoi                  = fileNum;

allTrialRois                    = cell(fileNumRoi,1);
for trialInd = 1:fileNumRoi,
    fileToLoad                 = fullfile(analysisDirin,fileNamesRoi{trialInd});
    usrData                    = load(fileToLoad);
    if ~isfield(usrData, 'strROI')
        disp([analysisDirin ' no ROI']);
        noROI = true;break;
    end
    allTrialRois{trialInd}     = usrData.strROI;
end
if noROI
    noROI=false;
    return;
end
% match new format to old format, the deltaF over F is saved in Data(:,2)
% instead of procROI
if ~isfield(allTrialRois{trialInd}{1}, 'Data') && ~isprop(allTrialRois{trialInd}{1}, 'Data')
    if isfield(allTrialRois{trialInd}{1}, 'procROI')
        for trialInd = 1:fileNumRoi,
            for m = 1:length(allTrialRois{trialInd})
                allTrialRois{trialInd}{m}.Data(:,2) = allTrialRois{trialInd}{m}.procROI;
            end
        end
    else
        error('Unclear on which field the data is saved');
    end
end
%%%
% Load Behavioral Event data
%%%
fileNames        = dir(fullfile(analysisDirin,'BDA_*.mat'));
fileNum          = length(fileNames);
if ~isloadbehave
    fileNum=0;
end
if fileNum < 1,
    warning('Behavior : Can not find data files in the directory %s. Check file or directory names.',analysisDirin);
    isloadbehave = false;
else
    isloadbehave = true;
    [fileNamesEvent{1:fileNum,1}] = deal(fileNames.name);
    fileNumEvent                  = fileNum;
    
    allTrialEvents                = cell(fileNumEvent,1);
    for trialInd = 1:fileNumEvent,
        fileToLoad                 = fullfile(analysisDirin,fileNamesEvent{trialInd});
        usrData                    = load(fileToLoad);
        allTrialEvents{trialInd}   = usrData.strEvent;
    end
    
    %%%
    % Convert Event names to Ids
    %%%
    % add field Id
    eventNameList                  = lower(eventNameList);
    for trialInd = 1:fileNumEvent,
        eventNum                   = length(allTrialEvents{trialInd});
        for m = 1:eventNum,
            eName                      = lower(allTrialEvents{trialInd}{m}.Name);
            eBool                      = strncmp(eName, eventNameList,3);
            eInd                       = find(eBool);
            if length(eInd) > 1
                for ee=1:length(eInd)
                    eBool                      = strncmp(eName, eventNameList{eInd(ee)},length(eventNameList{eInd(ee)}));
                eIndd{ee}                       = find(eBool);
                end
            end
            if length(eInd) > 1
            for ee=1:length(eIndd)
                if ~isempty(eIndd{ee})
                    eBool                      = strncmp(eName, eventNameList,length(eventNameList{eInd(ee)}));
                    eInd                       = find(eBool);
                    eInd=eInd(eIndd{ee}  );
                    break;
                end
            end
            end
            if length(eInd) > 1
                eBool                      = strcmp(eName, eventNameList);
                eInd                       = find(eBool);
            end
            if isempty(eInd),
                eInd = find(strcmpi(eName, trajEventList),1);
                if ~isempty(eInd)&&0
                    %                         frameRateRatio=size(allTrialEvents{trialInd}{m}.Data,1)/size(eventDataArray,1);
                    
                    trajBehave(eInd, :,trialInd) = decimate(double(allTrialEvents{trialInd}{m}.Data),frameRateRatio);
                    eInd=0;
                else
                    fprintf('W : Trial %d, Event %d has undefined name %s. Set Id = 0.\n',trialInd,m,allTrialEvents{trialInd}{m}.Name)
                    eInd = 0;
                end
            end
            allTrialEvents{trialInd}{m}.Id = eInd;
        end
    end
end
roisPerTrialNum   = length(allTrialRois{2});
dffDataArray     = zeros(roisPerTrialNum,length(allTrialRois{1}{1}.Data(:,2)),length(allTrialRois));

for trial_i = 1:min(fileNumRoi)%,fileNumEvent)
    %%%
    % Extract specific trial data for Two Photon ROI
    %%%
    % check
    if trial_i < 1 || trial_i > fileNumRoi,
        error('Requested trial should be in range [1:%d]',fileNumRoi)
    end
    %         if trial_i < 1 || trial_i > fileNumEvent,
    %             error('Requested trial should be in range [1:%d]',fileNumEvent)
    %         end
    
    % extract ROI dF/F data
    
    if roisPerTrialNum < 1,
        error('Could not find ROI data for trial %d',trial_i)
    end
    dffData          = allTrialRois{trial_i}{1}.Data(:,2); % actual data
    [framNum,~]      = size(dffData);
    
    roiNames         = cell(1,roisPerTrialNum);
    % collect
    
    for m = 1:roisPerTrialNum,
        if isempty(allTrialRois{trial_i}{m}.Data),
            error('Two Photon data is not complete. Can not find dF/F results.')
        end
        dffDataArray(m,:, trial_i) = allTrialRois{trial_i}{m}.Data(:,2);
        roiLoc{m} = allTrialRois{trial_i}{m}.xyInd;
        roiNames{m}       = allTrialRois{trial_i}{m}.Name;
    end
end
if fileNum >= 1
    %%%
    % Extract specific trial data for Behavioral Events
    %%%
    % extract Event Time data
    eventsPerTrialNum = 0;
    for trial_i = 1:length(allTrialRois)
        eventsPerTrialNum   = max(eventsPerTrialNum, length(allTrialEvents{trial_i}));
    end
    if eventsPerTrialNum < 1,
        warning('Could not find Event data for trial %d',trial_i);
    end
    timeData         = allTrialEvents{trial_i}{1}.TimeInd; % actual data
    eventDataArray   = zeros(framNum,eventsPerTrialNum, length(allTrialRois));
    %         eventNames       = cell(1,eventsPerTrialNum);
    
    % collect
    for trial_i = 1:length(allTrialRois)
        for m = 1:length(allTrialEvents{trial_i}),
            if find(strcmpi(allTrialEvents{trial_i}{m}.Name, trajEventList),1)
                continue;
            end
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
            timeInd     = round((timeInd-delayFrames)./frameRateRatio); % transfers to time of the two photon
            timeInd     = max(1,min(framNum,timeInd));
            % assign to vector
            eventDataArray(timeInd(1):timeInd(2),m, trial_i) = allTrialEvents{trial_i}{m}.Id;
            eventNames{m} = sprintf('%s - %d',allTrialEvents{trial_i}{m}.Name, allTrialEvents{trial_i}{m}.SeqNum);
        end
    end
    
    %%%
    % Show
    %%%
    timeImage       = 1:framNum;
    figure,
    subplot(221)
    plot(timeImage,dffDataArray(:,:,trial_i)),legend(roiNames)
    xlabel('Time [Frame]'), ylabel('dF/F'), title(sprintf('Two Photon data for trial %d',trial_i))
    if isloadbehave
        subplot(222)
        plot(timeImage,eventDataArray(:,:,trial_i))%,legend(eventNames)
        xlabel('Time [Frame]'), ylabel('Events'), title(sprintf('Event duration data for trial %d',trial_i))
    end
    subplot(223);imagesc(dffDataArray(:,:,trial_i))
    subplot(224);imagesc(eventDataArray(:,:,trial_i).')
    
    mkNewFolder(outpth);
    save(fullfile(outpth, 'sampsAndBehave'), 'trajBehave','dffDataArray', 'eventDataArray', 'roiNames', 'eventNameList', 'roiLoc', 'frameRateRatio');
else
    save(fullfile(outpth, 'samps'), 'dffDataArray', 'roiNames', 'roiLoc', 'frameRateRatio');
    
end
end
