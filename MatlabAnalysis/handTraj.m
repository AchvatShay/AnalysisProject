function handTraj(outputPath, generalProperty, imagingData, BehaveData)


 t = linspace(0, generalProperty.Duration, size(BehaveData.traj.data, 2));    
      framesSelected = findClosestDouble(t, generalProperty.traj3D_startTime) : findClosestDouble(t,generalProperty.traj3D_endTime);


 for T=1:size(BehaveData.traj.data,3)            
TrajAll(:, framesSelected-findClosestDouble(t, generalProperty.traj3D_startTime)+1, T) = BehaveData.traj.data([1 3 4], framesSelected, T);
 end
 TrajAll_nan = nan(size(TrajAll));
 for T=1:size(BehaveData.traj.data,3)
      framesSelected = findClosestDouble(t, generalProperty.traj3D_startTime) : findClosestDouble(t,generalProperty.traj3D_endTime);

            
indexAcordingToLikelyhood = BehaveData.traj.data(5, framesSelected, T) >= 0.9 & BehaveData.traj.data(6, framesSelected, T) >= 0.9;
           framesSelected= framesSelected(indexAcordingToLikelyhood);
           TrajAll_nan(:, framesSelected-findClosestDouble(t, generalProperty.traj3D_startTime)+1, T) = BehaveData.traj.data([1 3 4], framesSelected, T);


 end
 t = linspace(generalProperty.traj3D_startTime, generalProperty.traj3D_endTime, size(TrajAll,2));
 perc=.95;
 [angulaVelMean0xy, angulaVelstd0xy, angularVelConf0xy, angularvel0xy]= getAngulaVelStats(TrajAll_nan(1:2,:,BehaveData.success.indicatorPerTrial==0),perc, generalProperty.BehavioralSamplingRate);
 [angulaVelMean0xz, angulaVelstd0xz, angularVelConf0xz, angularvel0xz]= getAngulaVelStats(TrajAll_nan([1 3],:,BehaveData.success.indicatorPerTrial==0),perc, generalProperty.BehavioralSamplingRate);

 [angulaVelMean1xy, angulaVelstd1xy, angularVelConf1xy, angularvel1xy]= getAngulaVelStats(TrajAll_nan(1:2,:,BehaveData.success.indicatorPerTrial==1),perc, generalProperty.BehavioralSamplingRate);
 [angulaVelMean1xz, angulaVelstd1xz, angularVelConf1xz, angularvel1xz]= getAngulaVelStats(TrajAll_nan([1 3],:,BehaveData.success.indicatorPerTrial==1),perc, generalProperty.BehavioralSamplingRate);

 [angulaVelMeanxy, angulaVelstdxy, angularVelConfxy, angularvelxy]= getAngulaVelStats(TrajAll_nan(1:2,:,:),perc, generalProperty.BehavioralSamplingRate);
 [angulaVelMeanxz, angulaVelstdxz, angularVelConfxz, angularvelxz]= getAngulaVelStats(TrajAll_nan([1 3],:,:),perc, generalProperty.BehavioralSamplingRate);

[hangulaVelxy,pangulaVelxy] = ttest2(nanmean(angularvel1xy),nanmean(angularvel0xy), 0.05,'left');
[hangulaVelxz,pangulaVelxz] = ttest2(nanmean(angularvel1xz),nanmean(angularvel0xz), 0.05,'left');


meanTraj = nanmean(TrajAll_nan,3);
meanTraj0 = nanmean(TrajAll_nan(:,:,BehaveData.success.indicatorPerTrial==0),3);
meanTraj1 = nanmean(TrajAll_nan(:,:,BehaveData.success.indicatorPerTrial==1),3);
stdTraj = nanstd(TrajAll_nan,[],3);
stdTraj0 = nanstd(TrajAll_nan(:,:,BehaveData.success.indicatorPerTrial==0),[],3);
stdTraj1 = nanstd(TrajAll_nan(:,:,BehaveData.success.indicatorPerTrial==1),[],3);
for k=1:size(meanTraj0,1)
ConfTraj0(:,:,k) = getConfidenceInterval(meanTraj0(k,:)', stdTraj0(k,:)', sum(BehaveData.success.indicatorPerTrial==0), perc);
ConfTraj1(:,:,k) = getConfidenceInterval(meanTraj1(k,:)', stdTraj1(k,:)', sum(BehaveData.success.indicatorPerTrial==1), perc);
ConfTraj(:,:,k) = getConfidenceInterval(meanTraj(k,:)', stdTraj(k,:)', length(BehaveData.success.indicatorPerTrial), perc);
end
str = {'x' 'y' 'z'};
overallvariability = mean(stdTraj./meanTraj,2);
variability0 = mean(stdTraj0./meanTraj0,2);
variability1 = mean(stdTraj1./meanTraj1,2);
figure,
for k=1:3
subplot(3,1,k)
shadedErrorBar(t,meanTraj(k,:),ConfTraj(1,:,k)-meanTraj(k,:),'lineprops','k');
title(str{k})
xlabel('Time [sec]')
ylabel('Position')
title([str{k} ])

