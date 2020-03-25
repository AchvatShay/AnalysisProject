function f=loadAndPlotGLM1(filename,legendStr,pthM,pthP,pthPlastic,energyth,outputpath)
layer23.R2p_test{1}=[];layer23.R2p_test{2}=[];layer23.R2p_test{3}=[];
layer23.R2full_te{1}=[];layer23.R2full_te{2}=[];layer23.R2full_te{3}=[];
layer5.R2p_test{1}=[];layer5.R2p_test{2}=[];layer5.R2p_test{3}=[];
layer5.R2full_te{1}=[];layer5.R2full_te{2}=[];layer5.R2full_te{3}=[];

layer23plastic.R2p_test{1}=[];layer23plastic.R2p_test{2}=[];
layer23plastic.R2full_te{1}=[];layer23plastic.R2full_te{2}=[];
for m=1:length(pthPlastic)
    if ~exist(fullfile(pthPlastic{m},filename), 'file')
        warning(['File: ' fullfile(pthPlastic{m},filename) ' does not exist']);
        continue;
    end
    M = load(fullfile(pthPlastic{m},filename));
    disp(pthPlastic{m});
    disp(size(M.R2full_tr{1},1));
    for time_seg_i=1:length(M.R2full_te)
        layer23plastic.R2full_te{time_seg_i} = cat(1, layer23plastic.R2full_te{time_seg_i}, M.R2full_te{time_seg_i});
        newMat = nan(size(M.R2full_te{time_seg_i},1), length(legendStr), size(M.R2full_te{time_seg_i},2));
        inds = find(nanmean(M.R2full_te{time_seg_i},2)>=energyth);
        disp(length(inds));
        newMat(inds, :, :) = M.R2p_test{time_seg_i}(inds, :, :);
        layer23plastic.R2p_test{time_seg_i} = cat(1, layer23plastic.R2p_test{time_seg_i}, newMat);
        
    end
end

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
legendStr{strcmp(legendStr, 'reward')} = 'Outcome';
legendStr{strcmp(legendStr, 'atmouth')} = 'At Mouth';
legendStr{strcmp(legendStr, 'facemap')} = 'Orofacial';
legendStr{strcmp(legendStr, 'kinematics')} = 'Traj';
legendStr{strcmp(legendStr, 'movement')} = 'Lift+Grab';

[layer5res.Rfull_te, layer5res.contribution_te, layer5res.N_te, layer5res.M_te, layer5res.S_te, layer5res.SEM_te] = evalGLM_stats(layer5, legendStr, energyth);
[layer23res.Rfull_te, layer23res.contribution_te, layer23res.N_te, layer23res.M_te, layer23res.S_te, layer23res.SEM_te]  = evalGLM_stats(layer23, legendStr, energyth);
[layer23plasticres.Rfull_te, layer23plasticres.contribution_te, layer23plasticres.N_te, layer23plasticres.M_te, layer23plasticres.S_te, layer23plasticres.SEM_te] = evalGLM_stats(layer23plastic, legendStr, energyth);
legendStr{strcmp(legendStr, 'tone')} = 'Tone';
%% 5 23 segment 1
order4presentation = [6 4 3 2 1 5];
 time_seg_i=1;
    figure;    
        b=barwitherr(100*[layer23res.SEM_te(order4presentation,time_seg_i) layer5res.SEM_te(order4presentation,time_seg_i)],100*[layer23res.M_te(order4presentation,time_seg_i) layer5res.M_te(order4presentation,time_seg_i)]);
        legend({'Layer 2/3', 'Layer 5'},'Location','NorthWest', 'FontSize',14);
        title(['Time segment #' num2str(time_seg_i) ' layer2/3: n = ' num2str(layer23res.N_te(time_seg_i)) ' layer 5: ' num2str(layer5res.N_te(time_seg_i))]);
        set(gca,'Box','off');
   
    b(1).FaceColor = 'k';
b(1).EdgeColor = 'k';
b(2).FaceColor = [1 1 1]*192/256;
b(2).EdgeColor = [1 1 1]*192/256;

    set(gca, 'XTickLabel',legendStr(order4presentation));
