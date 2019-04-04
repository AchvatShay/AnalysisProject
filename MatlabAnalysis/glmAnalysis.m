function glmAnalysis(outputPath, generalProperty, imagingData, BehaveData)
splinesFile = 'splines.csv';
calcConst = true;


if ~exist(splinesFile, 'file')
    error('Splines file does not exist!');
    % use this R code to create that file..
    % require(stats);
    % require(graphics)
    % x <- seq.int(0, 1-1/30, 1/30)
    %
    % mat = bSpline(x, df = NULL, knots = NULL, degree = 7, intercept = TRUE,Boundary.knots = range(x, na.rm = TRUE))
    % matplot(x, mat, type = "l", ylab = "scaled I-spline basis")
    % write.csv(mat, file = 'splines.csv')
end
splinesFuns=xlsread(splinesFile);
splinesFuns = splinesFuns(2:end, :);
splinesFuns = splinesFuns(:, 2:end);

t = linspace(0, generalProperty.Duration, size(imagingData.samples, 2));
figure;
for k = 1:size(splinesFuns, 2)
    subplot(size(splinesFuns, 2), 1, k);
    plot(t(1:size(splinesFuns,1)), splinesFuns(:, k));
    ylabel(num2str(k));
end
xlabel('Time [seconds]');
gamma_c = logspace(-4, -2, 9);

eventsMovements = generalProperty.glm_events;
% timesegments = [0:12:generalProperty.Duration] - generalProperty.ToneTime;
timesegments = [0:4:generalProperty.Duration] - generalProperty.ToneTime;
foldsNum = 5;
t = linspace(0, generalProperty.Duration, size(imagingData.samples,2)) - generalProperty.ToneTime;
ttraj = linspace(0, generalProperty.Duration, size(BehaveData.traj.data,2)) - generalProperty.ToneTime;

INDICES = crossvalind('Kfold',size(imagingData.samples, 3),foldsNum);
for time_seg_i = [2  ]%3 4  11:length(timesegments)-1
    timeinds = find(t >= timesegments(time_seg_i) & t <= timesegments(time_seg_i+1));
    timeinds_traj = find(ttraj >= timesegments(time_seg_i) & ttraj <= timesegments(time_seg_i+1));
    for fold_i = 1:foldsNum        
        test_i = INDICES == fold_i;
        train_i = ~test_i;        
        Y_train = imagingData.samples(:, timeinds, train_i == true);
        Y_test = imagingData.samples(:, timeinds, test_i == true);
        [X_train, x_train] = getFilteredBehaveData(generalProperty.successLabel,...
            BehaveData, eventsMovements, splinesFuns, train_i, timeinds, timeinds_traj);
        [X_test, x_test] = getFilteredBehaveData(generalProperty.successLabel, ...
            BehaveData, eventsMovements, splinesFuns, test_i, (timeinds), timeinds_traj);
        types = unique(X_train.type);
        for nrni = 1:size(imagingData.samples, 1)
            tt = tic;
            disp([time_seg_i/(length(timesegments)-1) nrni/size(imagingData.samples, 1) fold_i/foldsNum]);
            Ytr = squeeze(Y_train(nrni, :, :));
            Yte = squeeze(Y_test(nrni, :, :));
            [~, ~, R2full_tr(nrni, fold_i,time_seg_i ), R2full_te(nrni, fold_i, time_seg_i)] = LassoCV(x_train, Ytr(:), foldsNum, x_test, Yte(:));
            
            for type_i = 1:length(types)
                binds = setdiff(1:size(x_train,2), find(X_train.type==types(type_i)));
                [~, ~, R2p_train(nrni, type_i, fold_i, time_seg_i), R2p_test(nrni, type_i, fold_i, time_seg_i)] = ...
                    LassoCV(x_train(:, binds), Ytr(:), foldsNum, x_test(:, binds), Yte(:));            
            end
            Rnorm_tr(nrni, :, fold_i, time_seg_i) = R2p_train(nrni, :, fold_i, time_seg_i)/R2full_tr(nrni, fold_i, time_seg_i);
            contribution_tr(nrni, :, fold_i, time_seg_i) = (1-Rnorm_tr(nrni,:, fold_i, time_seg_i))/sum(1-Rnorm_tr(nrni,:, fold_i, time_seg_i));            
            Rnorm_te(nrni, :, fold_i, time_seg_i) = R2p_test(nrni, :, fold_i, time_seg_i)/R2full_te(nrni, fold_i, time_seg_i);
            contribution_te(nrni, :, fold_i, time_seg_i) = (1-Rnorm_te(nrni,:, fold_i, time_seg_i))/sum(1-Rnorm_te(nrni,:, fold_i, time_seg_i));            
            disp('Train');
            disp(mean(mean(contribution_tr(1:nrni, :, 1:fold_i, time_seg_i),1),3));
            disp('Test');
            disp(mean(mean(contribution_te(1:nrni, :, 1:fold_i, time_seg_i),1),3));
            toc(tt);
        end
    end