xlabel('Time [sec]')
ylabel('Position')
ylmm = get(gca, 'YLim');
end
mysave(gcf, fullfile(outputPath, 'handTrajStats'))

[traveledDistanceMean, traveledDistanceStd, traveledDistanceVariability, traveledDistance]= getTraveledDistanceStats(TrajAll_nan, generalProperty.BehavioralSamplingRate);
[traveledDistanceMean1, traveledDistanceStd1, traveledDistanceVariability1, traveledDistance1]= ...
    getTraveledDistanceStats(TrajAll_nan(:,:,BehaveData.success.indicatorPerTrial==1), generalProperty.BehavioralSamplingRate);
[traveledDistanceMean0, traveledDistanceStd0, traveledDistanceVariability0, traveledDistance0]= ...
    getTraveledDistanceStats(TrajAll_nan(:,:,BehaveData.success.indicatorPerTrial==0), generalProperty.BehavioralSamplingRate);
[htraveledDistance,ptraveledDistance] = ttest2((traveledDistance0),(traveledDistance1), 0.05,'left');

vel = permute((diff(permute(TrajAll_nan,[2 1 3]))),[2 1 3]);
velMean = abs(nanmean(nanmean(vel, 2),3));
velStd = nanstd(nanmean(vel, 2),[],3);
velVariability = velStd./velMean;


l=1;
figure,
for k=1:3
subplot(3,2,l)
shadedErrorBar(t,meanTraj1(k,:),ConfTraj1(1,:,k)-meanTraj1(k,:),'lineprops','b');
title([str{k}])
xlabel('Time [sec]')
ylabel('Position')
l=l+1;
subplot(3,2,l)
shadedErrorBar(t,meanTraj0(k,:),ConfTraj0(1,:,k)-meanTraj0(k,:),'lineprops','r');
title([str{k} ])
l=l+1;
hold all
xlabel('Time [sec]')
ylabel('Position')

end
mysave(gcf, fullfile(outputPath, 'position'))
fid = fopen(fullfile(outputPath, 'stats.txt'),'w');
fprintf(fid, 'Traveled distance variability (std/mean): %f\n', traveledDistanceVariability);
fprintf(fid, 'Traveled distance variability (std/mean) success: %f\n', traveledDistanceVariability1);
fprintf(fid, 'Traveled distance variability (std/mean) failure: %f\n', traveledDistanceVariability0);
fprintf(fid, 'Ttest: is traveled distance shorter on success than failure? p=%2.2f\n', ptraveledDistance);
fprintf(fid, '--------------------------------------\n');

fprintf(fid, 'Position x variability (std/mean): %f\n', overallvariability(1));
fprintf(fid, 'Position x success variability (std/mean): %f\n', variability1(1));
fprintf(fid, 'Position x failure variability (std/mean): %f\n', variability0(1));

fprintf(fid, '--------------------------------------\n');
fprintf(fid, 'Position y variability (std/mean): %f\n', overallvariability(2));
fprintf(fid, 'Position y success variability (std/mean): %f\n', variability1(2));
fprintf(fid, 'Position y failure variability (std/mean): %f\n', variability0(2));

fprintf(fid, '--------------------------------------\n');
fprintf(fid, 'Position z variability (std/mean): %f\n', overallvariability(3));
fprintf(fid, 'Position z success variability (std/mean): %f\n', variability1(3));
fprintf(fid, 'Position z failure variability (std/mean): %f\n', variability0(3));
fprintf(fid, '--------------------------------------\n');

