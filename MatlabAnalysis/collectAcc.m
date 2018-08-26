function allAccTot = collectAcc(allAcc, trialsNum, chanceLevel)


for k=1:length(allAcc)
    accv(:,:,k) = allAcc(k).raw.accv;
end
% accv=accv/sum(w);
% accv = permute(accv, [1 3 2]);
w=trialsNum/sum(trialsNum);
allAccTot.raw.mean = mean(sum(bsxfun(@times, accv, permute(w, [1 3 2])), 3));
allAccTot.chanceLevel = mean(sum(chanceLevel.*w));
% allAccTot.raw.std = sum(bsxfun(@times, S, w), 2);
% allAccTot.raw.mean = sum(bsxfun(@times, M, w), 2);
allAccTot.raw.std=sqrt(mean(sum(bsxfun(@times, accv.^2, permute(w, [1 3 2])), 3))-allAccTot.raw.mean.^2);
for ti=1:length(allAccTot.raw.mean)
allAccTot.raw.C(:,ti) = getConfidenceInterval(allAccTot.raw.mean(ti), allAccTot.raw.std(ti), numel(accv)/size(accv,2), 0.05);
end