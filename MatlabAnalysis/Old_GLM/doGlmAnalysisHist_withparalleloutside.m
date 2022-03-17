        function doGlmAnalysisHist_withparalleloutside(BehaveData, timesegments, t, ttraj, foldsNum, INDICES, imagingData, ...
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
    LassoFunction = @LassoCVGLM;
    
    distribution = 'gamma';
    linkFunction = 'reciprocal';
    
    distribution = 'normal';
    linkFunction = 'identity';
    
    poolobj = parpool;
    glmmodelpart = {};
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
                
                F(indexFRunning) = parfeval(LassoFunction, 7, x_train{fold_i}, Ytr(:), foldsNum, x_test{fold_i}, Yte(:), fold_i, nrni, -1, distribution, linkFunction);
                indexFRunning = indexFRunning + 1;
            end
        end
        
        for i_f = 1:indexFRunning-1
            [completedIdx,x, x0, R2Tr, R2Te, fold_in, nrni, ~] = fetchNext(F);
            
            glmmodelfull{time_seg_i}.x(:, nrni, fold_in ) = x;
            glmmodelfull{time_seg_i}.x0(nrni,  fold_in ) = x0;
            R2full_tr{time_seg_i}(nrni, fold_in) = R2Tr;
            
            if R2Te > 1
                R2Te = 0;
            end
            
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
                yht = glmval([x0;B], x_test{fold_i}, linkFunction);
                imagesc(t(timeinds), 1:size(Y_test{fold_i},3), squeeze(Y_test{fold_i}(nrni, :, :))', [-.15,2]);
                title('Data');
                subplot(2,1,2);
                imagesc(t(timeinds), 1:size(Y_test{fold_i},3), reshape(yht, size(squeeze(Y_test{fold_i}(nrni, :, :))))', [-.15,2]);
                xlabel('Time [sec]');axis tight;ylabel('Trials');title('Model');
                mysave(f, fullfile(outputpath, 'ModelPlot', [num2str(fold_i) '_' num2str(time_seg_i) '_' num2str(nrni)]));
                close(f);
                
                f = figure;
                hold on;
                
                for in = 1:size(Y_test{fold_i}, 3)
                    subplot(size(Y_test{fold_i}, 3),1,in);
                    hold on;
                    B = glmmodelfull{time_seg_i}.x(:, nrni, fold_i );
                    x0 = glmmodelfull{time_seg_i}.x0(nrni, fold_i);
                    yht = glmval([x0;B], x_test{fold_i}, linkFunction);
                    plot(squeeze(Y_test{fold_i}(nrni, :, in))', 'k');   
                    testR = reshape(yht, size(squeeze(Y_test{fold_i}(nrni, :, :))))';
                    plot(testR(in, :), 'r');
                end
                
                mysave(f, fullfile(outputpath, 'ModelPlotTrace', [num2str(fold_i) '_' num2str(time_seg_i) '_' num2str(nrni)]));
                close(f);
                
            end
            
            indexFRunning = 1;
            
            for fold_i = 1:foldsNum
                tt = tic;
                disp([time_seg_i/(length(timesegments)-1) nrni/size(imagingData.samples, 1) fold_i/foldsNum]);
                Ytr = squeeze(Y_train{fold_i}(nrni, :, :));
                Yte = squeeze(Y_test{fold_i}(nrni, :, :));
                
                for type_i = 1:length(types)
                    binds = setdiff(1:size(x_train{fold_i},2), find(X_train{fold_i}.type==types(type_i)));
                    
                    P_F(indexFRunning) = parfeval(LassoFunction, 7, x_train{fold_i}(:, binds), Ytr(:), foldsNum, x_test{fold_i}(:, binds), Yte(:), fold_i, nrni, type_i, distribution, linkFunction);
                    indexFRunning = indexFRunning + 1;
                end
            end
            
            for i_f = 1:indexFRunning-1
                [completedIdx,x_c, x0_c, R2Tr_cur, R2Te_cur, fold_in_c, cur_nrni, type_in] = fetchNext(P_F);

                glmmodelpart{time_seg_i,  type_in}.x(:, cur_nrni, fold_in_c) = x_c;
                glmmodelpart{time_seg_i}.x0(cur_nrni,  fold_in_c ,  type_in) = x0_c;
                R2p_train{time_seg_i}(cur_nrni, type_in, fold_in_c) = R2Tr_cur;

                if R2Te_cur > 1
                    R2Te_cur = 0;
                end

                R2p_test{time_seg_i}(cur_nrni, type_in, fold_in_c) = R2Te_cur;
            end
            
            cancel(P_F);
            delete(P_F);
            clear('P_F');
        end      
    end
    save(fullfile(outputpath, outputfile), 'R2p_test','glmmodelpart','glmmodelfull','R2full_te','R2full_tr','timesegments','eventsNames', 'eventsTypes', 'INDICES', 'generalProperty');

    if exist('P_F', 'var')
        cancel(P_F);
        delete(P_F);
        clear('P_F');
    end

    if exist('F', 'var')
         cancel(F);
        delete(F);
    end
    
    delete(poolobj)

end

typesU = unique(eventsTypes, 'stable');
plotGLMResults(typesU, timesegments, energyTh, R2full_te, R2p_test, outputpath, imagingData, generalProperty);

return;