function plotTimeEmbedding(embedding, t, toneTime,labelsFontSz)

figure;
plotEmbeddingWithColors(embedding(11:end,:), t(11:end), '', 30, labelsFontSz);
view( 15, 43);
a=get(gcf,'Children');
set(a(end),'Position',[0.1121    0.2243    0.6143    0.6483]);
set(a(end-1),'Position',[0.8516    0.1029    0.0476    0.8150]);
hold all;
mvStartInd=findClosestDouble(t,t(11));
 plot3(embedding(mvStartInd,1), embedding(mvStartInd,2), embedding(mvStartInd,3),'ks','MarkerFaceColor','k','MarkerSize',8,...
        'MarkerEdgeColor','k')
leg = {'Trajectory','Start'};


   
if ~isempty(toneTime)
toneTimeind=findClosestDouble(t,toneTime);
    plot3(embedding(toneTimeind,1), embedding(toneTimeind,2),embedding(toneTimeind,3),'ko','MarkerSize',8,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','k')
    
   
    leg = {'Trajectory','Start','Tone'};
end
a=get(gcf,'Children');
setAxisFontSz(a(end), labelsFontSz);
set(a(end-1), 'FontSize', labelsFontSz);
legend(leg,'Location','Best','FontSize', labelsFontSz);

