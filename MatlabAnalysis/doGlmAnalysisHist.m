function doGlmAnalysisHist(BehaveData, timesegments, t, ttraj, foldsNum, INDICES, imagingData, ...
    generalProperty, splinesFuns, eventsNames, eventsTypes, outputpath, outputfile, isprev, energyTh)


if isprev
    BehaveDataPrev.(generalProperty.successLabel).indicatorPerTrial = BehaveData.(generalProperty.successLabel).indicatorPerTrial(1:end-1);
    BehaveDataPrev.traj.data = BehaveData.traj.data(:,:,1:end-1);
    BehaveData = BehaveDataPrev;
    eventsNames = {'traj'};
    eventsTypes = {'kinematics'};
end
if exist(fullfile(outputpath, [outputfile '.mat']), 'file')
    load(fullfile(outputpath, outputfile));
else
    poolobj = parpool;
 
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
            Y_train{fold_i} = imagingData.samples(:, :, train_i == true);
            Y_train{fold_i} = Y_train{fold_i}(:,timeinds,:);
            Y_test{fold_i} = imagingData.samples(:, :, test_i == true);
            Y_test{fold_i} = Y_test{fold_i}(:,timeinds,:);
            [X_train{fold_i}, x_train{fold_i}] = getFilteredBehaveData(generalProperty.successLabel,...
                BehaveData, eventsNames, eventsTypes, splinesFuns, train_i, timeinds, timeinds_traj, generalProperty);
            [X_test{fold_i}, x_test{fold_i}] = getFilteredBehaveData(generalProperty.successLabel, ...
                BehaveData, eventsNames, eventsTypes, splinesFuns, test_i, (timeinds), timeinds_traj, generalProperty);
            
            types = unique(X_train{fold_i}.type);
            
            
            
        end
        
        indexFRunning = 1;
        for nrni = 1:size(imagingData.samples, 1)           
            
            for fold_i = 1:foldsNum
                
                tt = tic;
                disp([time_seg_i/(length(timesegments)-1) nrni/size(imagingData.samples, 1) fold_i/foldsNum]);
                Ytr = squeeze(Y_train{fold_i}(nrni, :, :));
                Yte = squeeze(Y_test{fold_i}(nrni, :, :));
                
                toc(tt);
                F(indexFRunning) = parfeval(@LassoCV, 7, x_train{fold_i}, Ytr(:), foldsNum, x_test{fold_i}, Yte(:), fold_i, nrni, -1);
                indexFRunning = indexFRunning + 1;
