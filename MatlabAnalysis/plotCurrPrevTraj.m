function [f, x,Conf,str, mov]=plotCurrPrevTraj(trajSmooth, prevcurlabs, t, toneTime, firstgrabTimes, lastgrabTimes, labelsFontSz, viewparams)
mov=[];
x=[];Conf=[];str=[];
if length(prevcurlabs) ~= size(trajSmooth,3)
    error('fix it!');
end
[lastgrabTimes, firstgrabTimes, liftTimes]=getTimesForPlot(prevcurlabs, firstgrabTimes, lastgrabTimes, []);


f(1) = figure;
leg = {'S-S','F-S','S-F','F-F'};
leg=leg(intersect(unique(prevcurlabs), 0:3)+1);
clrs = [0 0 1;0 0 1;1 0 0;1 0 0];
if any(isnan(round(firstgrabTimes.mean))) 
    if all(isnan(round(lastgrabTimes.mean)))
        leg = {leg{:} 'Start','Tone'};
    else
        leg = {leg{:} 'Start','Tone','First Grab'};
    end
else
    leg = {leg{:} 'Start','Tone','First Grab', 'Last Grab'};
end
    
    [p, markers] = plotTrajMCMean(trajSmooth, prevcurlabs, 3, leg, ...
    findClosestDouble(t, toneTime),  round(firstgrabTimes.mean), round(lastgrabTimes.mean), labelsFontSz);


for k=1:length(unique(prevcurlabs))
    p(k).Color = clrs(k,:);
    for n=1:size(markers,2)
        if ~isempty(fieldnames(markers(k,n)))
    set(markers(k,n),'MarkerEdgeColor',clrs(k,:));
    markers(k,n).LineWidth=1;
        end
    end
end
grid on;
for j=1:length(unique(prevcurlabs))
    p(j).LineWidth = 3;
end
set(gca, 'Box','off');
if  ~all(viewparams==0)
view(viewparams);
end


f(2) = figure;

clrs = [0 0 1;1 0 0;0 0 1;1 0 0];
 [p, markers] = plotTrajMCMean(trajSmooth, prevcurlabs, 3, leg, ...
    findClosestDouble(t, toneTime), round(firstgrabTimes.mean), round(lastgrabTimes.mean), labelsFontSz);


for k=1:length(unique(prevcurlabs))
    p(k).Color = clrs(k,:);
    for n=1:size(markers,2)
        if ~isempty(fieldnames(markers(k,n)))
    set(markers(k,n),'MarkerEdgeColor',clrs(k,:));
    markers(k,n).LineWidth=1;
        end
    end
end
grid on;
for j=1:length(unique(prevcurlabs))
    p(j).LineWidth = 3;
end
set(gca, 'Box','off');
if  ~all(viewparams==0)
view(viewparams);
end


f(3) = figure;

clrs = [0 0 1;0 1 1;.5 0 .5;1 0 0];
 [p, markers] = plotTrajMCMean(trajSmooth, prevcurlabs, 3, leg, ...
    findClosestDouble(t, toneTime), round(firstgrabTimes.mean), round(lastgrabTimes.mean), labelsFontSz);


for k=1:length(unique(prevcurlabs))
    p(k).Color = clrs(k,:);
    for n=1:size(markers,2)
        if ~isempty(fieldnames(markers(k,n)))
    set(markers(k,n),'MarkerEdgeColor',clrs(k,:));
    markers(k,n).LineWidth=1;
        end
    end
end
grid on;
for j=1:length(unique(prevcurlabs))
    p(j).LineWidth = 3;
end
set(gca, 'Box','off');
if  ~all(viewparams==0)
view(viewparams);
end
% xlimm = get(gca,'XLim');
% ylimm = get(gca,'YLim');
% zlimm = get(gca,'ZLim');

