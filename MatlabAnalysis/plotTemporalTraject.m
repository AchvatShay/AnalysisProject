function f = plotTemporalTraject(pcaTrajSmooth, labsOmissions, t, toneTime, labelsFontSz, viewparams)

f(1) = figure;
plotTrajMeanRBstartMove(pcaTrajSmooth, labsOmissions,1, ...
    findClosestDouble(t, toneTime), false, viewparams, labelsFontSz);

f(2) = figure;
plotTrajMeanRBstartMove(pcaTrajSmooth, labsOmissions,1, ...
    findClosestDouble(t, toneTime), [], viewparams, labelsFontSz);
hold all;
plotTrajBest(pcaTrajSmooth(1:3,:,:), labsOmissions,  5);
% plotTraj(res.pcaNT.projeff{1}(:,2:end,:), labsOmissions,  3);
hold all;
plotTrajMeanRBstartMove(pcaTrajSmooth, labsOmissions,1, ...
    findClosestDouble(t, toneTime), [],viewparams, labelsFontSz);

