function [traveledDistanceMean, traveledDistanceStd, traveledDistanceVariability, vals]= getTraveledDistanceStats(X, fs)
diffX = (permute(diff(permute(X,[2 1 3])), [2 1 3])).^2;
vals = nansum(sqrt(sum(diffX,1))*fs, 2);
traveledDistanceMean = nanmean(vals,3);
traveledDistanceStd = nanstd(vals,[],3);
traveledDistanceVariability = traveledDistanceStd./traveledDistanceMean;
vals=squeeze(vals);