% 
% if nargout == 5
% %%% movie
% classes = unique(prevcurlabs);
% for k=1:length(classes)
%     for d = 1:3
%         if size(squeeze(trajSmooth(d,:,prevcurlabs==classes(k))),1) == 1
%              meanVals(d, :, k) = (squeeze(trajSmooth(d,:,prevcurlabs==classes(k))));
%         else
%     meanVals(d, :, k) = mean(squeeze(trajSmooth(d,:,prevcurlabs==classes(k))),2);
%         end
%     end
% end
% 
%  figure;
% set(gca, 'Box','off');
% if  ~all(viewparams==0)
% view(viewparams);
% end
% grid on;
% a=get(gcf,'Children');
% setAxisFontSz(a(end), labelsFontSz);
% setAxisFontSz(a(end), labelsFontSz);
% xlim(xlimm);ylim(ylimm);zlim(zlimm);grid on;
% 
% xlabel('PC_1', 'FontSize',labelsFontSz);ylabel('PC_2', 'FontSize',labelsFontSz);
% zlabel('PC_3', 'FontSize',labelsFontSz);
% for k=1:length(unique(prevcurlabs))
%     h(k) = animatedline(a, 'Color',clrs(k,:), 'LineWidth',3);
% end
% addpoints(h(1),meanVals(1,1, 1),meanVals(2,1, 1), meanVals(3,1, 1));
% hold all;
% addpoints(h(2),meanVals(1,1, 2),meanVals(2,1, 2), meanVals(3,1, 2));
% addpoints(h(3),meanVals(1,1, 3),meanVals(2,1, 3), meanVals(3,1, 3));
% addpoints(h(4),meanVals(1,1, 4),meanVals(2,1, 4), meanVals(3,1, 4));
% 
% 
%     l=legend('S-S','F-S', 'Location','northeastoutside');
%     set(l, 'FontSize',labelsFontSz);
% for k=1:2
%  plot3(meanVals(1,1,k), meanVals(2,1,k), meanVals(3,1,k),'ks','MarkerFaceColor','k','MarkerSize',12,...
%         'MarkerEdgeColor','k');
%     ha;
% end
% l=legend('S-S','F-S', 'Location','northeastoutside');
%     set(l, 'FontSize',labelsFontSz);
% if  ~all(viewparams==0)
% view(viewparams);
% end
% mov(1) = getframe(gcf);
% frame_i = 2;
% 
% 
% toneind = findClosestDouble( t, toneTime);
% for kb = 2:size(trajSmooth,2)
%         if toneind+1 == kb
%             for k=1:2
%     
%                 plot3(meanVals(1,toneind,k), meanVals(2,toneind,k), meanVals(3,toneind,k),'ko','MarkerSize',12,...
%                     'MarkerEdgeColor','k',...
%                     'MarkerFaceColor','k');
%                 if  ~all(viewparams==0)
% view(viewparams);
% end
%                 l=legend('S-S','F-S', 'Location','northeastoutside');
%     set(l, 'FontSize',labelsFontSz);
%             end
%         end
%     addpoints(h(1),meanVals(1,kb, 1),meanVals(2,kb, 1), meanVals(3,kb, 1));
%     hold all;
%     addpoints(h(2),meanVals(1,kb, 2),meanVals(2,kb, 2), meanVals(3,kb, 2));
%     drawnow;
%     
%     
%     mov(frame_i) = getframe(gcf);
%     frame_i=frame_i+1;
% end
% l=legend({'S-S','F-S','S-F','F-F'}, 'Location','northeastoutside');
%     set(l, 'FontSize',labelsFontSz);
% 
% 
% for k=3:4
%  plot3(meanVals(1,1,k), meanVals(2,1,k), meanVals(3,1,k),'ks','MarkerFaceColor','k','MarkerSize',12,...
%         'MarkerEdgeColor','k');
%     ha;
% end
%  l=legend({'S-S','F-S','S-F','F-F'}, 'Location','northeastoutside');
%     set(l, 'FontSize',labelsFontSz);
% 
% mov(frame_i) = getframe(gcf);
% frame_i=frame_i+1;
% for kb = 2:size(trajSmooth,2)
%         if toneind+1 == kb
%             for k=3:4
%     
%                 plot3(meanVals(1,toneind,k), meanVals(2,toneind,k), meanVals(3,toneind,k),'ko','MarkerSize',12,...
%                     'MarkerEdgeColor','k',...
%                     'MarkerFaceColor','k');
%             end
%             l=legend({'S-S','F-S','S-F','F-F'}, 'Location','northeastoutside');
%     set(l, 'FontSize',labelsFontSz);
% 
%         end
%     addpoints(h(3),meanVals(1,kb, 3),meanVals(2,kb, 3), meanVals(3,kb, 3));
%     hold all;
%     addpoints(h(4),meanVals(1,kb, 4),meanVals(2,kb, 4), meanVals(3,kb, 4));
%     drawnow;
%     
%     
%     mov(frame_i) = getframe(gcf);
%     frame_i=frame_i+1;
% end
% end