function f=loadAndPlotGLM(filename,legendStr,pthM,pthP,energyth,fieldname)
layer23.R2p_test{1}=[];layer23.R2p_test{2}=[];layer23.R2p_test{3}=[];
layer23.R2full_te{1}=[];layer23.R2full_te{2}=[];layer23.R2full_te{3}=[];
layer5.R2p_test{1}=[];layer5.R2p_test{2}=[];layer5.R2p_test{3}=[];
layer5.R2full_te{1}=[];layer5.R2full_te{2}=[];layer5.R2full_te{3}=[];


for m=1:length(pthM)
    if ~exist(fullfile(pthM{m},filename), 'file')
        warning(['File: ' fullfile(pthM{m},filename) ' does not exist']);
        continue;
    end
    M = load(fullfile(pthM{m},filename));
    disp(pthM{m});
    disp(size(M.R2full_tr{1},1));
    for time_seg_i=1:length(M.R2full_te)
        layer23.R2full_te{time_seg_i} = cat(1, layer23.R2full_te{time_seg_i}, M.R2full_te{time_seg_i});
        newMat = nan(size(M.R2full_te{time_seg_i},1), length(legendStr), size(M.R2full_te{time_seg_i},2));
        inds = find(nanmean(M.R2full_te{time_seg_i},2)>=energyth);
        disp(length(inds));
        newMat(inds, :, :) = M.R2p_test{time_seg_i}(inds, :, :);
        layer23.R2p_test{time_seg_i} = cat(1, layer23.R2p_test{time_seg_i}, newMat);
        
    end
end
for m=1:length(pthP)
    if ~exist(fullfile(pthP{m},filename), 'file')
        warning(['File: ' fullfile(pthP{m},filename) ' does not exist']);
        continue;
    end
    M = load(fullfile(pthP{m},filename));
    disp(pthP{m});
    disp(size(M.R2full_tr{1},1));
    for time_seg_i=1:length(M.R2full_te)
        layer5.R2full_te{time_seg_i} = cat(1, layer5.R2full_te{time_seg_i}, M.R2full_te{time_seg_i});
        newMat = nan(size(M.R2full_te{time_seg_i},1), length(legendStr), size(M.R2full_te{time_seg_i},2));
        inds = find(nanmean(M.R2full_te{time_seg_i},2)>=energyth);
        newMat(inds, :, :) = M.R2p_test{time_seg_i}(inds, :, :);
        layer5.R2p_test{time_seg_i} = cat(1, layer5.R2p_test{time_seg_i}, newMat);
         disp(length(inds));
    end
end
legendStr = unique(M.eventsTypes);



for time_seg_i=1:2
    if time_seg_i == 1
        typppes = 1:length(legendStr);
        typppeston=[];
    else
        typppes = find(~strcmp(legendStr, 'tone'));
        typppeston = find(strcmp(legendStr, 'tone'));
    end
    for nrni = 1:size(layer5.R2p_test{time_seg_i},1)
        for fold_i = 1:5
            layer5.Rnorm_te{time_seg_i}(nrni, :, fold_i) = layer5.R2p_test{time_seg_i}(nrni, :, fold_i)/layer5.R2full_te{time_seg_i}(nrni, fold_i );
        end
        
        vals = layer5.Rnorm_te{time_seg_i}(nrni, :, :);
        vals(vals>1)=nan;
        vals = 1-nanmean(vals,3);
        vals(typppeston)=0;
%         layer5.contribution_te{time_seg_i}(nrni, :, fold_i) = vals/sum(vals);
        layer5.contribution_te{time_seg_i}(nrni, :) = vals/sum(vals);
    end
    for nrni = 1:size(layer23.R2p_test{time_seg_i},1)
        for fold_i = 1:5
            layer23.Rnorm_te{time_seg_i}(nrni, :, fold_i) = layer23.R2p_test{time_seg_i}(nrni, :, fold_i)/layer23.R2full_te{time_seg_i}(nrni, fold_i );
        end
        vals = layer23.Rnorm_te{time_seg_i}(nrni, :, :);
        vals(vals>1)=nan;
        vals = 1-nanmean(vals,3);
        vals(typppeston)=0;
%         layer5.contribution_te{time_seg_i}(nrni, :, fold_i) = vals/sum(vals);
        layer23.contribution_te{time_seg_i}(nrni, :) = vals/sum(vals);
    end
