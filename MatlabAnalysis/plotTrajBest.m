function plotTrajBest(clrs, trajData, labels, countTraj)

classes = unique(labels);
for ci = 1:length(classes)
    inds{ci} = find(labels==classes(ci));
    closest{ci} = getClosestTrajectories(trajData, inds{ci}, countTraj);
for k=1:length(closest{ci})
    plot3(squeeze(trajData(1,:,closest{ci}(k))), squeeze(trajData(2,:,closest{ci}(k))), squeeze(trajData(3,:,closest{ci}(k))),  'Color', clrs(ci, :));
    hold on;
end
end

axis tight;
xlabel('\psi_1');ylabel('\psi_2');zlabel('\psi_3');
end

