function [f, meansTrajs] = plotTemporalTraject(countbesttrajs, labelsLUT, clrs, pcaTrajSmooth, labels, t, toneTime, labelsFontSz, viewparams)

f(1) = figure;
meansTrajs = plotTrajMeanRBstartMove(labelsLUT, clrs, pcaTrajSmooth, labels,1, ...
    findClosestDouble(t, toneTime), false, viewparams, labelsFontSz);

f(2) = figure;
plotTrajMeanRBstartMove(labelsLUT, clrs, pcaTrajSmooth, labels,1, ...
    findClosestDouble(t, toneTime), [], viewparams, labelsFontSz);
hold all;
plotTrajBest(clrs, pcaTrajSmooth(1:3,:,:), labels, countbesttrajs);
% plotTraj(res.pcaNT.projeff{1}(:,2:end,:), labels,  3);
hold all;
plotTrajMeanRBstartMove(labelsLUT, clrs, pcaTrajSmooth, labels,1, ...
    findClosestDouble(t, toneTime), [],viewparams, labelsFontSz);

