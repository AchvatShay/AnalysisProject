function [X, x] = getFilteredBehaveData(successLabel, BehaveData, ...
    eventsnames, eventtypes,  ...
    splinesFuns, trialsinds, timeinds, timeindsTraj, generalProperty)

types = unique(eventtypes, 'stable');
tsize = length(timeinds);
X.filt = [];X.name = [];X.type = [];
eventsOfBehave = fields(BehaveData);
for ei = 1:length(eventsnames)
    if strcmp(eventsnames{ei}, 'success')
        X.filt{end+1} = kron(BehaveData.(successLabel).indicatorPerTrial(trialsinds==true)',...
            ones(tsize,1)).';
        X.name{end+1} = successLabel;
        X.type(end+1) = find(strcmp('reward', types));
    elseif strcmp(eventsnames{ei},'leftface') || strcmp(eventsnames{ei}, 'rightface') || ...
           strcmp(eventsnames{ei}, 'righthand') || strcmp(eventsnames{ei},'lefthand')
        switch (eventsnames{ei})
            case 'leftface'
                datasvm = BehaveData.faceMapL(:, timeindsTraj, :);
            case 'rightface'
                datasvm = BehaveData.faceMapR(:, timeindsTraj, :);
            case 'lefthand'
                datasvm = BehaveData.handMapL(:, timeindsTraj, :);
            case 'righthand'
                datasvm = BehaveData.handMapR(:, timeindsTraj, :);
        end
        t = linspace(0, 1, tsize);
        ttraj = linspace(0, 1, size(timeindsTraj, 2));
        for T = 1:length(trialsinds)
            if trialsinds(T) == true
                for di = 1:generalProperty.glm_facial_features_dim
                    traj_sampled(di, :, T) = interp1(ttraj, datasvm(di, :, T), t);
                end
            end
        end
        traj_sampled = traj_sampled(:,:,trialsinds == true);
        for di = 1:size(traj_sampled,1)
            indicatorMat = squeeze(traj_sampled(di,:,:))';
            X.filt{end+1} = indicatorMat;
            X.name{end+1} = [eventsnames{ei} num2str(di)];
            X.type(end+1) = find(strcmp(eventtypes{ei}, types));

        end
    elseif strcmp(eventsnames{ei}, 'traj')
        datatraj = BehaveData.(eventsnames{(ei)}).data(:, timeindsTraj, :);
        t = linspace(0, 1, tsize);
        ttraj = linspace(0, 1, size(timeindsTraj, 2));
        for T = 1:length(trialsinds)
            if trialsinds(T) == true
                for di = 1:size(datatraj,1)
                    traj_sampled(di, :, T) = interp1(ttraj, datatraj(di, :, T), t);
                end
            end
        end
        traj_sampled = traj_sampled(:,:,trialsinds == true);
        for di = 1:size(traj_sampled,1)
            indicatorMat = squeeze(traj_sampled(di,:,:))';
            X.filt{end+1} = indicatorMat;
            X.name{end+1} = [eventsnames{ei} num2str(di)];
            X.type(end+1) = find(strcmp(eventtypes{ei}, types));

        end
    elseif strcmp(eventsnames{ei}, 'treadmil_speed') || strcmp(eventsnames{ei}, 'treadmil_x_location') || ...
           strcmp(eventsnames{ei}, 'treadmil_accel') || strcmp(eventsnames{ei}, 'treadmil_posaccel') || ...
           strcmp(eventsnames{ei}, 'treadmil_speed') || strcmp(eventsnames{ei}, 'treadmil_x_location') || ...
           strcmp(eventsnames{ei}, 'treadmil_negaccel') || strcmp(eventsnames{ei}, 'treadmil_rest') || ...
           strcmp(eventsnames{ei}, 'treadmil_walk')
        datatraj = BehaveData.(eventsnames{(ei)}).data(:, timeinds)';
        t = linspace(0, 1, tsize);
        ttraj = linspace(0, 1, size(timeinds, 2));
        for T = 1:length(trialsinds)
            if trialsinds(T) == true                   
               tread_sampled(:, T) = interp1(ttraj, datatraj(:, T), t);  
            end
        end
        tread_sampled = tread_sampled(:,trialsinds == true);
        indicatorMat = (tread_sampled(:,:))';
        X.filt{end+1} = indicatorMat;
        X.name{end+1} = [eventsnames{ei}];
        X.type(end+1) = find(strcmp(eventtypes{ei}, types));
    elseif strcmp(eventsnames{ei}, 'tone')
        t = linspace(0, generalProperty.Duration, size(BehaveData.(eventsOfBehave{1}).indicator,2))-generalProperty.ToneTime;
        indicatorMat = zeros(sum(trialsinds), length(t));
        [~, toneInd] = min(abs(t-0));
        indicatorMat(:, toneInd) = 1;
        indicatorMat = indicatorMat(:, timeinds);
        %             if all(indicatorMat(:)==0)
        %                 break;
        %             end
        for sp_i = 1:length(splinesFuns)
            for k = 1:size(splinesFuns{sp_i}.func, 2)
                for j = 1:length(splinesFuns{sp_i}.delay)
                    delayF = abs(splinesFuns{sp_i}.delay(j)*generalProperty.ImagingSamplingRate);
                    if splinesFuns{sp_i}.delay(j) > 0
                        indicatorMatDelay = [zeros(size(indicatorMat, 1), delayF), indicatorMat(:, 1:(end-delayF))];
                    elseif splinesFuns{sp_i}.delay(j) < 0
                        indicatorMatDelay = [indicatorMat(:, (delayF+1):end), zeros(size(indicatorMat, 1), delayF)];
                    else
                        indicatorMatDelay = indicatorMat;
                    end
                        
                    sp_del = splinesFuns{sp_i}.func(:, k);              
                    X.filt{end+1} = filter(sp_del, 1, indicatorMatDelay.').';
                    X.name{end+1} = eventsnames{ei};
                    X.type(end+1) = find(strcmp(eventtypes{ei}, types));
                    sp_del = [];
                end
            end
        end
    elseif strcmp(eventsnames{ei}, 'atmouth')
        inds = find(contains(eventsOfBehave, 'atmouth'));
        indsdiscard = find(contains(eventsOfBehave, 'atmouthnopellet'));
        inds = setdiff(inds, indsdiscard);
        indicatorMat = zeros(sum(trialsinds==true), tsize);
        for ii = 1:length(inds)
            indicatorMat = indicatorMat | BehaveData.(eventsOfBehave{inds(ii)}).indicator(trialsinds==true, timeinds);
        end
        %             if all(indicatorMat(:)==0)
        %                 break;
        %             end

        for sp_i = 1:length(splinesFuns)
            for k = 1:size(splinesFuns{sp_i}.func, 2)
                for j = 1:length(splinesFuns{sp_i}.delay)
                    delayF = abs(splinesFuns{sp_i}.delay(j)*generalProperty.ImagingSamplingRate);
                    if splinesFuns{sp_i}.delay(j) > 0
                        indicatorMatDelay = [zeros(size(indicatorMat, 1), delayF), indicatorMat(:, 1:(end-delayF))];
                    elseif splinesFuns{sp_i}.delay(j) < 0
                        indicatorMatDelay = [indicatorMat(:, (delayF+1):end), zeros(size(indicatorMat, 1), delayF)];
                    else
                        indicatorMatDelay = indicatorMat;
                    end
                        
                    sp_del = splinesFuns{sp_i}.func(:, k);              
                    X.filt{end+1} = filter(sp_del, 1, indicatorMatDelay.').';
                    X.name{end+1} = eventsnames{ei};
                    X.type(end+1) = find(strcmp(eventtypes{ei}, types));
                    sp_del = [];
                end
            end
        end
    else
        inds = find(contains(eventsOfBehave, eventsnames{ei}));
        if isempty(inds)
            error(['Cannot find event named ' eventsnames{ei} ' in BDA']);
        end
        indicatorMat = zeros(sum(trialsinds==true), tsize);
        for ii = 1:length(inds)
            indicatorMat = indicatorMat | BehaveData.(eventsOfBehave{inds(ii)}).indicator(trialsinds==true, timeinds);
        end
        %             if all(indicatorMat(:)==0)
        %                 break;
        %             end
        for sp_i = 1:length(splinesFuns)
            for k = 1:size(splinesFuns{sp_i}.func, 2)
                for j = 1:length(splinesFuns{sp_i}.delay)
                    delayF = abs(splinesFuns{sp_i}.delay(j)*generalProperty.ImagingSamplingRate);
                    if splinesFuns{sp_i}.delay(j) > 0
                        indicatorMatDelay = [zeros(size(indicatorMat, 1), delayF), indicatorMat(:, 1:(end-delayF))];
                    elseif splinesFuns{sp_i}.delay(j) < 0
                        indicatorMatDelay = [indicatorMat(:, (delayF+1):end), zeros(size(indicatorMat, 1), delayF)];
                    else
                        indicatorMatDelay = indicatorMat;
                    end
                        
                    sp_del = splinesFuns{sp_i}.func(:, k);              
                    X.filt{end+1} = filter(sp_del, 1, indicatorMatDelay.').';
                    X.name{end+1} = eventsnames{ei};
                    X.type(end+1) = find(strcmp(eventtypes{ei}, types));
                    sp_del = [];
                end
            end
        end
    end    
end



x = [];
for k = 1:length(X.name)-1
    for l = 1:size(X.filt{k}, 1)
        x1(l, :) = zscore(X.filt{k}(l,:));
    end
    x1=x1.';
    x = cat(2, x, x1(:));
    x1=[];
end
x1 = X.filt{end}.';
x = cat(2, x, x1(:));