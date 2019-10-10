function [rho,pval] = getCorrelationPval(var, grabCount, str, pvalth, binsnum)

rho = nan(1, size(var,1));
pval = nan(1, size(var,1));

for nrni = 1:size(var,1)
    
    % duration
    trials = var(nrni,:);
    valid_trials = find(~isnan(trials));
    trials = trials(valid_trials);
    trials_grabCount = grabCount(valid_trials);
    [rho(nrni),pval(nrni)] = corr(trials(:), trials_grabCount(:));
end
[a,b]=hist(pval, binsnum);
figure;
subplot(2,1,1);bh=bar(b, a/sum(a)*100);
bh.FaceColor = 'w';
xlabel('p value');ylabel('% Neurons');title(['Correlation with ' str ' - P values']);
line([1 1]*pvalth, get(gca,'YLim'),'Color','k','LineStyle','--')

[a,b]=hist(rho(pval<=pvalth), binsnum);
subplot(2,1,2);bh=bar(b, a/length(pval)*100);bh.FaceColor = 'w';

xlabel('\rho');ylabel('% Neurons');
title(sprintf(['Correlation with ' str ' @ pvalue < ' num2str(pvalth) '\n' ...
    num2str(sum(pval<=pvalth)) '/' num2str(length(pval)) ' Neurons']));

