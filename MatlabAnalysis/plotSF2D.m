% this is an older version with suc\fail hard coded. please use the newer
% one with dynamic labels
function l = plotSF2D(ax, embedding, labs, labelsFontSz, legendLoc)
if ~exist('labelsFontSz','var')
    labelsFontSz = 14;
end
dim = size(embedding,2);
if isempty(ax)
    ax = figure;
end
switch dim
    case 2
        scatter(embedding(labs==1,1)  ,embedding(labs==1,2),'ro', 'MarkerFaceColor','r');
        hold all;
        scatter(embedding(labs==0,1)  ,embedding(labs==0,2),'bo', 'MarkerFaceColor','b');
        xlabel('\psi_1', 'FontSize', labelsFontSz), ylabel('\psi_2', 'FontSize', labelsFontSz);
        %         title([method ' Embedding Along Trials']);
        l=legend('Failure','Success', 'Location',legendLoc);
    case 3
        scatter3(embedding(labs==1,1)  ,embedding(labs==1,2),embedding(labs==1,3),'ro', 'MarkerFaceColor','r');
        hold all;
        scatter3(embedding(labs==0,1)  ,embedding(labs==0,2),embedding(labs==0,3), 'MarkerFaceColor','b');
        xlabel('\psi_1'), ylabel('\psi_2', 'FontSize', labelsFontSz), zlabel('\psi_3', 'FontSize', labelsFontSz);
        %         title([method ' Embedding Along Trials']);
        l=legend('Failure','Success',  'Location',legendLoc);
    otherwise
        error('Not implemented yet');
end
set(gca, 'Box','off');
set(l, 'FontSize',labelsFontSz);
a=get(gcf,'Children');
for ai=1:length(a)
    if strcmp(a(ai).Type, 'Axes')
        setAxisFontSz(a(ai), generalProperty.visualization_labelsFontSize);
    end
end