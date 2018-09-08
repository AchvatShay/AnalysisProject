function f = myplotConfMat(Ccell, tind, w, labels)
numlabels = size(Ccell{1}, 1); % number of labels

% calculate the percentage accuracies
mat = zeros(size(sum(Ccell{1}(:,:,tind), 1)));
valuesRep = repmat(mat, numlabels,1);
for k=1:length(Ccell)
% confpercent = 100*Ccell{k}(:,:,tind)./sum(sum(Ccell{k}(:,:,tind)));
    confpercent = 100*Ccell{k}(:,:,tind)./repmat(sum(Ccell{k}(:,:,tind), 2),1,numlabels);
    valuesRep = valuesRep + Ccell{k}(:,:,tind);
    C(:,:,k) = w(k)*confpercent;
end
% w=w/sum(w);
Ctot = sum(C, 3)/sum(w);
Ctot(isnan(Ctot))=0;
f = figure;
imagesc(Ctot, [0 100]);
title(sprintf('Accuracy: %.2f%%', 100*trace(Ctot)/sum(Ctot(:))));
ylabel('Output Class'); xlabel('Target Class');

% set the colormap
colormap(flipud(gray));

% Create strings from the matrix values and remove spaces
textStrings = num2str(Ctot(:), '%.1f%%\n');
% textStringsCount = num2str(valuesRep(:), '(%.1f)\n');
% textStrings = strcat(textStrings, textStringsCount);

textStrings = strtrim(cellstr(textStrings));

% Create x and y coordinates for the strings and plot them
[x,y] = meshgrid(1:numlabels);
hStrings = text(x(:),y(:),textStrings(:), ...
    'HorizontalAlignment','center');

% Get the middle value of the color range
midValue = mean(get(gca,'CLim'));

% Choose white or black for the text color of the strings so
% they can be easily seen over the background color
textColors = repmat(Ctot(:) > midValue,1,3);
set(hStrings,{'Color'},num2cell(textColors,2));

% Setting the axis labels
set(gca,'XTick',1:numlabels,...
    'XTickLabel',labels,...
    'YTick',1:numlabels,...
    'YTickLabel',labels,...
    'TickLength',[0 0]);

