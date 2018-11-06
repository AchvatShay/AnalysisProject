function pcaTrajectoriesCalcDistance(outputPath, generalProperty, imagingData, BehaveData)
% analysis
[labels, examinedInds, eventsStr, labelsLUT] = getLabels4clusteringFromEventslist(BehaveData, ...
generalProperty.labels2cluster, generalProperty.includeOmissions);
[prevcurlabs, prevCurrLUT] = getPrevCurrLabels(labels, labelsLUT);

X = imagingData.samples(:, :, examinedInds);
if exist(fullfile(outputPath, ['pca_traj_res' eventsStr '.mat']), 'file')
    load(fullfile(outputPath, ['pca_traj_res' eventsStr '.mat']));
else
    for k=1:size(X,1)
        alldataNT(:, k) = reshape(X(k,:,:), size(X,3)*size(X,2),1);
    end
    [pcaTrajres.kernel, pcaTrajres.mu, pcaTrajres.eigs] = mypca(alldataNT);
    pcaTrajres.effectiveDim = max(getEffectiveDim(pcaTrajres.eigs, generalProperty.analysis_pca_thEffDim), 3);
    
    [~, projeff] = linrecon(alldataNT, pcaTrajres.mu, pcaTrajres.kernel, 1:pcaTrajres.effectiveDim);
    for l=1:size(projeff,2)
        pcaTrajres.projeff(l,:,:) = reshape(projeff(:,l),size(X,2),size(X,3));
    end
    save(fullfile(outputPath, ['pca_traj_res' eventsStr '.mat']), 'pcaTrajres');
end

b = fir1(10,.3);
trajSmooth = filter(b,1, pcaTrajres.projeff, [], 2);
trajSmooth=trajSmooth(:,6:end,:);

toneTime = generalProperty.ToneTime;
t = linspace(0, generalProperty.Duration, size(X,2)) - toneTime;
t = t(6:end);
mvStartInd=findClosestDouble(t,t(11));
toneTimeind=findClosestDouble(t,0);

embedding = mean(trajSmooth,3).';
% calc norm for fadi
% shay achvat code added

norm_sum_value.x.all = 0;
norm_sum_value.y.all = 0;
norm_sum_value.z.all = 0;
norm_sum_value.norm.all = 0;

norm_sum_value.x.partA = 0;
norm_sum_value.y.partA = 0;
norm_sum_value.z.partA = 0;
norm_sum_value.norm.partA = 0;

norm_sum_value.x.partB = 0;
norm_sum_value.y.partB = 0;
norm_sum_value.z.partB = 0;
norm_sum_value.norm.partB = 0;

for index_norm = mvStartInd : (size(embedding, 1) - 1)
     vector_norm_A = [embedding(index_norm, 1), embedding(index_norm, 2), embedding(index_norm, 3)];
     vector_norm_B = [embedding(index_norm + 1, 1), embedding(index_norm + 1, 2), embedding(index_norm + 1, 3)];
     norm_sum_value.norm.all = norm_sum_value.norm.all + norm(vector_norm_B - vector_norm_A);
     norm_sum_value.x.all = norm_sum_value.x.all + abs(embedding(index_norm + 1, 1) - embedding(index_norm, 1));
     norm_sum_value.y.all = norm_sum_value.y.all + abs(embedding(index_norm + 1, 2) - embedding(index_norm, 2));
     norm_sum_value.z.all = norm_sum_value.z.all + abs(embedding(index_norm + 1, 3) - embedding(index_norm, 3));
end

for index_norm = mvStartInd : (toneTimeind - 1)
     vector_norm_A = [embedding(index_norm, 1), embedding(index_norm, 2), embedding(index_norm, 3)];
     vector_norm_B = [embedding(index_norm + 1, 1), embedding(index_norm + 1, 2), embedding(index_norm + 1, 3)];
     norm_sum_value.norm.partA = norm_sum_value.norm.partA + norm(vector_norm_B - vector_norm_A);
     norm_sum_value.x.partA = norm_sum_value.x.partA + abs(embedding(index_norm + 1, 1) - embedding(index_norm, 1));
     norm_sum_value.y.partA = norm_sum_value.y.partA + abs(embedding(index_norm + 1, 2) - embedding(index_norm, 2));
     norm_sum_value.z.partA = norm_sum_value.z.partA + abs(embedding(index_norm + 1, 3) - embedding(index_norm, 3));
end

for index_norm = toneTimeind : (size(embedding, 1) - 1)
     vector_norm_A = [embedding(index_norm, 1), embedding(index_norm, 2), embedding(index_norm, 3)];
     vector_norm_B = [embedding(index_norm + 1, 1), embedding(index_norm + 1, 2), embedding(index_norm + 1, 3)];     
     norm_sum_value.norm.partB = norm_sum_value.norm.partB + norm(vector_norm_B - vector_norm_A);
     norm_sum_value.x.partB = norm_sum_value.x.partB + abs(embedding(index_norm + 1, 1) - embedding(index_norm, 1));
     norm_sum_value.y.partB = norm_sum_value.y.partB + abs(embedding(index_norm + 1, 2) - embedding(index_norm, 2));
     norm_sum_value.z.partB = norm_sum_value.z.partB + abs(embedding(index_norm + 1, 3) - embedding(index_norm, 3));
end


fileID = fopen(strcat(outputPath, '\distanceTraj.txt'),'w');
formatSpec = strcat('The total traj norm vector distance is %f \r\n',...
'The part 1-120 traj norm vector distance is %f \r\n',...
'The part 120-360 traj norm vector distance is %f \r\n',...
'\r\n',...
'The total traj X distance is %f \r\n',...
'The part 1-120 traj X distance is %f \r\n',...
'The part 120-360 traj X distance is %f \r\n',...
'\r\n',...
'The total traj Y distance is %f \r\n',...
'The part 1-120 traj Y distance is %f \r\n',...
'The part 120-360 traj Y distance is %f \r\n',...
'\r\n',...
'The total traj Z distance is %f \r\n',...
'The part 1-120 traj Z distance is %f \r\n',...
'The part 120-360 traj Z distance is %f \r\n');
fprintf(fileID, formatSpec,norm_sum_value.norm.all, norm_sum_value.norm.partA, norm_sum_value.norm.partB,...
    norm_sum_value.x.all, norm_sum_value.x.partA, norm_sum_value.x.partB,...
    norm_sum_value.y.all, norm_sum_value.y.partA, norm_sum_value.y.partB,...
    norm_sum_value.z.all, norm_sum_value.z.partA, norm_sum_value.z.partB);
fclose(fileID);

end
                    