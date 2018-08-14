function [prevcurlabs, fails, sucs] = getLabelsSeq(labsOmissions)
prevcurlabs=sum([labsOmissions(1:end-1) 2*labsOmissions(2:end)],2);
fails(:,1) = zeros(size(labsOmissions));
fails(find(prevcurlabs==2)+1,1) = 1;
sucs(:,1) = zeros(size(labsOmissions));
sucs(find(prevcurlabs==1)+1,1) = 1;
if labsOmissions(1) == 1
    fails(1,1) = 1;
    sucs(1,1) = 0;
else
    fails(1,1) = 0;
    sucs(1,1) = 1;
end
for k=2:3
    filt = filter(ones(1,k), 1, labsOmissions);
fails(:,k) = [0; filt(2:end)==k & filt(1:end-1) == k-1];
filt = filter(ones(1,k), 1, 1-labsOmissions);
sucs(:,k) = [0; filt(2:end)==k & filt(1:end-1) == k-1];
end