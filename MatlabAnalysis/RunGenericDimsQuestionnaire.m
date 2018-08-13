function [ Trees, dual_aff, init_aff, embedding, data, vals ] = RunGenericDimsQuestionnaire( params, data )
% Runs questionnaire algorithm using trees built by PCA clustering
% Author: Hadas Benisty
% 14.2.2016
%
% Inputs:
%     params - struct array with all user parameters
%     data - M-by-N matrix whose columns are N points in R^M (optional)
%
% Outputs:
%     row_tree, col_tree - the resulting partition trees, given as cells of
%         struct arrays
%--------------------------------------------------------------------------
if any(isnan(data)) == true
    warning('Data contains NaN!');
    data(isnan(data)) = 0;
end

dims = ndims(data);

if params.data.to_normalize,
    data = NormalizeData(data, params.data);
%     if params.verbose == 2
%         figure, imagesc(data(:,:,1)), colormap gray, axis on, title('Normalized Data'), colorbar;
%     end
end
init_aff  = cell(ndims(data), 1);
Trees     = cell(ndims(data), 1);
embedding = cell(ndims(data), 1);
dual_aff  = cell(ndims(data), 1);

%%
for dimi = 1:dims
    
    init_aff{dimi} = CalcInitAff(data, params.init_aff{dimi}, dimi);
    Trees{dimi} = params.tree{dimi}.buildTreeFun(threshold(init_aff{dimi}, params.init_aff{dimi}.thresh), params.tree{dimi});    
    
    [vecs, vals{dimi}] = CalcEigs(threshold(init_aff{dimi}, params.init_aff{dimi}.thresh)    , params.tree{dimi}.eigs_num);
    embedding{dimi} = vecs*vals{dimi};
     
    
    
end

%%
% if params.verbose == 2
%     figure;
%     for dimi = 1:dims
%         subplot(dims,1,dimi);
%         imagesc(init_aff{dimi});colorbar;title(['Dim No. ' num2str(dimi) ' - Initial Affin.']);
%     end
%     figure;
%     for dimi = 1:dims
%         subplot(dims,1,dimi);
%         plotTreeWithColors(Trees{dimi}, 1:length(init_aff{dimi}));
%     end
%     
%     figure;
%     for dimi = 1:dims        
%         subplot(dims,1,dimi);
%         PlotEmbedding(embedding{dimi}, 1:size(init_aff{dimi},1),  ['Dim No. ' num2str(dimi) ' - Initial'] );
%     end
%     figure;
% end

%%
for ii = 1:params.n_iters
    for dimi = 1:dims
        dual_aff{dimi} = CalcEmdAff(data, Trees, params.emd, dimi);
        Trees{dimi} = params.tree{dimi}.buildTreeFun(dual_aff{dimi}, params.tree{dimi});
        [vecs, vals{dimi}] = CalcEigs(dual_aff{dimi}, params.tree{dimi}.eigs_num);
        embedding{dimi} = vecs*vals{dimi};
        
%         if params.verbose == 2
%             subplot(dims,1,dimi);
%             plotTreeWithColors(Trees{dimi}, 1:length(dual_aff{dimi}));
%             title(['Dim No. ' num2str(dimi) ' -  Tree (Iteration ', num2str(ii),')']);
%             drawnow;
%         end
    end
end

%%
% if params.verbose == 2
%     if params.n_iters >= 1
%         % plot final affins
%         figure;
%         for dimi = 1:dims
%             subplot(dims,1,dimi);
%             imagesc(dual_aff{dimi});colorbar;title(['Dim No. ' num2str(dimi) ' - Final Affin.']);
%         end
%     end
%     
%     figure;
%     for dimi = 1:dims        
%             subplot(dims,1,dimi);
%             PlotEmbedding(embedding{dimi}, 1:size(init_aff{dimi},1),  ['Dim No. ' num2str(dimi) ' - Final '] );
%     end
% end

end


