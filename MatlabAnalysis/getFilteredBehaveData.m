function [X, x] = getFilteredBehaveData(successLabel, BehaveData, eventsMovements, ...
splinesFuns, trialsinds, timeinds, timeindsTraj)


tsize = length(timeinds);
X.filt = [];X.name = [];X.type = [];
eventsOfBehave = fields(BehaveData);
for ei = 1:length(eventsMovements)
    if strcmp('traj',eventsMovements{ei})
        datatraj = BehaveData.(eventsMovements{(ei)}).data(:, timeindsTraj, :);
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
            X.name{end+1} = [eventsMovements{ei} num2str(di)];
            X.type(end+1) = ei;
            
        end
        continue;
    end
    inds = find(contains(eventsOfBehave, eventsMovements{ei}));
    if isempty(inds)
        error(['Cannot find event named ' eventsMovements{ei} ' in BDA']);
    end
    indicatorMat = zeros(sum(trialsinds==true), tsize);
    for ii = 1:length(inds)
        indicatorMat = indicatorMat | BehaveData.(eventsOfBehave{inds(ii)}).indicator(trialsinds==true, timeinds);
    end
    
    for k = 1:size(splinesFuns, 2)
        X.filt{end+1} = filter(splinesFuns(:, k), 1, indicatorMat.').';
        X.name{end+1} = eventsMovements{ei};
        X.type(end+1) = ei;
    end
end
X.filt{end+1} = kron(BehaveData.(successLabel).indicatorPerTrial(trialsinds==true)',...
    ones(tsize,1)).';
X.name{end+1} = successLabel;
X.type(end+1) = ei+1;


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