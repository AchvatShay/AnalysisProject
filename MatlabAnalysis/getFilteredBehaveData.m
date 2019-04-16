function [X, x] = getFilteredBehaveData(successLabel, BehaveData, eventsnames, eventtypes, ...
splinesFuns, trialsinds, timeinds, timeindsTraj, generalProperty)

types = unique(eventtypes);
tsize = length(timeinds);
X.filt = [];X.name = [];X.type = [];
eventsOfBehave = fields(BehaveData);
for ei = 1:length(eventsnames)
    switch eventsnames{ei}
        case 'traj'
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
        case 'tone'
            t = linspace(0, generalProperty.Duration, size(BehaveData.(eventsOfBehave{1}).indicator,2))-generalProperty.ToneTime;
            indicatorMat = zeros(sum(trialsinds), length(t));
            [~, toneInd] = min(abs(t-0));
            indicatorMat(:, toneInd) = 1;
            indicatorMat = indicatorMat(:, timeinds);
%             if all(indicatorMat(:)==0)
%                 break;
%             end
            for k = 1:size(splinesFuns, 2)
                X.filt{end+1} = filter(splinesFuns(:, k), 1, indicatorMat.').';
                X.name{end+1} = eventsnames{ei};
            X.type(end+1) = find(strcmp(eventtypes{ei}, types));
            end
        case 'atmouth'
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
            for k = 1:size(splinesFuns, 2)
                X.filt{end+1} = filter(splinesFuns(:, k), 1, indicatorMat.').';
                X.name{end+1} = eventsnames{ei};
            X.type(end+1) = find(strcmp(eventtypes{ei}, types));
            end
        otherwise
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
            for k = 1:size(splinesFuns, 2)
                X.filt{end+1} = filter(splinesFuns(:, k), 1, indicatorMat.').';
                X.name{end+1} = eventsnames{ei};
            X.type(end+1) = find(strcmp(eventtypes{ei}, types));
            end
    end
    
end
X.filt{end+1} = kron(BehaveData.(successLabel).indicatorPerTrial(trialsinds==true)',...
    ones(tsize,1)).';
X.name{end+1} = successLabel;
X.type(end+1) = find(strcmp('reward', types));


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