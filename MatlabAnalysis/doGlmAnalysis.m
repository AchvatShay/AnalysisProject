function doGlmAnalysis(BehaveData, timesegments, t, ttraj, foldsNum, INDICES, imagingData, ...
    generalProperty, splinesFuns, eventsNames, eventsTypes, outputpath, outputfile, isprev, energyth)
if isprev
    BehaveDataPrev.(generalProperty.successLabel).indicatorPerTrial = BehaveData.(generalProperty.successLabel).indicatorPerTrial(1:end-1);
    BehaveDataPrev.traj.data = BehaveData.traj.data(:,:,1:end-1);
    BehaveData = BehaveDataPrev;
    eventsNames = {'traj'};
    eventsTypes = {'kinematics'};
end
leg = [eventsTypes 'reward'];
if exist(fullfile(outputpath, [outputfile '.mat']), 'file')
    load(fullfile(outputpath, outputfile));
else
    for time_seg_i = 1:size(timesegments,2)
        timeinds = find(t >= timesegments(1,time_seg_i) & t <= timesegments(2,time_seg_i));
        timeinds_traj = find(ttraj >= timesegments(1,time_seg_i) & ttraj <= timesegments(2, time_seg_i));
        for fold_i = 1:foldsNum
            test_i = INDICES == fold_i;
            train_i = ~test_i;
            if isprev
                test_i = test_i(2:end);
                train_i = train_i(2:end);
            end
            Y_train = imagingData.samples(:, :, train_i == true);
            Y_train = Y_train(:,timeinds,:);
            Y_test = imagingData.samples(:, :, test_i == true);
            Y_test = Y_test(:,timeinds,:);
            [X_train, x_train] = getFilteredBehaveData(generalProperty.successLabel,...
                BehaveData, eventsNames, [eventsTypes, 'reward'], splinesFuns, train_i, timeinds, timeinds_traj, generalProperty);
            [X_test, x_test] = getFilteredBehaveData(generalProperty.successLabel, ...
                BehaveData, eventsNames, [eventsTypes, 'reward'], splinesFuns, test_i, (timeinds), timeinds_traj, generalProperty);
            types = unique(X_train.type);
            for nrni = 1:size(imagingData.samples, 1)
                tt = tic;
                disp([time_seg_i/(length(timesegments)-1) nrni/size(imagingData.samples, 1) fold_i/foldsNum]);
                Ytr = squeeze(Y_train(nrni, :, :));
                Yte = squeeze(Y_test(nrni, :, :));
                [~, ~, R2full_tr{time_seg_i}(nrni, fold_i ), R2full_te{time_seg_i}(nrni, fold_i)] = LassoCV(x_train, Ytr(:), foldsNum, x_test, Yte(:));
                
                for type_i = 1:length(types)
                    binds = setdiff(1:size(x_train,2), find(X_train.type==types(type_i)));
                    [~, ~, R2p_train{time_seg_i}(nrni, type_i, fold_i), R2p_test{time_seg_i}(nrni, type_i, fold_i)] = ...
                        LassoCV(x_train(:, binds), Ytr(:), foldsNum, x_test(:, binds), Yte(:));
                end
                Rnorm_tr{time_seg_i}(nrni, :, fold_i) = R2p_train{time_seg_i}(nrni, :, fold_i)/R2full_tr{time_seg_i}(nrni, fold_i);
                contribution_tr{time_seg_i}(nrni, :, fold_i) = (1-Rnorm_tr{time_seg_i}(nrni,:, fold_i))/sum(1-Rnorm_tr{time_seg_i}(nrni,:, fold_i));
                Rnorm_te{time_seg_i}(nrni, :, fold_i) = R2p_test{time_seg_i}(nrni, :, fold_i)/R2full_te{time_seg_i}(nrni, fold_i );
                contribution_te{time_seg_i}(nrni, :, fold_i) = (1-Rnorm_te{time_seg_i}(nrni,:, fold_i))/sum(1-Rnorm_te{time_seg_i}(nrni,:, fold_i));
                disp('Train');
                disp(mean(mean(contribution_tr{time_seg_i}(1:nrni, :, 1:fold_i),1),3));
                disp('Test');
                disp(mean(mean(contribution_te{time_seg_i}(1:nrni, :, 1:fold_i),1),3));
                toc(tt);
            end
            
        end
        
        save(fullfile(outputpath, outputfile), 'contribution_te','contribution_tr','Rnorm_tr','Rnorm_te','R2full_tr','R2full_te','R2full_te','R2full_tr','timesegments','leg');
    end
end
for time_seg_i = 1:size(timesegments,2)
    inds = find(nanmean(R2full_te{time_seg_i},2)<=energyth & nanmean(R2full_te{time_seg_i},2) < 1);
    N_te(time_seg_i) = length(inds);
    M_tr(:,time_seg_i) = nanmean(nanmean(contribution_tr{time_seg_i}(inds, :, :),3),1);
    S_tr(:,time_seg_i) = nanstd(nanmean(contribution_tr{time_seg_i}(inds, :, :),3),[],1);
    n = size(contribution_tr{time_seg_i}(inds, :, :),1);
    SEM_tr(:,time_seg_i) = S_tr(:,time_seg_i)/sqrt(n);
    M_te(:,time_seg_i) = nanmean(nanmean(contribution_te{time_seg_i}(inds, :, :),3),1);
    S_te(:,time_seg_i) = nanstd(nanmean(contribution_te{time_seg_i}(inds, :, :),3),[],1);
    n = size(contribution_te{time_seg_i}(inds, :, :),1);
    SEM_te(:,time_seg_i) = S_te(:,time_seg_i)/sqrt(n);
end
plotContribution(SEM_tr, M_tr, isprev, leg);
title(['Train, % of Neurons is: ' num2str(n/size(imagingData.samples,3))]);
mysave(gcf, fullfile(outputpath, [outputfile 'Train']));
plotContribution(SEM_te, M_te, isprev, leg);
title(['Test, % of Neurons is: ' num2str(n/size(imagingData.samples,3))]);
mysave(gcf, fullfile(outputpath, [outputfile 'Test']));

end

function plotContribution(SEM_t, M_t, isprev, leg)

figure;[bh,eh] = barwitherr(100*SEM_t',100*M_t');
bh.FaceColor  = 'w';eh.Color = 'r';
if isprev
    set(gca,'XTickLabel', leg);
else
    legend( leg);
    xlabel('Segment');
end

ylabel('% Contribution');
end