xlabel('Components','FontSize',14);
ylabel('Relative Contribution [%]','FontSize',14);
mysave(gcf, fullfile(outputpath, 'Contribution_23vs5_segment1'));
%% 5 23 segment 2
order4presentation = order4presentation(2:end);
time_seg_i=2;
    figure;    
        b=barwitherr(100*[layer23res.SEM_te(order4presentation,time_seg_i) layer5res.SEM_te(order4presentation,time_seg_i)],100*[layer23res.M_te(order4presentation,time_seg_i) layer5res.M_te(order4presentation,time_seg_i)]);
        legend({'Layer 2/3', 'Layer 5'},'Location','Best', 'FontSize',14);
        title(['Time segment #' num2str(time_seg_i) ' layer2/3: n = ' num2str(layer23res.N_te(time_seg_i)) ' layer 5: ' num2str(layer5res.N_te(time_seg_i))]);
        set(gca,'Box','off');
   
    b(1).FaceColor = 'k';
b(1).EdgeColor = 'k';
b(2).FaceColor = [1 1 1]*192/256;
b(2).EdgeColor = [1 1 1]*192/256;

    set(gca, 'XTickLabel',legendStr(order4presentation));
xlabel('Components','FontSize',14);
ylabel('Relative Contribution [%]','FontSize',14);
mysave(gcf, fullfile(outputpath, 'Contribution_23vs5_segment2'));

