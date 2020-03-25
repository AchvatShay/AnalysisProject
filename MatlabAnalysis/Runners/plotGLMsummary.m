clear;
addpath(genpath('..'));

pthM{1} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer23\D54_10_25_17';
pthM{2} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer23\M26_92417';
pthM{3} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer23\M26_92817';
pthM{4} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer23\M26_10_1_17';
pthM{5} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer23\M27_12_31_17';
pthM{6} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer23\M27_1_3_18';
pthM{7} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer23\M27_1_10_18';
pthM{8} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer23\M27_1_18_18';
pthM{9} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer23\M27_1_8_18\';



pthP{1} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer5\Den6_4_2_17';
pthP{2} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer5\Den7_8_13_17';
pthP{3} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer5\PT3_31318';


pthplastic{1} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\plastic\M29_8_30_18';
pthplastic{2} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\plastic\M30_7_30_18';
pthplastic{3} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\plastic\M30_8_7_18';
pthplastic{4} = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\plastic\M30_08_09_18';

% 
legendStr = {'tone', 'lift','grab','traj','atmouth','outcome'};
filename = 'glmResHist.mat';

energyth=.15;

loadAndPlotGLM1(filename,legendStr,pthM,pthP,pthplastic,energyth, '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\');
suptitle('All animals');
set(f,'Position',[0.0010    0.0410    1.5360    0.7488]*1e3);
% mysave(f, ['All']);
% legendStr = {'movement','reward'};
% filename = 'glmResHist.mat';
% 
% for i = 1:length(pthP)
% loadAndPlotGLM(filename,legendStr,[],pthP(i),energyth, 'R2p_test');
% ind = strfind(pthP{i}, '\');
% name = pthP{i}(ind(end)+1:end);
% name1=name;
% name1(name=='_') = ' ';
% suptitle(name1);
% set(gcf,'Position',[0.0010    0.0410    1.5360    0.7488]*1e3);
% 
% mysave(gcf, [name '_2cats']);
% end
% for i = 1:length(pthM)
% loadAndPlotGLM(filename,legendStr,pthM(i),[],energyth, 'R2p_test');
% ind = strfind(pthM{i}, '\');
% name = pthM{i}(ind(end)+1:end);
% name1=name;
% name1(name=='_') = ' ';
% suptitle(name1);
% set(gcf,'Position',[0.0010    0.0410    1.5360    0.7488]*1e3);
% mysave(gcf, [name '_2cats']);
% end
% 
% f=loadAndPlotGLM(filename,legendStr,pthM,pthP,energyth, 'R2p_test');
% suptitle('All animals');
% set(f,'Position',[0.0010    0.0410    1.5360    0.7488]*1e3);
% mysave(f, ['All_2cats']);
% %% hist
% for time_seg_i=1:3
%     ax=[];
%     legC = {'tone','lift', 'grab','traj','atmouth','success'};
%             
%     figure;
%     l=1;types=1:length(legC);
%     for type_i = 1:length(types)
%         ax(end+1) = subplot(1+length(types),1, l);
%         [b1, a1] = hist(1-mean(layer5.R2p_test{time_seg_i}(:, type_i, :),3), 20);
%         [b2, a2] = hist(1-mean(layer23.R2p_test{time_seg_i}(:, type_i, :),3), 20);
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
%     ax(end+1) = subplot(1+length(types),1, l);
%     [b1, a1] = hist(1-mean(layer5.R2full_te{time_seg_i},2), 20);
%     [b2, a2] = hist(1-mean(layer23.R2full_te{time_seg_i},2), 20);
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
%     linkaxes(ax);xlim([-.1 .5]);
%     suptitle(['Test, Segment #' num2str(time_seg_i)]);
% %     mysave(gcf, [ 'HistTest_3segs' num2str(time_seg_i)]);
% end
%% cdf
% for time_seg_i=1%:3
%     ax=[];
%     figure;
%     l=1;types=1:length(legC);L=[];
%     for type_i = 1:length(types)
%         ax(end+1) = subplot(1+length(types),1, l);
%         [b1, a1] = hist(1-mean(layer5.R2p_test{time_seg_i}(:, type_i, :),3), 20);
%         [b2, a2] = hist(1-mean(layer23.R2p_test{time_seg_i}(:, type_i, :),3), 20);
%         N(1) = sum(nanmean(layer5.R2p_test{time_seg_i}(:, type_i, :),3) <=energyth);
%         N(2) = sum(nanmean(layer23.R2p_test{time_seg_i}(:, type_i, :),3) <=energyth);
% %         [h2,pval2] = ttest(squeeze(layer23.R2p_test{time_seg_i}(:, type_i, :)).', energyth, 'tail','left', 'alpha', .1);
% %         N(2) = sum(h2);
%         if N(1) > 0
%         plot(a1, cumsum(b1)/sum(b1)*100,'b');hold all;
% %         
%         end
%         if N(2) > 0
%         plot(a2, cumsum(b2)/sum(b2)*100,'k--');
%         
%         end
%         
%         title([legC{type_i} ' ' num2str(N) ]);l=l+1;ylabel('%Neurons');
%     end
%     ax(end+1) = subplot(1+length(types),1, l);
%     [b1, a1] = hist(1-mean(layer5.R2full_te{time_seg_i},2), 20);
%     [b2, a2] = hist(1-mean(layer23.R2full_te{time_seg_i},2), 20);
%     N(1) = sum(nanmean(layer5.R2full_te{time_seg_i},2) <=energyth);
%     N(2) = sum(nanmean(layer23.R2full_te{time_seg_i},2) <=energyth);
%     
%     % [h2,pval2] = ttest(squeeze(layer23.R2full_te{time_seg_i}).', energyth, 'tail','left', 'alpha', .1);
%     % N(2) = sum(h2);
%     if N(1) > 0
%         plot(a1, cumsum(b1)/sum(b1)*100,'b');hold all;  
%         L{end+1} = 'layer 5';
%         end
%         if N(2) > 0
%         plot(a2, cumsum(b2)/sum(b2)*100,'k--');
%         L{end+1} = 'layer 2/3';
%         end
%     legend(L);
%     title(['Full Model ' num2str(N) ]);xlabel('1-R^2');ylabel('%Neurons');
%     
% %     title(['Full Model ' num2str(N(2)) ]);xlabel('1-R^2');ylabel('%Neurons');
%     linkaxes(ax);
%     suptitle(['Test, Segment #' num2str(time_seg_i)]);
% %     mysave(gcf, [ 'HistTest_3segs' num2str(time_seg_i)]);
% end

for time_seg_i=1:3
    
    for fold_i = 1:5
        for nrni = 1:size(layer5.R2p_test{time_seg_i},1)
            layer5.Rnorm_te{time_seg_i}(nrni, :, fold_i) = layer5.R2p_test{time_seg_i}(nrni, :, fold_i)/layer5.R2full_te{time_seg_i}(nrni, fold_i );
            layer5.contribution_te{time_seg_i}(nrni, :, fold_i) = (1-layer5.Rnorm_te{time_seg_i}(nrni,:, fold_i))/sum(1-layer5.Rnorm_te{time_seg_i}(nrni,:, fold_i));
        end
        for nrni = 1:size(layer23.R2p_test{time_seg_i},1)
            layer23.Rnorm_te{time_seg_i}(nrni, :, fold_i) = layer23.R2p_test{time_seg_i}(nrni, :, fold_i)/layer23.R2full_te{time_seg_i}(nrni, fold_i );
            layer23.contribution_te{time_seg_i}(nrni, :, fold_i) = (1-layer23.Rnorm_te{time_seg_i}(nrni,:, fold_i))/sum(1-layer23.Rnorm_te{time_seg_i}(nrni,:, fold_i));
            
        end
    end
end
for time_seg_i = 1:3%:size(timesegments,2)
    inds = find(nanmean(layer5.R2full_te{time_seg_i},2)<=energyth);
    layer5.N_te(time_seg_i) = length(inds);
    layer5.M_te(:,time_seg_i) = nanmean(nanmean(layer5.contribution_te{time_seg_i}(inds, :, :),3),1);
    layer5.S_te(:,time_seg_i) = nanstd(nanmean(layer5.contribution_te{time_seg_i}(inds, :, :),3),[],1);
    layer5.n(time_seg_i) = size(layer5.contribution_te{time_seg_i}(inds, :, :),1);
    layer5.SEM_te(:,time_seg_i) = layer5.S_te(:,time_seg_i)/sqrt(layer5.n(time_seg_i));
    inds = find(nanmean(layer23.R2full_te{time_seg_i},2)<=energyth);
    %     [h2,pval2] = ttest(squeeze(layer23.R2full_te{time_seg_i}).', energyth, 'tail','left', 'alpha', .1);
    % inds = find(h2==1);
    
    layer23.N_te(time_seg_i) = length(inds);
    layer23.M_te(:,time_seg_i) = nanmean(nanmean(layer23.contribution_te{time_seg_i}(inds, :, :),3),1);
    layer23.S_te(:,time_seg_i) = nanstd(nanmean(layer23.contribution_te{time_seg_i}(inds, :, :),3),[],1);
    layer23.n(time_seg_i) = size(layer23.contribution_te{time_seg_i}(inds, :, :),1);
    layer23.SEM_te(:,time_seg_i) = layer23.S_te(:,time_seg_i)/sqrt(layer23.n(time_seg_i));
    
end
legendStr = {'tone', 'lift','grab','traj','atmouth','outcome'};
figure;
for time_seg_i=1:3
    subplot(3,1,time_seg_i)
    barwitherr([layer5.SEM_te(:,time_seg_i) layer23.SEM_te(:,time_seg_i)],[layer5.M_te(:,time_seg_i) layer23.M_te(:,time_seg_i)]);
%     barwitherr([ layer23.SEM_te(:,time_seg_i)],[ layer23.M_te(:,time_seg_i)]);
    
    legend('Layer 5','Layer 2/3');
    title(['Time segment #' num2str(time_seg_i) ' layer2/3: n = ' num2str(layer23.n(time_seg_i)) ]);
    
    title(['Time segment #' num2str(time_seg_i) ' layer2/3: n = ' num2str(layer23.n(time_seg_i)) ' layer 5: ' num2str(layer5.n(time_seg_i))]);
    set(gca, 'XTickLabel',legendStr);
end

mysave(gcf, [ 'HistTestS_3segs']);
% %title('Segment [-2 2] seconds');
% set(gca, 'XTickLabel', {'motor','reward'});
% plotContribution(layer5.SEM_te, layer5.M_te, 0, legC);
% title(['Test, % of Neurons is: ' num2str(n) '/' num2str(size(imagingData.samples,1))]);
% mysave(gcf, fullfile(outputpath, [outputfile 'Test']));