end
leg = [eventsMovements, {'Success/Failure'}];
for time_seg_i = 1:2%length(timesegments)-1
    inds = find(mean(R2full_te(:,:,2),2)>0.95); 
    M_tr(:,time_seg_i) = mean(mean(contribution_tr(inds, :, :, time_seg_i),3),1);
    S_tr(:,time_seg_i) = std(mean(contribution_tr(inds, :, :, time_seg_i),3),[],1);
    n = size(contribution_tr(inds, :, :, time_seg_i),1);
    SEM_tr(:,time_seg_i) = S_tr(:,time_seg_i)/sqrt(n);
    M_te(:,time_seg_i) = mean(mean(contribution_te(inds, :, :, time_seg_i),3),1);
    S_te(:,time_seg_i) = std(mean(contribution_te(inds, :, :, time_seg_i),3),[],1);
    n = size(contribution_te(inds, :, :, time_seg_i),1);
    SEM_te(:,time_seg_i) = S_te(:,time_seg_i)/sqrt(n);
end

figure;barwitherr(100*SEM_tr',100*M_tr');
legend( leg)
xlabel('Segment');
ylabel('% Contribution');
title(['Train']);
figure;barwitherr(100*SEM_te',100*M_te');
legend( leg)
xlabel('Segment');
ylabel('% Contribution');
title(['Test']);
% M = mean(mean(contribution_te(:, :, :, time_seg_i),3),1);
% S = std(mean(contribution_te(:, :, :, time_seg_i),3),[],1);
% n = size(contribution_te,1);
% SEM = S/sqrt(n);
% figure;barwitherr(100*SEM,100*M);
% set(gca,'XTickLabel', leg)
% xlabel('Predictor');
% ylabel('% Contribution');
% title(['Test Segment #' num2str(time_seg_i)]);
%
types = unique(X_test.type);
figure;
for time_seg_i = 1:length(timesegments)-1
    
    for type_i = 1:length(leg)
        subplot(2,length(timesegments)-1,(time_seg_i-1)*2+type_i);
        hist(mean(100*contribution_tr(:, type_i, :, time_seg_i),3), 100);
        ylabel('# Neurons');
        xlabel('% Contribution');
        title([leg{type_i} ' Segment #' num2str(time_seg_i)]);
    end
    
    
    
    
    % figure;
    % for type_i = 1:length(leg)
    % subplot(2,1,type_i);
    % hist(mean(100*contribution_te(:, type_i, :, time_seg_i),3), 100);
    % ylabel('# Neurons');
    % xlabel('% Contribution');
    % title(leg{type_i});
    % end
    % suptitle(['Test Segment #' num2str(time_seg_i)]);
end
suptitle(['Train ' ]);


figure;
for time_seg_i = 1:length(timesegments)-1
    
    for type_i = 1:length(leg)
        subplot(2,length(timesegments)-1,(time_seg_i-1)*2+type_i);
        hist(mean(100*contribution_te(:, type_i, :, time_seg_i),3), 100);
        ylabel('# Neurons');
        xlabel('% Contribution');
        title([leg{type_i} ' Segment #' num2str(time_seg_i)]);
    end
    
    
    
    
end
suptitle(['Test' ]);
