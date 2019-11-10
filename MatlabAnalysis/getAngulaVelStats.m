function [angulaVelMean, angulaVelstd, angularVelConf, angularvel]= getAngulaVelStats(X, perc, fs)

 th1 = squeeze(atan(X(2,:,:)./X(1,:,:)));
 angularvel = diff(th1)*fs;
angulaVelMean = nanmean(angularvel(:));
angulaVelstd = nanstd(nanmean(angularvel));
angularVelConf = getConfidenceInterval(angulaVelMean, angulaVelstd, size(angularvel,2), perc);
