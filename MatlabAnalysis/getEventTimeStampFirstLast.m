function [tstampFirst, tstampLast] = getEventTimeStampFirstLast(labelsBehave, timeinds2consider)


labelsBehave(~timeinds2consider,:) = 0;
tstampFirst.start = nan(size(labelsBehave,2),1);
% tstampFirst.end = nan(size(labelsBehave,2),1);
for triali = 1:size(labelsBehave, 2)
    ind=find(labelsBehave(:, triali), 1, 'first');
    if ~isempty(ind)
        tstampFirst.start(triali) = ind;
    else
        continue;
    end
%     inds=find(labelsBehave(:, triali));
%     ind=find(diff(inds)>1,1,'first');
%     if ~isempty(ind)
%         tstampFirst.end(triali) =  inds(ind);
%     end
end


tstampLast.start = nan(size(labelsBehave,2),1);
% tstampLast.end = nan(size(labelsBehave,2),1);
for triali = 1:size(labelsBehave, 2)
    ind=find(labelsBehave(:, triali), 1, 'last');
    if ~isempty(ind)
        tstampLast.end(triali) = ind;
    else
        continue;
    end
    inds=find(labelsBehave(:, triali));
    ind=find(diff(inds)>1,1,'last');
    if ~isempty(ind)
        tstampLast.start(triali) =  inds(ind+1);
    else
         tstampLast.start(triali) = tstampFirst.start(triali);
%          tstampLast.end(triali) = tstampFirst.end(triali);
    end
end