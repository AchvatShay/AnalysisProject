function [closest0, closest1] = plotTrajBest(trajData, labels, countTraj)
if nargin == 2
    dim=2;
end
inds0 = find(labels==0);
inds1 = find(labels==1);
closest0 = getClosestTrajectories(trajData, inds0, countTraj);
closest1 = getClosestTrajectories(trajData, inds1, countTraj);
for k = 1:length(closest1)
    plot3(squeeze(trajData(1,:,closest1(k))), squeeze(trajData(2,:,closest1(k))), squeeze(trajData(3,:,closest1(k))),  '-r');
    
    hold on;
end
for k = 1:length(closest0)    
    plot3(squeeze(trajData(1,:,closest0(k))), squeeze(trajData(2,:,closest0(k))), squeeze(trajData(3,:,closest0(k))),  '-b');
    
    hold on;
end

axis tight;
xlabel('\psi_1');ylabel('\psi_2');zlabel('\psi_3');
end