% fprintf(fid, 'Variability of vel x: %f\n', velVariability(1));
% fprintf(fid, 'Variability of vel y: %f\n', velVariability(2));
% fprintf(fid, 'Variability of vel z: %f\n', velVariability(3));
fprintf(fid, 'Angular Vel xy - mean: %f\n', abs(angulaVelMeanxy));
fprintf(fid, 'Angular Vel xy - std: %f\n', angulaVelstdxy);
fprintf(fid, 'Angular Vel xy - confidence interval: %f\n', (angularVelConfxy(1)-angulaVelMeanxy));
fprintf(fid, 'Angular Vel xy - variability (std/mean): %f\n', angulaVelstdxy/abs(angulaVelMeanxy));
fprintf(fid, 'Ttest: is Angular Vel along xy smaller on success than failure? p=%2.2f\n', pangulaVelxy);
fprintf(fid, '--------------------------------------\n');

fprintf(fid, 'Angular Vel xz - mean: %f\n', abs(angulaVelMeanxz));
fprintf(fid, 'Angular Vel xz - std: %f\n', angulaVelstdxz);
fprintf(fid, 'Angular Vel xz - confidence interval: %f\n', (angularVelConfxz(1)-angulaVelMeanxz));
fprintf(fid, 'Angular Vel xz - variability (std/mean): %f\n', angulaVelstdxz/abs(angulaVelMeanxz));
fprintf(fid, 'Ttest: is Angular Vel along xz smaller on success than failure? p=%2.2f\n', pangulaVelxz);



 fclose(fid);
