function glmAnalysisTreadMil(outputPath, generalProperty, imagingData, BehaveData)

splinesFile{1}.file = 'splines0.5.csv';
splinesFile{1}.delay = generalProperty.glmDelay;

splinesFile{2}.file = 'splines0.25.csv';
splinesFile{2}.delay = generalProperty.glmDelay;

splinesFile{3}.file = 'splines1.csv';
splinesFile{3}.delay = generalProperty.glmDelay;

splinesFile{4}.file = 'splines2.csv';
splinesFile{4}.delay = generalProperty.glmDelay;

for f_i = 1:length(splinesFile)
    if ~exist(splinesFile{f_i}.file, 'file')
        error('Splines file does not exist!');
        % use this R code to create that file..
%         require(stats);
%         require(graphics)
%         x <- seq.int(0, 1-1/30, 1/30)
%         library(splines2)
%         mat = bSpline(x, df = NULL, knots = NULL, degree = 7, intercept = TRUE,Boundary.knots = range(x, na.rm = TRUE))
%         matplot(x, mat, type = "l", ylab = "scaled I-spline basis")
%         write.csv(mat, file = 'splines2.csv')
%         x <- seq.int(0, 1-1/60, 1/60)
%         write.csv(mat, file = 'splines1.csv')
    end
    
    splinesFuns{f_i}.func=xlsread(splinesFile{f_i}.file);
    splinesFuns{f_i}.func = splinesFuns{f_i}.func(2:end, :);
    splinesFuns{f_i}.func = splinesFuns{f_i}.func(:, 2:end);
    splinesFuns{f_i}.delay = splinesFile{f_i}.delay;
end
t = linspace(0, generalProperty.Duration, size(imagingData.samples, 2));
% figure;
% for k = 1:size(splinesFuns, 2)
%     subplot(size(splinesFuns, 2), 1, k);
%     plot(t(1:size(splinesFuns,1)), splinesFuns(:, k));
%     ylabel(num2str(k));
% end
% xlabel('Time [seconds]');

eventsNames = generalProperty.glm_events_names;
eventsTypes = generalProperty.glm_events_types;
timesegments = generalProperty.glmSeg;
energyTh = generalProperty.glm_energyTh;
foldsNum = 5;
t = linspace(0, generalProperty.Duration, size(imagingData.samples,2)) - generalProperty.ToneTime;
ttraj = linspace(0, generalProperty.Duration, size(BehaveData.traj.data,2)) - generalProperty.ToneTime;

INDICES = crossvalind('Kfold',size(imagingData.samples, 3),foldsNum);

time_seg_i=1;
timeinds = find(t >= timesegments(1,time_seg_i) & t <= timesegments(2,time_seg_i));
timeinds_traj = find(ttraj >= timesegments(1,time_seg_i) & ttraj <= timesegments(2, time_seg_i));
pos = BehaveData.traj.data;
vel = diff(pos, 1, 2);
ac = diff(pos, 2, 2);
ttraj=ttraj(1:end-2);
kinmat = [];
if generalProperty.glmKinematics_pos
    kinmat = cat(1,kinmat, pos(:,1:end-2,:));
end
if generalProperty.glmKinematics_vel
    kinmat = cat(1,kinmat, vel(:,1:end-1,:));
end
if generalProperty.glmKinematics_acc
    kinmat = cat(1,kinmat, ac);
end
BehaveData.traj.data=kinmat;

doGlmAnalysisHist(BehaveData, timesegments, t, ttraj, foldsNum, INDICES, imagingData, ...
    generalProperty, splinesFuns, eventsNames, eventsTypes, outputPath, 'glmResHist', false,energyTh    );
% after tone - at mouth is in movment with lift and grab
% eventsTypes(strcmp(eventsTypes, 'atmouth')) = {'movement'};
% % all times
% doGlmAnalysis(BehaveData, timesegments(:, 2:end), t, ttraj, foldsNum, INDICES, imagingData, ...
%     generalProperty, splinesFuns, eventsNames, eventsTypes, outputPath, 'glmResAllTimesMoveAtMouth', false, 0.9);