%     for nrni = 1:size(layer23.R2p_test{time_seg_i},1)
%         for fold_i = 1:5
%             
%             layer23.Rnorm_te{time_seg_i}(nrni, typppes, fold_i) = layer23.R2p_test{time_seg_i}(nrni, typppes, fold_i)/layer23.R2full_te{time_seg_i}(nrni, fold_i );
%             vals = max(1-layer23.Rnorm_te{time_seg_i}(nrni,typppes, fold_i), 0);
%             
%             %             layer23.contribution_te{time_seg_i}(nrni, :, fold_i) = (1-layer23.Rnorm_te{time_seg_i}(nrni,:, fold_i))/sum(1-layer23.Rnorm_te{time_seg_i}(nrni,:, fold_i));
%             vals(typppeston)=0;
%             layer23.contribution_te{time_seg_i}(nrni, typppes, fold_i) = vals/sum(vals);
%             
%             
%             
%         end
%     end
end
for time_seg_i = 1:2%:size(timesegments,2)
    inds = find(nanmean(layer5.R2full_te{time_seg_i},2)>=energyth);
    
    layer5.N_te(time_seg_i) = length(inds);
    if ~isempty(inds)
        layer5.M_te(:,time_seg_i) = nanmean(nanmean(layer5.contribution_te{time_seg_i}(inds, :, :),3),1);
        layer5.S_te(:,time_seg_i) = nanstd(nanmean(layer5.contribution_te{time_seg_i}(inds, :, :),3),[],1);
        layer5.n(time_seg_i) = size(layer5.contribution_te{time_seg_i}(inds, :, :),1);
        layer5.SEM_te(:,time_seg_i) = layer5.S_te(:,time_seg_i)/sqrt(layer5.n(time_seg_i));
    end
    inds = find(nanmean(layer23.R2full_te{time_seg_i},2)>=energyth);
    %     [h2,pval2] = ttest(squeeze(layer23.R2full_te{time_seg_i}).', energyth, 'tail','left', 'alpha', .1);
    % inds = find(h2==1);
    
    layer23.N_te(time_seg_i) = length(inds);
    if ~isempty(inds)
        layer23.M_te(:,time_seg_i) = nanmean(nanmean(layer23.contribution_te{time_seg_i}(inds, :, :),3),1);
        layer23.S_te(:,time_seg_i) = nanstd(nanmean(layer23.contribution_te{time_seg_i}(inds, :, :),3),[],1);
        layer23.n(time_seg_i) = size(layer23.contribution_te{time_seg_i}(inds, :, :),1);
        layer23.SEM_te(:,time_seg_i) = layer23.S_te(:,time_seg_i)/sqrt(layer23.n(time_seg_i));
    end
end
% legendStr = {'tone', 'lift','grab','traj','atmouth','outcome'};
f=figure;
for time_seg_i=1:2
    subplot(2,2,time_seg_i)
    if layer23.N_te(time_seg_i) > 0 & layer5.N_te(time_seg_i)
        barwitherr([layer23.SEM_te(:,time_seg_i) layer5.SEM_te(:,time_seg_i)],[layer23.M_te(:,time_seg_i) layer5.M_te(:,time_seg_i)]);
        legend('Layer 2/3', 'Layer 5','Location','NorthWest');
        title(['Time segment #' num2str(time_seg_i) ' layer2/3: n = ' num2str(layer23.n(time_seg_i)) ' layer 5: ' num2str(layer5.n(time_seg_i))]);
        
    elseif layer23.N_te(time_seg_i) > 0
        barwitherr([ layer23.SEM_te(:,time_seg_i)],[ layer23.M_te(:,time_seg_i)]);
        title(['Time segment #' num2str(time_seg_i) ' layer2/3: n = ' num2str(layer23.n(time_seg_i)) ]);
        %         legend('Layer 2/3', 'Location','NorthWest');
        
    elseif layer5.N_te(time_seg_i)> 0
        barwitherr([layer5.SEM_te(:,time_seg_i) ],[layer5.M_te(:,time_seg_i) ]);
        %         legend('Layer 5', 'Location','NorthWest');
        title(['Time segment #' num2str(time_seg_i) ' layer5: n = ' num2str(layer5.n(time_seg_i)) ]);
    end
    %
    
    set(gca, 'XTickLabel',legendStr);
end
subplot(2,2,4);
if any(layer23.N_te) > 0 & any(layer5.N_te)
    bar([ layer23.N_te/size(layer23.R2full_te{1},1);layer5.N_te/size(layer5.R2full_te{1},1)]');
    title(['Overall # Neurons Layer 2/3: ' num2str(size(layer23.R2full_te{1},1)) 'Layer 5: ' num2str(size(layer5.R2full_te{1},1))]);
elseif any(layer23.N_te) > 0
    bar(layer23.N_te/size(layer23.R2full_te{1},1));
    title(['Overall # Neurons: ' num2str(size(layer23.R2full_te{1},1))]);
    
elseif any(layer5.N_te) > 0
    bar(layer5.N_te/size(layer5.R2full_te{1},1));
    title(['Overall # Neurons: ' num2str(size(layer5.R2full_te{1},1))]);
end
xlabel('Segment');
ylabel('Fraction Neurons');
        legend('Layer 2/3', 'Layer 5','Location','NorthWest');

% mysave(gcf, [ 'HistTestS_3segs']);



% 
% %% hist
% for time_seg_i=1:3
%     ax=[];
%     legC = {'tone','lift', 'grab','traj','atmouth','success'};
% 
%     figure;
%     l=1;types=1:length(legC);
%     for type_i = 1:length(types)
%         ax(end+1) = subplot(3,3, l);
%         [b1, a1] = hist(1-nanmean(layer5.R2p_test{time_seg_i}(:, type_i, :),3), 20);
%         [b2, a2] = hist(1-nanmean(layer23.R2p_test{time_seg_i}(:, type_i, :),3), 20);
%         N(1) = sum(nanmean(layer5.R2p_test{time_seg_i}(:, type_i, :),3) <=energyth);
%         N(2) = sum(nanmean(layer23.R2p_test{time_seg_i}(:, type_i, :),3) <=energyth);
% %         [h2,pval2] = ttest(squeeze(layer23.R2p_test{time_seg_i}(:, type_i, :)).', energyth, 'tail','left', 'alpha', .1);
% %         N(2) = sum(h2);
%         bh1 = bar(a1,100*b1/sum(b1));hold all;
%         bh2 = bar(a2,100*b2/sum(b2));
% 
%         bh1.FaceColor='r';
%         bh2.FaceColor='k';
% 
%         title([legC{type_i} ' ' num2str(N) ]);l=l+1;ylabel('%Neurons');
%     end
%     ax(end+1) = subplot(3,3, l);
%     [b1, a1] = hist(1-nanmean(layer5.R2full_te{time_seg_i},2), 20);
%     [b2, a2] = hist(1-nanmean(layer23.R2full_te{time_seg_i},2), 20);
%     N(1) = sum(nanmean(layer5.R2full_te{time_seg_i},2) <=energyth);
%     N(2) = sum(nanmean(layer23.R2full_te{time_seg_i},2) <=energyth);
% 
%     % [h2,pval2] = ttest(squeeze(layer23.R2full_te{time_seg_i}).', energyth, 'tail','left', 'alpha', .1);
%     % N(2) = sum(h2);
% 
%     bh1 = bar(a1,100*b1/sum(b1));hold all;
%     bh2 = bar(a2,100*b2/sum(b2));
%     bh1.FaceColor='r';
%     bh2.FaceColor='k';
%     legend('Layer 5','Layer 2/3');
%     title(['Full Model ' num2str(N) ]);xlabel('1-R^2');ylabel('%Neurons');
% 
% %     title(['Full Model ' num2str(N(2)) ]);xlabel('1-R^2');ylabel('%Neurons');
%     linkaxes(ax);%xlim([-.1 .5]);
%     suptitle(['Test, Segment #' num2str(time_seg_i)]);
%     mysave(gcf, [ 'HistTest_3segs' num2str(time_seg_i)]);
% end

%% hist
if 1
for time_seg_i=1:2
    ax=[];
    
    figure;
    l=1;types=1:length(legendStr);
    for type_i = 1:length(types)
        ax(end+1) = subplot(3,3, l);
        [b1, a1] = hist(layer5.contribution_te{time_seg_i}(:, type_i), 20);
        [b2, a2] = hist(layer23.contribution_te{time_seg_i}(:, type_i), 20);
        N(1) = sum(layer5.contribution_te{time_seg_i}(:, type_i) >=energyth);
        N(2) = sum(layer23.contribution_te{time_seg_i}(:, type_i) >=energyth);
%         [h2,pval2] = ttest(squeeze(layer23.R2p_test{time_seg_i}(:, type_i, :)).', energyth, 'tail','left', 'alpha', .1);
%         N(2) = sum(h2);
        bh1 = bar(a1,100*b1/sum(b1));hold all;
        bh2 = bar(a2,100*b2/sum(b2));

        bh1.FaceColor='r';
        bh2.FaceColor='k';
        legend('5','2/3');
        title([legendStr{type_i}  ]);l=l+1;ylabel('%Neurons');
    end
    ax(end+1) = subplot(3,3, l);
   
    [b1, a1] = hist(1-nanmean(layer5.R2full_te{time_seg_i},2), 20);
    [b2, a2] = hist(1-nanmean(layer23.R2full_te{time_seg_i},2), 20);
    N(1) = sum(nanmean(layer5.R2full_te{time_seg_i},2) <=energyth);
    N(2) = sum(nanmean(layer23.R2full_te{time_seg_i},2) <=energyth);

    % [h2,pval2] = ttest(squeeze(layer23.R2full_te{time_seg_i}).', energyth, 'tail','left', 'alpha', .1);
    % N(2) = sum(h2);

    bh1 = bar(a1,100*b1/sum(b1));hold all;
    bh2 = bar(a2,100*b2/sum(b2));
    bh1.FaceColor='r';
    bh2.FaceColor='k';
    legend('Layer 5','Layer 2/3');
    title(['Full Model ' num2str(N) ]);xlabel('1-R^2');ylabel('%Neurons');

%     title(['Full Model ' num2str(N(2)) ]);xlabel('1-R^2');ylabel('%Neurons');
    linkaxes(ax);%xlim([-.1 .5]);
    suptitle(['Test, Segment #' num2str(time_seg_i)]);
%     mysave(gcf, [ 'HistTest_3segs' num2str(time_seg_i)]);
end
end