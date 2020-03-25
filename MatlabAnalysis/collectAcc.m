function allAccTot = collectAcc(tmid,allAcc, trialsNum, chanceLevel)
Nmin=Inf;
kk=1;
for k=1:length(tmid)
    if length(tmid{k}) == Nmin
        kk=k;
    end
    Nmin = min(Nmin, length(tmid{k}));
    
end
accv = zeros(size(allAcc(1).raw.accv,1), Nmin, length(tmid));
for k=1:length(allAcc)
    
    
    
    
    
  if length(tmid{k})~=Nmin
      accv(:,:,k) = interp1(tmid{k}, allAcc(k).raw.accv',tmid{kk})';
  else
    
    accv(:,:,k) = allAcc(k).raw.accv;
  end
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
allAccTot.tmid = tmid{kk};