% % figure,l=1;
% % for k=1:3
% % subplot(3,2,l)
% % l=l+1;
% % plot(t, stdTraj1(k,:)./meanTraj1(k,:),'b')
% % xlabel('Time [sec]')
% % ylabel('std/mean')
% % title(str{k})
% % subplot(3,2,l)
% % l=l+1;
% % plot(t, stdTraj0(k,:)./meanTraj0(k,:),'r');
% % xlabel('Time [sec]')
% % ylabel('std/mean')
% % title(str{k})
% % 
% % end
% % figure;plot3(stdTraj1(1,:)./meanTraj1(1,:),stdTraj1(2,:)./meanTraj1(2,:),stdTraj1(3,:)./meanTraj1(3,:),'b');
% % hold all;plot3(stdTraj0(1,:)./meanTraj0(1,:),stdTraj0(2,:)./meanTraj0(2,:),stdTraj0(3,:)./meanTraj0(3,:),'r');
% % legend({'Success','failure'},'Location','Best')
% % mysave(gcf, fullfile(outputPath, 'coefficientVariation'))
% 
% 
% binsN=20;
% for k=1:size(TrajAll_nan,1)
%     v=TrajAll_nan(k,:,:);
%     m = nanmean(v(:));
%     s=nanstd(v(:));
%     
% bins(:,k) = linspace(m-3*s, m+3*s, binsN);
% end
% binsCenters = (bins(1:end-1,:)+bins(2:end,:))/2;
% 
% H = zeros(binsN-1, binsN-1, binsN-1);
% for t=1:size(TrajAll,2)
%      for T=1:size(TrajAll,3)   
%         coordnts = TrajAll_nan(:, t,T);
%         if any(isnan(coordnts)) 
%             continue;
%         else
%             for ci=1:length(coordnts)
%                 if coordnts(ci) < binsCenters(1,ci) || coordnts(ci) > binsCenters(end,ci)
%                     continue;
%                 end
%             end
%         end
%         for ci=1:length(coordnts)
% i(ci)=findClosestDouble(coordnts(ci), binsCenters(:,ci));
%         end
% H(i(1),i(2),i(3),1) = H(i(1),i(2),i(3)) + 1;
%      end
% end
% [X,Y,Z] = meshgrid(binsCenters(:,1),binsCenters(:,2),binsCenters(:,3));
% inds = find(H~=0);
% 
% figure;
% subplot(2,2,1);
% plotEmbeddingWithColors([X(inds) Y(inds) Z(inds)], H(inds));
% hold all;plot3(meanTraj(1,:),meanTraj(2,:),meanTraj(3,:),'LineWidth',3,'Color','k');
% subplot(2,2,2);imagesc(binsCenters(:,1),binsCenters(:,2),mean(H,3));
% set(gca,'YDir','normal')
% hold all;plot3(meanTraj(1,:),meanTraj(2,:),meanTraj(3,:),'LineWidth',3,'Color','k');
% subplot(2,2,3);plot3(reshape(TrajAll(1,:,:),1,[]),reshape(TrajAll(2,:,:),1,[]),reshape(TrajAll(3,:,:),1,[]),'.');
% hold all;plot3(meanTraj(1,:),meanTraj(2,:),meanTraj(3,:),'LineWidth',3,'Color','k');
% 
% subplot(2,2,4);
% for T=1:size(TrajAll_nan,3)
%     if sum(BehaveData.traj.data(5, 800:1200, T)>.9)/400 > 0.98 &&  sum(BehaveData.traj.data(6, 800:1200, T)>.9)/400 > 0.98
%     plot3(squeeze(TrajAll_nan(1,:,T))',squeeze(TrajAll(2,:,T))',squeeze(TrajAll(3,:,T))','b-');
%     hold all;
%     end
% end
% hold all;plot3(meanTraj(1,:),meanTraj(2,:),meanTraj(3,:),'LineWidth',3,'Color','k');
% mysave(gcf,fullfile(outputPath, 'Stats'))
% 
% 
% 
% % figure;imagesc(bins(:,1),bins(:,2), H);
% % set(gca,'YDir','normal')
% coordntsstart = nanmean(TrajAll(1:2, 1,:),3);
% coordntsEND = nanmean(TrajAll(1:2, end,:),3);
% 
%  covstatestart = cov(squeeze(TrajAll(1:2, 1, :))','omitrows'  );   
%         for ci=1:length(coordntsstart)
% istart(ci)=findClosestDouble(coordntsstart(ci), binsCenters(:,ci));
% iend(ci)=findClosestDouble(coordntsEND(ci), binsCenters(:,ci));
%         end
% % r = sqrt(mean([covstatestart(1,1),covstatestart(2,2,1)]));
% % viscircles(coordnts',r,'Color','w')
% % hold all;plot(coordntsstart(1), coordntsstart(2), 'wo');
% % 
% % hold all;plot(coordntsEND(1), coordntsEND(2), 'wo');
% 
% 
% 
% 
% 
% actionval=zeros(binsN-1,binsN-1,8);
% for T=1:size(TrajAll,3)
% for t=1:size(TrajAll,2)-1
%    loc = loc2bins(TrajAll(:,t, T), binsCenters);   
%    nextloc = loc2bins(TrajAll(:,t+1, T), binsCenters);
%    if isempty(nextloc)||isempty(loc)
%        continue;
%    end
%        
%     right = nextloc(1)-loc(1);
% up =  nextloc(2)-loc(2);
% if right==0 && up == 0
%      continue; 
% elseif right==0 && up > 0
%     action = 1;
% elseif right > 0 && up  > 0
%     action = 2;
% elseif right > 0 && up == 0
%     action = 3;
% elseif right > 0 && up<0
%     action = 4;
% elseif right==0 && up<0
%     action = 5;
% elseif right<0 && up<0
%     action = 6;
% elseif right<0 && up == 0
%     action = 7;
% elseif right<0 && up  > 0
%     action = 8;
% end
% actionval(loc(1),loc(2),action)=...
% actionval(loc(1),loc(2),action)+1;
% end
% end
% 
% locs = loc2bins(mean(TrajAll(:,1,:),3), binsCenters);
% locend = loc2bins(mean(TrajAll(:,end,:),3), binsCenters);  
% actionval=actionval+eps;
% for i=1:size(actionval,1)
%     for j=1:size(actionval,2)
%         actionval(i,j,:) = actionval(i,j,:)/(sum(actionval(i,j,:))+eps);
%     end
% end
% amindic = BehaveData.atmouth01.indicator;
% [Tam,tam] = find(amindic>0);
% timaging = linspace(0,generalProperty.Duration, size(amindic,2));
% jj=timaging(tam)>generalProperty.traj3D_startTime & timaging(tam)<generalProperty.traj3D_endTime; 
% tam=tam(jj);
% Tam=Tam(jj);
% ttraj = linspace(generalProperty.traj3D_startTime,generalProperty.traj3D_endTime, size(TrajAll,2));
% for jj=1:length(tam)
%     i = findClosestDouble(ttraj,timaging(tam(jj)));
%     goal(1,jj) =  TrajAll(1, i,   Tam(jj));
%     goal(2,jj) =  TrajAll(2, i,   Tam(jj));
%     goal(3,jj) =  TrajAll(3, i,   Tam(jj));
% end
% 
% goalmean= nanmean(goal,2);
% goalstd= nanstd(goal,[],2);
% takeinds1 = goal(1,:)<goalmean(1)+goalstd(1)*3 & goal(2,:)<goalmean(2)+goalstd(2)*3&goal(3,:)<goalmean(3)+goalstd(3)*3;
% takeinds2 = goal(1,:)>goalmean(1)-goalstd(1)*3 & goal(2,:)>goalmean(2)-goalstd(2)*3&goal(3,:)>goalmean(3)-goalstd(3)*3;
% takeinds=takeinds1&takeinds2;
% 
% goalfinal = mean(goal(:,takeinds),2);
% goalloc = loc2bins(goalfinal, binsCenters);  
% 
% H = zeros(binsN-1, binsN-1, 1);
% for t=1:size(TrajAll,2)
%      for T=1:size(TrajAll,3)   
%         coordnts = TrajAll(1:2, t,T);
%         for ci=1:length(coordnts)
% i(ci)=findClosestDouble(coordnts(ci), binsCenters(:,ci));
%         end
% H(i(1),i(2),1) = H(i(1),i(2),1) + 1;
%      end
% end
% H=H/sum(H(:));
% entropEmpiric1 = sum(sum(H.*sum(actionval.*log(actionval),3)));
%  [records iterationCount, Q] = QLearning_Maze_Walk_HB(locs(1), locs(2), goalloc(1),goalloc(2),actionval);
% Q=(Q>0).*Q+eps;
% for ii=1:size(Q,1)
%     for jj=1:size(Q,2)
%         Q(ii,jj,:) = Q(ii,jj,:)/sum(Q(ii,jj,:));
%     end
% end
%  entropEmpiric2 = sum(sum(H.*sum(Q.*log((Q>0).*Q+eps),3)));
% for ii=1:size(Q,1)
%     for jj=1:size(Q,2)
%          [~, polQ(ii,jj)] =max(Q(ii,jj,:),[],3);
%           [~, polE(ii,jj)] =max(actionval(ii,jj,:),[],3);
%     end
% end 
%  
%  figure,bar(iterationCount)
%  title(['Actions Through Learning, Overall: ' num2str(sum(iterationCount))]);
%  xlabel('Iteration');ylabel('# Actions');
% mysave(gcf,fullfile(outputPath, 'ActionsThroughLearning'))
% meanA = mean(iterationCount);
% 
% 
% for ii=1:size(records,2)
%     for jj=1:size(records,3)
%         if records(1,ii,jj)>0 && records(2,ii,jj)>0
%     posrecords(1,ii,jj) = binsCenters(records(1,ii,jj),1);
%     posrecords(2,ii,jj) = binsCenters(records(2,ii,jj),2);
%         end
%     end
% end
% figure;
% imagesc(binsCenters(:,1), binsCenters(:,2),H);
%     set(gca,'YDir','normal');
%         hold all;
% 
%     plot(mean(TrajAll(1,1,:),3), mean(TrajAll(2,1,:),3), 'wo');
%     plot(goalfinal(1),goalfinal(2), 'w*');
% k=1
%     ii=find(posrecords(1,:,k)==0,1);
%     if isempty(ii)
%         plot(posrecords(1,:,k), posrecords(2,:,k),'.-k')
%     else
%         
%         plot(posrecords(1,1:ii-1,k),posrecords(2,1:ii-1,k),'.-k');
%     end
%      k= size(records,3)
%          ii=find(posrecords(1,:,k)==0,1);
% 
%       if isempty(ii)
%         plot(posrecords(1,:,k), posrecords(2,:,k),'.-w')
%     else
%         
%         plot(posrecords(1,1:ii-1,k),posrecords(2,1:ii-1,k),'.-w');
%     end
% 
%  title('Locations Probabilities, Black - first trajectory, White - last')
% mysave(gcf,fullfile(outputPath, 'LearnedTraj'))
% fprintf(fid, 'Averaged actions: %f\n', meanA);
%  fprintf(fid,'Entropy - empiric = %f\n', entropEmpiric1)
%  fprintf(fid,'Entropy - learned = %f\n', entropEmpiric2)
 


%  fclose(fid);


