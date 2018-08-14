function closest = getClosestTrajectories(trajData, inds, countTraj)

meann = mean(trajData(:,:,inds),3); 
distt = squeeze(sum(sum((bsxfun(@minus, trajData(:,:,inds), meann)).^2,1),2));
[~, closest] = sort(distt, 'ascend');
closest=inds(closest(1:min(length(closest), countTraj)));

end