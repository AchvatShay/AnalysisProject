function grabCount = getGrabCounts(BehaveData, startingAt, endingAt, frameRate)
grabCount=zeros(size(BehaveData.grab_01.indicator,1), 1);

NAMES = fieldnames(BehaveData);
for k=1:length(NAMES)
    if ~isempty(strfind(NAMES{k}, 'grab'))
        grabindname(k) = str2double(NAMES{k}(length('grab_')+1:end));
    end
end
graneventsinds = find(grabindname~=0);
for j=1:length(graneventsinds)
    for i=1:length(BehaveData.(NAMES{graneventsinds(j)}).eventTimeStamps)
        currtimestamps = BehaveData.(NAMES{graneventsinds(j)}).eventTimeStamps{i};
       if isempty(currtimestamps)
           continue;
       end
        if min(currtimestamps/frameRate) > startingAt && max(currtimestamps/frameRate) < endingAt 
            grabCount(i) = grabCount(i) + 1;
        end
    end
end
if all(grabCount==0)
    grabCount=nan;
end