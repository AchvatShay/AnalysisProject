function combinds = getCombInds(labelNames, combLabels)
combinds = [];
for n = 1:length(combLabels)
    if ~isempty(find(strcmp(combLabels{n}, labelNames)))
        combinds(end+1) = find(strcmp(combLabels{n}, labelNames));
    end
end
end