%                 [ glmmodelfull{time_seg_i}.x(:, nrni, fold_i ), glmmodelfull{time_seg_i}.x0(nrni, fold_i ), ...
%                     R2full_tr{time_seg_i}(nrni, fold_i ), R2full_te{time_seg_i}(nrni, fold_i)] = LassoCV(x_train{fold_i}, Ytr(:), foldsNum, x_test{fold_i}, Yte(:));
%                 disp(mean(R2full_te{time_seg_i}(nrni, :),2));
            end
        end
        
        for i_f = 1:indexFRunning-1
            [completedIdx,x, x0, R2Tr, R2Te, fold_in, nrni, ~] = fetchNext(F);
            
            glmmodelfull{time_seg_i}.x(:, nrni, fold_in ) = x;
            glmmodelfull{time_seg_i}.x0(nrni,  fold_in ) = x0;
            R2full_tr{time_seg_i}(nrni, fold_in) = R2Tr;
            R2full_te{time_seg_i}(nrni, fold_in) = R2Te;
        end
        
        indexFRunning = 1;
        for nrni = 1:size(imagingData.samples, 1)
        
            if ~(nanmean(R2full_te{time_seg_i}(nrni,:),2)>= energyTh && nanmean(R2full_te{time_seg_i}(nrni,:),2) <= 1)
                for type_i = 1:length(types)
                    R2p_train{time_seg_i}(nrni, type_i, 1:foldsNum) = nan;
                    R2p_test{time_seg_i}(nrni, type_i, 1:foldsNum) = nan;
                end
                continue;
            end

            for fold_i = 1:foldsNum
                f = figure;
                hold on;
                subplot(2,1,1);
                B = glmmodelfull{time_seg_i}.x(:, nrni, fold_i );
                x0 = glmmodelfull{time_seg_i}.x0(nrni, fold_i);
                imagesc(t(timeinds), 1:size(Y_test{fold_i},3), squeeze(Y_test{fold_i}(nrni, :, :))', [-.15,2]);
                title('Data');
                subplot(2,1,2);
                imagesc(t(timeinds), 1:size(Y_test{fold_i},3), reshape(x_test{fold_i}*B + x0, size(squeeze(Y_test{fold_i}(nrni, :, :))))', [-.15,2]);
                xlabel('Time [sec]');axis tight;ylabel('Trials');title('Model');
                mysave(f, fullfile(outputpath, 'ModelPlot', num2str(fold_i), num2str(time_seg_i), num2str(nrni)));
                close(f);
            end
            
            for fold_i = 1:foldsNum
                tt = tic;
                disp([time_seg_i/(length(timesegments)-1) nrni/size(imagingData.samples, 1) fold_i/foldsNum]);
                Ytr = squeeze(Y_train{fold_i}(nrni, :, :));
                Yte = squeeze(Y_test{fold_i}(nrni, :, :));
                
                for type_i = 1:length(types)
                    binds = setdiff(1:size(x_train{fold_i},2), find(X_train{fold_i}.type==types(type_i)));
                    
                    P_F(indexFRunning) = parfeval(@LassoCV, 7, x_train{fold_i}(:, binds), Ytr(:), foldsNum, x_test{fold_i}(:, binds), Yte(:), fold_i, nrni, type_i);
                    indexFRunning = indexFRunning + 1;
%                     [ glmmodelpart{time_seg_i, type_i}.x(:, nrni, fold_i ), glmmodelpart{time_seg_i}.x0(nrni, fold_i,type_i ),
%                      R2p_train{time_seg_i}(nrni, type_i, fold_i), R2p_test{time_seg_i}(nrni, type_i, fold_i)] = ...
%                         LassoCV(x_train{fold_i}(:, binds), Ytr(:), foldsNum, x_test{fold_i}(:, binds), Yte(:));
                end
            end            
        end
        
        for i_f = 1:indexFRunning-1
            [completedIdx,x, x0, R2Tr, R2Te, fold_in, nrni, type_i] = fetchNext(P_F);

            glmmodelpart{time_seg_i,  type_i}.x(:, nrni, fold_in) = x;
            glmmodelpart{time_seg_i}.x0(nrni,  fold_in ,  type_i) = x0;
            R2p_train{time_seg_i}(nrni, type_i, fold_in) = R2Tr;
            R2p_test{time_seg_i}(nrni, type_i, fold_in) = R2Te;
        end
        
        
    end
    save(fullfile(outputpath, outputfile), 'R2p_test','glmmodelpart','glmmodelfull','R2full_te','R2full_tr','timesegments','eventsNames', 'eventsTypes', 'INDICES');

    delete(poolobj)

    if exist('P_F', 'var')
        delete(P_F);
    end

    if exist('F', 'var')
        delete(F);
    end
end

typesU = unique(eventsTypes, 'stable');
% typesU = unique(eventsTypes);
plotGLMResults(typesU, timesegments, energyTh, R2full_te, R2p_test, outputpath, imagingData, generalProperty);

return;
Nrns = size(R2full_te{1},1);
types = size(R2p_test{1},2);
Nsegs = size(timesegments,2);
Rpartial = nan(Nrns,types,Nsegs);
Rfull = nan(Nrns, Nsegs);

Cont = nan(Nrns, types,Nsegs);
for time_seg_i = 1:size(timesegments,2)
    Rfull(:,time_seg_i) = nanmean(R2full_te{time_seg_i},2);
    inds = find(Rfull(:,time_seg_i)>energyTh);
    if isempty(inds)
        continue;
    end
    N(time_seg_i) = length(inds);
    Rpartial(inds,:, time_seg_i) = nanmean( R2p_test{time_seg_i}(inds,:,:),3);
    for type_i = 1:size(Rpartial, 2)
        Cont(inds, type_i, time_seg_i) = Rpartial(inds,type_i, time_seg_i)./ Rfull(inds,time_seg_i);
    end
    Cont(inds, :, time_seg_i)=bsxfun(@rdivide, Cont(inds, :, time_seg_i), nansum(Cont(inds, :, time_seg_i),2));
end
figure;
bar(N);xlabel('Time Segment');
ylabel('# Neurons');
title(['Modeled Neurons by Full out of ' num2str(Nrns)]);
mysave(gcf, fullfile(outputpath, 'N_neurons_per_segment'));

leg=[];
for ni = 1:length(eventsNames)
    if isempty(ismember(leg, eventsTypes{ni})) || all(ismember(leg, eventsTypes{ni})==0)
    leg{end+1}= eventsTypes{ni};
    end
end
    
figure;
M = squeeze(nanmean(Cont,1))';
S = squeeze(nanstd(Cont))';
SEM = bsxfun(@rdivide, S, sqrt(N(:)));
barwitherr(SEM, M);
legend(leg);
xlabel('Time Segment');
ylabel('Relativ Contribution (Fraction)');
title('Relativ Contribution (Fraction) of each componenet');
mysave(gcf, fullfile(outputpath, 'Relative_Contribution'));
% % this is just a patch - adding more analysis (tone..)
% resfilecont = fullfile(outputpath, [outputfile 'cont']);
%
% if ~exist(resfilecont,'file')
%     for time_seg_i = 1:size(timesegments,2)
%
%         timeinds = find(t >= timesegments(1,time_seg_i) & t <= timesegments(2,time_seg_i));
%         timeinds_traj = find(ttraj >= timesegments(1,time_seg_i) & ttraj <= timesegments(2, time_seg_i));
%         for fold_i = 1:foldsNum
%             test_i = INDICES == fold_i;
%             train_i = ~test_i;
%             if isprev
%                 test_i = test_i(2:end);
%                 train_i = train_i(2:end);
%             end
%             Y_train{fold_i} = imagingData.samples(:, :, train_i == true);
%             Y_train{fold_i} = Y_train{fold_i}(:,timeinds,:);
%             Y_test{fold_i} = imagingData.samples(:, :, test_i == true);
%             Y_test{fold_i} = Y_test{fold_i}(:,timeinds,:);
%             [X_train{fold_i}, x_train{fold_i}] = getFilteredBehaveData(generalProperty.successLabel,...
%                 BehaveData, eventsNames, [eventsTypes, 'reward'], splinesFuns, train_i, timeinds, timeinds_traj, generalProperty);
%             [X_test{fold_i}, x_test{fold_i}] = getFilteredBehaveData(generalProperty.successLabel, ...
%                 BehaveData, eventsNames, [eventsTypes, 'reward'], splinesFuns, test_i, (timeinds), timeinds_traj, generalProperty);
%             newtypesTr = zeros(size(X_train{fold_i}.type));
%             newtypesTr(startsWith(X_train{fold_i}.name,'tone')) = 1;
%             newtypesTr(startsWith(X_train{fold_i}.name,'lift')) = 2;
%             newtypesTr(startsWith(X_train{fold_i}.name,'grab')) = 3;
%             newtypesTr(startsWith(X_train{fold_i}.name,'traj')) = 4;
%             newtypesTr(startsWith(X_train{fold_i}.name,'atmouth')) = 5;
%             newtypesTr(startsWith(X_train{fold_i}.name,'success')) = 6;
%
%             newtypesTe = zeros(size(X_train{fold_i}.type));
%             newtypesTe(startsWith(X_test{fold_i}.name,'tone')) = 1;
%             newtypesTe(startsWith(X_test{fold_i}.name,'lift')) = 2;
%             newtypesTe(startsWith(X_test{fold_i}.name,'grab')) = 3;
%             newtypesTe(startsWith(X_test{fold_i}.name,'traj')) = 4;
%             newtypesTe(startsWith(X_test{fold_i}.name,'atmouth')) = 5;
%             newtypesTe(startsWith(X_test{fold_i}.name,'success')) = 6;
%             legC = {'tone','lift','grab','traj','atmouth','succes'};
%
%             X_train{fold_i}.type = newtypesTr;
%             X_test{fold_i}.type = newtypesTe;
%             types = unique(X_train{fold_i}.type);
%         end
%
%         inds = find(nanmean(R2full_te{time_seg_i},2)<=.9);
%         for nrni = 1:size(imagingData.samples, 1)
%             if ~ismember(inds, nrni)
%                 continue;
%             end
%
%             for fold_i = 1:foldsNum
%
%                 tt = tic;
%                 disp([time_seg_i/(length(timesegments)-1) nrni/size(imagingData.samples, 1) fold_i/foldsNum]);
%                 Ytr = squeeze(Y_train{fold_i}(nrni, :, :));
%                 Yte = squeeze(Y_test{fold_i}(nrni, :, :));
%                 for type_i = 1:length(types)
%                     binds = setdiff(1:size(x_train{fold_i},2), find(X_train{fold_i}.type==types(type_i)));
%                     [ glmmodelpart{time_seg_i, type_i}.x(:, nrni, fold_i ), glmmodelpart{time_seg_i}.x0(nrni, fold_i,type_i ), R2p_train{time_seg_i}(nrni, type_i, fold_i), R2p_test{time_seg_i}(nrni, type_i, fold_i)] = ...
%                         LassoCV(x_train{fold_i}(:, binds), Ytr(:), foldsNum, x_test{fold_i}(:, binds), Yte(:));
%                 end
%                 toc(tt);
% %                 %                 [ glmmodelfull{time_seg_i}.x(:, nrni, fold_i ), glmmodelfull{time_seg_i}.x0(nrni, fold_i ), R2full_tr{time_seg_i}(nrni, fold_i ), R2full_te{time_seg_i}(nrni, fold_i)] = LassoCV(x_train{fold_i}, Ytr(:), foldsNum, x_test{fold_i}, Yte(:));
% %                 disp(mean(R2full_te{time_seg_i}(nrni, :),2));
% %                 Rnorm_trNew{time_seg_i}(nrni, :, fold_i) = R2p_trainNew{time_seg_i}(nrni, :, fold_i)/R2full_tr{time_seg_i}(nrni, fold_i);
% %                 contribution_trNew{time_seg_i}(nrni, :, fold_i) = (1-Rnorm_trNew{time_seg_i}(nrni,:, fold_i))/sum(1-Rnorm_trNew{time_seg_i}(nrni,:, fold_i));
% %                 Rnorm_teNew{time_seg_i}(nrni, :, fold_i) = R2p_testNew{time_seg_i}(nrni, :, fold_i)/R2full_te{time_seg_i}(nrni, fold_i );
% %                 contribution_teNew{time_seg_i}(nrni, :, fold_i) = (1-Rnorm_teNew{time_seg_i}(nrni,:, fold_i))/sum(1-Rnorm_teNew{time_seg_i}(nrni,:, fold_i));
% %
%             end
%         end
%
%     end
%     leg=legin;
%     close all;
%     save( resfilecont, 'R2p_test','glmmodelpart','glmmodelfull',,'R2full_tr','R2full_te','timesegments','legC', 'INDICES');
% end

% return;
% for time_seg_i = 1:size(timesegments,2)
%     inds = find(nanmean(R2full_te{time_seg_i},2)<=energyth);
%     N_te(time_seg_i) = length(inds);
%     M_tr(:,time_seg_i) = nanmean(nanmean(contribution_tr{time_seg_i}(inds, :, :),3),1);
%     S_tr(:,time_seg_i) = nanstd(nanmean(contribution_tr{time_seg_i}(inds, :, :),3),[],1);
%     n(time_seg_i) = size(contribution_tr{time_seg_i}(inds, :, :),1);
%     SEM_tr(:,time_seg_i) = S_tr(:,time_seg_i)/sqrt(n(time_seg_i));
%     M_te(:,time_seg_i) = nanmean(nanmean(contribution_te{time_seg_i}(inds, :, :),3),1);
%     S_te(:,time_seg_i) = nanstd(nanmean(contribution_te{time_seg_i}(inds, :, :),3),[],1);
%     n(time_seg_i) = size(contribution_te{time_seg_i}(inds, :, :),1);
%     SEM_te(:,time_seg_i) = S_te(:,time_seg_i)/sqrt(n(time_seg_i));
% end
% plotContribution(SEM_tr, M_tr, isprev, legC);
% title(['Train, % of Neurons is: ' num2str(n/size(imagingData.samples,1))]);
% mysave(gcf, fullfile(outputpath, [outputfile 'Train']));
% plotContribution(SEM_te, M_te, isprev, legC);
% title(['Test, % of Neurons is: ' num2str(n) '/' num2str(size(imagingData.samples,1))]);
% mysave(gcf, fullfile(outputpath, [outputfile 'Test']));
% bins = linspace(0,1.1,50);


% for time_seg_i = 1:size(timesegments, 2)
%      timeinds = find(t >= timesegments(1,time_seg_i) & t <= timesegments(2,time_seg_i));
%      timeinds_traj = find(ttraj >= timesegments(1,time_seg_i) & ttraj <= timesegments(2, time_seg_i));
%          fold_i = 1;
%             test_i = INDICES == fold_i;
%             train_i = ~test_i;
%
%             Y_test{fold_i} = imagingData.samples(:, :, test_i == true);
%             Y_test{fold_i} = Y_test{fold_i}(:,timeinds,:);
%                 [X_test{fold_i}, x_test{fold_i}] = getFilteredBehaveData(generalProperty.successLabel, ...
%                 BehaveData, eventsNames, [eventsTypes, 'reward'], splinesFuns, test_i, (timeinds), timeinds_traj, generalProperty);
%             [~, inds] = sort(nanmean(R2full_te{time_seg_i},2),'ascend');
%             figure;
%     nrni=inds(1);
%     subplot(4,3,1);
%             B = glmmodelfull{time_seg_i}.x(:, nrni, fold_i );
%             x0 = glmmodelfull{time_seg_i}.x0(nrni, fold_i);
%             imagesc(t(timeinds), 1:size(Y_test{fold_i},3), squeeze(Y_test{fold_i}(nrni, :, :))', [-.15,2]);
%             title('Data');
%             subplot(4,3,4);
%             imagesc(t(timeinds), 1:size(Y_test{fold_i},3), reshape(x_test{fold_i}*B + x0, size(squeeze(Y_test{fold_i}(nrni, :, :))))', [-.15,2]);
%             xlabel('Time [sec]');axis tight;ylabel('Trials');title('Model');
%             nrni=inds(2);
%     subplot(4,3,2);
%             B = glmmodelfull{time_seg_i}.x(:, nrni, fold_i );
%             x0 = glmmodelfull{time_seg_i}.x0(nrni, fold_i);
%             imagesc(t(timeinds), 1:size(Y_test{fold_i},3), squeeze(Y_test{fold_i}(nrni, :, :))', [-.15,2]);
%             title('Data');
%             subplot(4,3,5);
%             imagesc(t(timeinds), 1:size(Y_test{fold_i},3), reshape(x_test{fold_i}*B + x0, size(squeeze(Y_test{fold_i}(nrni, :, :))))', [-.15,2]);
%             xlabel('Time [sec]');axis tight;ylabel('Trials');title('Model');
%            nrni=inds(3);
%     subplot(4,3,3);
%             B = glmmodelfull{time_seg_i}.x(:, nrni, fold_i );
%             x0 = glmmodelfull{time_seg_i}.x0(nrni, fold_i);
%             imagesc(t(timeinds), 1:size(Y_test{fold_i},3), squeeze(Y_test{fold_i}(nrni, :, :))', [-.15,2]);
%             title('Data');
%             subplot(4,3,6);
%             imagesc(t(timeinds), 1:size(Y_test{fold_i},3), reshape(x_test{fold_i}*B + x0, size(squeeze(Y_test{fold_i}(nrni, :, :))))', [-.15,2]);
%             xlabel('Time [sec]');axis tight;ylabel('Trials');title('Model');
%
%             nrni=inds(end);
%     subplot(4,3,7);
%             B = glmmodelfull{time_seg_i}.x(:, nrni, fold_i );
%             x0 = glmmodelfull{time_seg_i}.x0(nrni, fold_i);
%             imagesc(t(timeinds), 1:size(Y_test{fold_i},3), squeeze(Y_test{fold_i}(nrni, :, :))', [-.15,2]);
%             title('Data');
%             subplot(4,3,10);
%             imagesc(t(timeinds), 1:size(Y_test{fold_i},3), reshape(x_test{fold_i}*B + x0, size(squeeze(Y_test{fold_i}(nrni, :, :))))', [-.15,2]);
%             xlabel('Time [sec]');axis tight;ylabel('Trials');title('Model');
%            nrni=inds(end-1);
%     subplot(4,3,8);
%             B = glmmodelfull{time_seg_i}.x(:, nrni, fold_i );
%             x0 = glmmodelfull{time_seg_i}.x0(nrni, fold_i);
%             imagesc(t(timeinds), 1:size(Y_test{fold_i},3), squeeze(Y_test{fold_i}(nrni, :, :))', [-.15,2]);
%             title('Data');
%             subplot(4,3,11);
%             imagesc(t(timeinds), 1:size(Y_test{fold_i},3), reshape(x_test{fold_i}*B + x0, size(squeeze(Y_test{fold_i}(nrni, :, :))))', [-.15,2]);
%             xlabel('Time [sec]');axis tight;ylabel('Trials');title('Model');
%            nrni=inds(end-2);
%     subplot(4,3,9);
%             B = glmmodelfull{time_seg_i}.x(:, nrni, fold_i );
%             x0 = glmmodelfull{time_seg_i}.x0(nrni, fold_i);
%             imagesc(t(timeinds), 1:size(Y_test{fold_i},3), squeeze(Y_test{fold_i}(nrni, :, :))', [-.15,2]);
%             title('Data');
%             subplot(4,3,12);
%             imagesc(t(timeinds), 1:size(Y_test{fold_i},3), reshape(x_test{fold_i}*B + x0, size(squeeze(Y_test{fold_i}(nrni, :, :))))', [-.15,2]);
%             xlabel('Time [sec]');axis tight;ylabel('Trials');title('Model');
%            suptitle(['Best And Worst Modeling Segment ' num2str(time_seg_i)]);
%             mysave(gcf, fullfile(outputpath, [outputfile 'BestWorstModeling' num2str(time_seg_i)]));
%
% end