%% modeled neurons 23 vs 5
figure;
b= bar(100*[ layer23res.N_te/size(layer23.R2full_te{1},1);layer5res.N_te/size(layer5.R2full_te{1},1)]');
title(['Overall # Neurons Layer 2/3: ' num2str(size(layer23.R2full_te{1},1)) 'Layer 5: ' num2str(size(layer5.R2full_te{1},1))]);
b(1).FaceColor = 'k';
b(1).EdgeColor = 'k';
b(2).FaceColor = [1 1 1]*192/256;
b(2).EdgeColor = [1 1 1]*192/256;
xlabel('Segments');set(gca,'Box','off');
set(gca, 'XTickLabel', {'Pre-movement','Post-movement'}, 'FontSize', 14);
ylabel('Modeled Neurons [%]', 'FontSize',14);
legend({'Layer 2/3', 'Layer 5'},'Location','Best', 'FontSize',14);
mysave(gcf, fullfile(outputpath, [ 'NumberOfNeurons_23vs5']));
%% plastic 23 segment 1
order4presentation = [6 4 3 2 1 5];
 time_seg_i=1;
    figure;    
        b=barwitherr(100*[layer23res.SEM_te(order4presentation,time_seg_i) layer23plasticres.SEM_te(order4presentation,time_seg_i)],100*[layer23res.M_te(order4presentation,time_seg_i) layer23plasticres.M_te(order4presentation,time_seg_i)]);
        legend({'Layer 2/3', 'Layer 2/3 plastic'},'Location','NorthWest', 'FontSize',14);
        title(['Time segment #' num2str(time_seg_i) ' layer2/3: n = ' num2str(layer23res.N_te(time_seg_i)) ' layer 2/3 plastic: ' num2str(layer23plasticres.N_te(time_seg_i))]);
        set(gca,'Box','off');
   keyboard;
    b(1).FaceColor = 'k';
b(1).EdgeColor = 'k';
b(2).FaceColor = [1 1 1]*192/256;
b(2).EdgeColor = [1 1 1]*192/256;

    set(gca, 'XTickLabel',legendStr(order4presentation));
xlabel('Components','FontSize',14);
ylabel('Relative Contribution [%]','FontSize',14);
mysave(gcf, fullfile(outputpath, 'Contribution_23vs_plastic_segment1'));
%% plastic seg1
order4presentation = [6 4 3 2 1 5];
 time_seg_i=1;
    figure;    
        b=barwitherr(100*[ layer23plasticres.SEM_te(order4presentation,time_seg_i)],100*[ layer23plasticres.M_te(order4presentation,time_seg_i)]);
        title(['Time segment #' num2str(time_seg_i) ' layer 2/3 plastic: ' num2str(layer23plasticres.N_te(time_seg_i))]);
        set(gca,'Box','off');
   
    b(1).FaceColor = 'k';
b(1).EdgeColor = 'k';

    set(gca, 'XTickLabel',legendStr(order4presentation));
xlabel('Components','FontSize',14);
ylabel('Relative Contribution [%]','FontSize',14);
mysave(gcf, fullfile(outputpath, 'Contribution_plastic_segment1'));
%% plastic 23 segment 2
order4presentation = order4presentation(2:end);
time_seg_i=2;
    figure;    
        b=barwitherr(100*[layer23res.SEM_te(order4presentation,time_seg_i) layer23plasticres.SEM_te(order4presentation,time_seg_i)],100*[layer23res.M_te(order4presentation,time_seg_i) layer23plasticres.M_te(order4presentation,time_seg_i)]);
        legend({'Layer 2/3', 'Layer 2/3 plastic'},'Location','Best', 'FontSize',14);
        title(['Time segment #' num2str(time_seg_i) ' layer2/3: n = ' num2str(layer23res.N_te(time_seg_i)) ' layer 2/3 plastic: ' num2str(layer23plasticres.N_te(time_seg_i))]);
        set(gca,'Box','off');
   
    b(1).FaceColor = 'k';
b(1).EdgeColor = 'k';
b(2).FaceColor = [1 1 1]*192/256;
b(2).EdgeColor = [1 1 1]*192/256;

    set(gca, 'XTickLabel',legendStr(order4presentation));
xlabel('Components','FontSize',14);
ylabel('Relative Contribution [%]','FontSize',14);
mysave(gcf, fullfile(outputpath, 'Contribution_23vs_plastic_segment2'));
%% plastic seg 2
 figure;    
        b=barwitherr(100*[ layer23plasticres.SEM_te(order4presentation,time_seg_i)],100*[ layer23plasticres.M_te(order4presentation,time_seg_i)]);
        title(['Time segment #' num2str(time_seg_i) ' layer 2/3 plastic: ' num2str(layer23plasticres.N_te(time_seg_i))]);
        set(gca,'Box','off');
   
    b(1).FaceColor = 'k';
b(1).EdgeColor = 'k';

    set(gca, 'XTickLabel',legendStr(order4presentation));
xlabel('Components','FontSize',14);
ylabel('Relative Contribution [%]','FontSize',14);
mysave(gcf, fullfile(outputpath, 'Contribution_plastic_segment2'));

%% modeled neurons 23 vs plastic
figure;
b= bar(100*[ layer23res.N_te/size(layer23.R2full_te{1},1);layer23plasticres.N_te/size(layer23plastic.R2full_te{1},1)]');
title(['Overall # Neurons Layer 2/3: ' num2str(size(layer23.R2full_te{1},1)) 'Layer 2/3 plastic: ' num2str(size(layer23plastic.R2full_te{1},1))]);
b(1).FaceColor = 'k';
b(1).EdgeColor = 'k';
b(2).FaceColor = [1 1 1]*192/256;
b(2).EdgeColor = [1 1 1]*192/256;
xlabel('Segments');set(gca,'Box','off');
set(gca, 'XTickLabel', {'Pre-movement','Post-movement'}, 'FontSize', 14);
ylabel('Modeled Neurons [%]', 'FontSize',14);
legend({'Layer 2/3', 'Layer 2/3 plastic'},'Location','Best', 'FontSize',14);
mysave(gcf, fullfile(outputpath, [ 'NumberOfNeurons_23_vs_plastic']));
%% modeled nrns plastic
figure;
b= bar(100*[ layer23plasticres.N_te/size(layer23plastic.R2full_te{1},1)]);
title([ 'Layer 23 plastic: ' num2str(size(layer23plastic.R2full_te{1},1))]);
b(1).FaceColor = 'k';
b(1).EdgeColor = 'k';set(gca,'Box','off');
xlabel('Segments');
set(gca, 'XTickLabel', {'Pre-movement','Post-movement'}, 'FontSize', 14);
ylabel('Modeled Neurons [%]', 'FontSize',14);
mysave(gcf, fullfile(outputpath, [ 'NumberOfNeurons_23plastic']));


return;

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