function glmAnalysis(outputPath, generalProperty, imagingData, BehaveData)
splinesFile = 'splines.csv';
calcConst = true;


if ~exist(splinesFile, 'file')
    error('Splines file does not exist!');
    % use this R code to create that file..
    % require(stats);
    % require(graphics)
    % x <- seq.int(0, 1-1/30, 1/30)
    %
    % mat = bSpline(x, df = NULL, knots = NULL, degree = 7, intercept = TRUE,Boundary.knots = range(x, na.rm = TRUE))
    % matplot(x, mat, type = "l", ylab = "scaled I-spline basis")
    % write.csv(mat, file = 'splines.csv')
end
splinesFuns=xlsread(splinesFile);
splinesFuns = splinesFuns(2:end, :);
splinesFuns = splinesFuns(:, 2:end);

t = linspace(0, generalProperty.Duration, size(imagingData.samples, 2));
figure;
for k = 1:size(splinesFuns, 2)
    subplot(size(splinesFuns, 2), 1, k);
    plot(t(1:size(splinesFuns,1)), splinesFuns(:, k));
    ylabel(num2str(k));
end
xlabel('Time [seconds]');
gamma_c = logspace(-4, -2, 9);

eventsNames = generalProperty.glm_events_names;
eventsTypes = generalProperty.glm_events_types;

% timesegments = [0:12:generalProperty.Duration] - generalProperty.ToneTime;
% timesegments = [0:2:generalProperty.Duration] - generalProperty.ToneTime;
timesegments = [-2 0 2 4 -2;0 2 4 8 8];
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
BehaveData.traj.data = cat(1, pos(:,1:end-2,:), vel(:,1:end-1,:), ac);
% before tone - kinematics + prev succ/fail
doGlmAnalysis(BehaveData, timesegments(:, 1), t, ttraj, foldsNum, INDICES, imagingData, ...
    generalProperty, splinesFuns, eventsNames, eventsTypes, outputPath, 'glmRessegsBeforeTone', true, 0.9);
% after tone - all times, at mouth has his own category
doGlmAnalysis(BehaveData, [-2; 8], t, ttraj, foldsNum, INDICES, imagingData, ...
    generalProperty, splinesFuns, eventsNames, eventsTypes, outputPath, 'glmResAllTimesSepAtMouth', false, 0.9);
% after tone - segments, at mouth has his own category
doGlmAnalysis(BehaveData, timesegments(:, 2:end), t, ttraj, foldsNum, INDICES, imagingData, ...
    generalProperty, splinesFuns, eventsNames, eventsTypes, outputPath, 'glmRessegsAfterToneSepAtMouth', false, 0.9);
% after tone - at mouth is in movment with lift and grab
eventsTypes(strcmp(eventsTypes, 'atmouth')) = {'movement'};
% all times
doGlmAnalysis(BehaveData, timesegments(:, 2:end), t, ttraj, foldsNum, INDICES, imagingData, ...
    generalProperty, splinesFuns, eventsNames, eventsTypes, outputPath, 'glmResAllTimesMoveAtMouth', false, 0.9);
% segments
doGlmAnalysis(BehaveData, timesegments(:, 2:end), t, ttraj, foldsNum, INDICES, imagingData, ...
    generalProperty, splinesFuns, eventsNames, eventsTypes, outputPath, 'glmRessegsAfterToneMoveAtMouth', false, 0.9);
