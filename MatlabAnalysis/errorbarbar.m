function errorbarbar(t,x,C, xlabels, labelsFntSz)

figure;
c=bar(t,x , 'FaceColor',[192,192,192]/255);
if ~isempty(xlabels)
set(gca,'XTickLabel',xlabels,'FontSize',labelsFntSz);
else
  set(gca,'FontSize',labelsFntSz);
end  
for k=1:length(t)
    line([t(k) t(k)], C(:,k),'LineWidth',3, 'Color',[47,79,79]/255)
% line([t(k) t(k)], [x(k)-e(k), x(k)+e(k)], 'Color','r','LineWidth',3)
end
set(gca, 'Box','off');
