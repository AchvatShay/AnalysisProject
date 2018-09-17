% this is an older version with suc\fail hard coded. Please use the dynamic
% one
function f=plot2Dtasting(allLabels, expinds, embedding, labelsFontSz)
f=[];
if isfield(allLabels, 'sucrose') && any(allLabels.sucrose)
    successReginds = find(allLabels.failure(expinds) == 0 & allLabels.regular(expinds)==1);
    failReginds    = find(allLabels.failure(expinds) == 1 & allLabels.regular(expinds)==1);
    successSucinds = find(allLabels.failure(expinds) == 0 & allLabels.sucrose(expinds)==1);
    failSucinds    = find(allLabels.failure(expinds) == 1 & allLabels.sucrose(expinds)==1);
    successQuiinds = find(allLabels.failure(expinds) == 0 & allLabels.quinine(expinds)==1);
    failQuiinds    = find(allLabels.failure(expinds) == 1 & allLabels.quinine(expinds)==1);
    
    
    f(1) = figure;
    plot(embedding(successReginds,1)  ,embedding(successReginds,2),'bo', 'MarkerFaceColor','b');
    hold all;
    plot(embedding([successSucinds; successQuiinds],1)  ,embedding([successSucinds; successQuiinds],2),'co', 'MarkerFaceColor','c');
    
    plot(embedding(allLabels.failure(expinds) == 1,1)  ,embedding(allLabels.failure(expinds) == 1,2),'ro', 'MarkerFaceColor','r');
    legend('Success-Regular Pellet','Success-Socrose+Quinine','Failure', 'Location','BestOutside');
    xlabel('\psi_1', 'FontSize',labelsFontSz), ylabel('\psi_2', 'FontSize',labelsFontSz);
    set(gca, 'Box','off');
    f(2) = figure;
    plot(embedding(successReginds,1)  ,embedding(successReginds,2),'bo', 'MarkerFaceColor','b');
    hold all;
    plot(embedding([successSucinds],1)  ,embedding([successSucinds],2),'co');
    hold all;
    plot(embedding([successQuiinds],1)  ,embedding([successQuiinds],2),'co', 'MarkerFaceColor','c');
    
    plot(embedding(allLabels.failure(expinds) == 1,1)  ,embedding(allLabels.failure(expinds) == 1,2),'ro','MarkerFaceColor','r');
    l=legend('Success-Regular','Success-Socrose','Success-Quinine','Failure', 'Location','BestOutside');xlabel('\psi_1'), ylabel('\psi_2');
    set(gca, 'Box','off');
    set(l, 'FontSize',labelsFontSz);
end
a=get(gcf,'Children');
setAxisFontSz(a(end), labelsFontSz);
