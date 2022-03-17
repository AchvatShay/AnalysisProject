function plot_glm_data_and_model(Y_train, Y_test, x_test, t, glmmodelfull, nrni, ...
    foldsNum, filename1in, filename2in, linkFunction)

for fold_i = 1:foldsNum
    [p, n] = fileparts(filename1in);
    filename1 = fullfile(p, [num2str(fold_i) '_' n]);
    [p, n] = fileparts(filename2in);
    filename2 = fullfile(p, [num2str(fold_i) '_' n]);
           
            
    f = figure;
    hold on;
    subplot(2,1,1);
    minY = min(min(Y_train{fold_i}(nrni,:,:)));
    x = glmmodelfull.x(:, nrni, fold_i );
    x0 = glmmodelfull.x0(nrni, fold_i);
    yht = predictGLM(x, x0, x_test{fold_i}, minY, linkFunction);
    
    imagesc(t, 1:size(Y_test{fold_i},3), squeeze(Y_test{fold_i}(nrni, :, :))', [-.15,2]);
    title('Data');
    subplot(2,1,2);
    imagesc(t, 1:size(Y_test{fold_i},3), reshape(yht, size(squeeze(Y_test{fold_i}(nrni, :, :))))', [-.15,2]);
    xlabel('Time [sec]');axis tight;ylabel('Trials');title('Model');
    mysave(f, filename1);
    close(f);
    
    f = figure;
    hold on;
    
    for in = 1:size(Y_test{fold_i}, 3)
        subplot(size(Y_test{fold_i}, 3),1,in);
        hold on;
        minY = min(min(Y_train{fold_i}(nrni,:,:)));
        x = glmmodelfull.x(:, nrni, fold_i );
        x0 = glmmodelfull.x0(nrni, fold_i);
        yht = predictGLM(x, x0, x_test{fold_i}, minY, linkFunction);
        
        plot(squeeze(Y_test{fold_i}(nrni, :, in))', 'k');
        testR = reshape(yht, size(squeeze(Y_test{fold_i}(nrni, :, :))))';
        plot(testR(in, :), 'r');
    end
    mysave(f, filename2);
    close(f);
end