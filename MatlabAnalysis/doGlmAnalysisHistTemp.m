function doGlmAnalysisHistTemp(BehaveData, timesegments, t, ttraj, foldsNum, INDICES, imagingData, ...
    generalProperty, splinesFuns, eventsNames, eventsTypes, outputpath, outputfile, isprev, energyTh)

if isprev
    BehaveDataPrev.(generalProperty.successLabel).indicatorPerTrial = BehaveData.(generalProperty.successLabel).indicatorPerTrial(1:end-1);
    BehaveDataPrev.traj.data = BehaveData.traj.data(:,:,1:end-1);
    BehaveData = BehaveDataPrev;
    eventsNames = {'traj'};
    eventsTypes = {'kinematics'};
end
if exist(fullfile(outputpath, [outputfile '.mat']), 'file')
    load(fullfile(outputpath, outputfile), 'R2p_test','R2full_te','timesegments','eventsTypes',  'generalProperty');
else
    poolobj = parpool;
    
    LassoFunction = @LassoCVGLM;
    
    distribution = 'inverse gaussian';
    linkFunction = -2;
    
    %     distribution = 'normal';
    %     linkFunction = 'identity';
    
    glmmodelpart = {};
    
    Nsegments = size(timesegments,2);
    Nnrns = size(imagingData.samples, 1);
    
    R2full_tr = cell(Nsegments, 1);
    R2full_te = cell(Nsegments, 1);
    R2p_train = cell(Nsegments,1);
    R2p_test = cell(Nsegments,1);
    for time_seg_i = 1:Nsegments
        
        timeinds = find(t >= timesegments(1,time_seg_i) & t <= timesegments(2,time_seg_i));
        timeinds_traj = find(ttraj >= timesegments(1,time_seg_i) & ttraj <= timesegments(2, time_seg_i));
        Y_train = cell(foldsNum, 1);X_train = cell(foldsNum, 1);x_train = cell(foldsNum, 1);
        Y_test = cell(foldsNum, 1);X_test = cell(foldsNum, 1);x_test = cell(foldsNum, 1);
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
            
            [X_train{fold_i}, x_train{fold_i}] = getFilteredBehaveData('success',...
                BehaveData, eventsNames, eventsTypes, splinesFuns, train_i, timeinds, timeinds_traj, generalProperty);
            [X_test{fold_i}, x_test{fold_i}] = getFilteredBehaveData('success', ...
                BehaveData, eventsNames, eventsTypes, splinesFuns, test_i, (timeinds), timeinds_traj, generalProperty);
            
            types = unique(X_train{fold_i}.type);
        end
        R2full_tr{time_seg_i} = nan(Nnrns, foldsNum);
        R2full_te{time_seg_i} = nan(Nnrns, foldsNum);
        
        lam = nan(length(Nnrns), 1);
            
        for fold_i = 1:foldsNum
            indexFRunning = 1;
                
            for nrni = 1:Nnrns
                tt = tic;
                disp([time_seg_i/(length(timesegments)-1) nrni/Nnrns fold_i/foldsNum]);
                Ytr = squeeze(Y_train{fold_i}(nrni, :, :));
                Yte = squeeze(Y_test{fold_i}(nrni, :, :));
                
                F(indexFRunning) = parfeval(LassoFunction, 8, x_train{fold_i}, Ytr(:), foldsNum, x_test{fold_i}, Yte(:), fold_i, nrni, -1, distribution, linkFunction, lam(nrni));
                indexFRunning = indexFRunning + 1;
                    
                toc(tt);
            end
            
            for i_f = 1:indexFRunning-1
                [completedIdx, x_c, x0_c, R2Tr_c, R2Te_c, fold_in, cur_nrni, ~, curLam] = fetchNext(F);
                lam(cur_nrni) = curLam;
            
                glmmodelfull{time_seg_i}.x(:, cur_nrni, fold_in ) = x_c; %#ok<AGROW>
                glmmodelfull{time_seg_i}.x0(cur_nrni,  fold_in ) = x0_c; %#ok<AGROW>
                R2full_tr{time_seg_i}(cur_nrni, fold_in) = R2Tr_c;
                
                if R2Te_c > 1
                    R2Te_c = 0;
                end
                
                R2full_te{time_seg_i}(cur_nrni, fold_in) = R2Te_c;
            end
             
            cancel(F);
            delete(F);
        end
        
        R2p_train{time_seg_i} = nan(Nnrns, length(types), foldsNum);
        R2p_test{time_seg_i} = nan(Nnrns, length(types), foldsNum);
        for nrni = 1:Nnrns
            if ~(nanmean(R2full_te{time_seg_i}(nrni,:),2)>= energyTh && nanmean(R2full_te{time_seg_i}(nrni,:),2) <= 1)
                continue;
            end
            filename1 = fullfile(outputpath, 'ModelPlot', [ num2str(time_seg_i) '_' num2str(nrni)]);
            filename2 = fullfile(outputpath, 'ModelPlotTrace', [ num2str(time_seg_i) '_' num2str(nrni)]);
            plot_glm_data_and_model(Y_train, Y_test, x_test, t(timeinds), ...
                glmmodelfull{time_seg_i}, nrni, foldsNum, filename1, filename2, linkFunction);
            lam = nan(length(types), 1);
            for fold_i = 1:foldsNum
                
                disp([time_seg_i/(length(timesegments)-1) nrni/Nnrns fold_i/foldsNum]);
                Ytr = squeeze(Y_train{fold_i}(nrni, :, :));
                Yte = squeeze(Y_test{fold_i}(nrni, :, :));
                
                indexFRunning = 1;
                
                for type_i = 1:length(types)
                    binds = setdiff(1:size(x_train{fold_i},2), find(X_train{fold_i}.type==types(type_i)));
                    tic;
                    
                    F(indexFRunning) = parfeval(LassoFunction, 8, x_train{fold_i}(:, binds), Ytr(:), foldsNum, x_test{fold_i}(:, binds), Yte(:), fold_i, nrni, type_i, distribution, linkFunction, lam(type_i));
                    indexFRunning = indexFRunning + 1;
                    toc;
                end
                
                for i_f = 1:indexFRunning-1
                    [completedIdx, x_c, x0_c, R2Tr_cur, R2Te_cur, fold_in_c, cur_nrni, type_in, curLam] = fetchNext(F);
                    lam(type_in) = curLam;
                    
                    glmmodelpart{time_seg_i,  type_in}.x(:, cur_nrni, fold_in_c) = x_c; %#ok<AGROW>
                    glmmodelpart{time_seg_i}.x0(cur_nrni,  fold_in_c ,  type_in) = x0_c;%#ok<AGROW>
                    R2p_train{time_seg_i}(cur_nrni, type_in, fold_in_c) = R2Tr_cur;
                    
                    if R2Te_cur > 1
                        R2Te_cur = 0;
                    end
                    
                    R2p_test{time_seg_i}(cur_nrni, type_in, fold_in_c) = R2Te_cur;
                end
                
                cancel(F);
                delete(F);
            end
        end
    end
    save(fullfile(outputpath, outputfile), 'R2p_test','glmmodelpart','glmmodelfull','R2full_te','R2full_tr','timesegments','eventsNames', 'eventsTypes', 'INDICES', 'generalProperty');
end

typesU = unique(eventsTypes, 'stable');
plotGLMResults(typesU, timesegments, energyTh, R2full_te, R2p_test, outputpath, imagingData, generalProperty);

delete(poolobj)

return;