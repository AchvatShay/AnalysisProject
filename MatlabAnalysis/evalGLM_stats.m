function [Rfull_te, contribution_te, N_te, M_te, S_te, SEM_te] = evalGLM_stats(strct, legendStr, energyth)




for time_seg_i = 1:2
    if time_seg_i == 1
        typppes = 1:length(legendStr);
        typppeston=[];
    else
        typppes = find(~strcmp(legendStr, 'tone'));
        typppeston = find(strcmp(legendStr, 'tone'));
    end
    R=strct.R2full_te{time_seg_i};
    R(R>.95)=nan;
    Rfull_te{time_seg_i} = mean(R,2);
    Rp_te = strct.R2p_test{time_seg_i};
    Rp_te(Rp_te>1)=1;
    Rp_te = nanmean(Rp_te,3);
    Rnorm = bsxfun(@rdivide, Rp_te,  Rfull_te{time_seg_i});
    Rnorm(Rnorm>1) = 1;
    Rnorm(typppeston) = 0;
    contribution_te{time_seg_i} = bsxfun(@rdivide, 1-Rnorm, sum(1-Rnorm, 2));
    
    inds = find(Rfull_te{time_seg_i}>=energyth);
N_te(time_seg_i) = length(inds);
if ~isempty(inds)
        M_te(:,time_seg_i) = nanmean(contribution_te{time_seg_i}(inds, :, :),1);
        S_te(:,time_seg_i) = nanstd(contribution_te{time_seg_i}(inds, :, :),[],1);
        SEM_te(:,time_seg_i) = S_te(:,time_seg_i)/sqrt(N_te(time_seg_i));
    end
end


    