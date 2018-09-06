function [prevcurlabs, prevcurrLUT] = getPrevCurrLabels(labels, labelsLUT)

classes = (unique(labels));
classesNum = length(classes);
for ci = 1:classesNum
thisprevcur(:,ci) = sum([(labels(1:end-1)==classes(ci))*2^(2*ci) (labels(2:end)==classes(ci))*2^(2*ci+1)],2);
end
prevcurlabs=sum(thisprevcur,2);
l=1;
for n = 1:classesNum
for k=1:classesNum
    prevcurrLUTnumeric(n, k) = 2^(2*k) +2^(2*n+1);
prevcurrLUT(l).num = prevcurrLUTnumeric(n, k);
prevcurrLUT(l).name = [ labelsLUT{k} '-'  labelsLUT{n}];
l=l+1;
end
end
% [~, ic ] = sort([prevcurrLUT.num]);


