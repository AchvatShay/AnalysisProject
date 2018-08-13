function [lastgrabTimes,atmouthTimes, liftTimes]=getTimesForPlot(prevcurlabs, atmouthTimesV, lastgrabTimesV, lastliftTimesV)
classes = unique(prevcurlabs);
for c=1:length(classes)
    if isempty(atmouthTimesV) || all(isinf(atmouthTimesV(prevcurlabs==classes(c)))) || all(isnan(atmouthTimesV(prevcurlabs==classes(c))))
        atmouthTimes.mean(c)=nan;atmouthTimes.std(c)=nan;atmouthTimes.count(c)=nan;
    else
        atmouthTimes.mean(c) = (meannonan(atmouthTimesV(prevcurlabs==classes(c))));
        atmouthTimes.std(c) = (stdnonan(atmouthTimesV(prevcurlabs==classes(c))));
        atmouthTimes.count(c) = sum(~isnan(atmouthTimesV(prevcurlabs==classes(c)))& ~isinf(atmouthTimesV(prevcurlabs==classes(c))));
    end
    if isempty(lastgrabTimesV) || all(isinf(lastgrabTimesV(prevcurlabs==classes(c)))) || all(isnan(lastgrabTimesV(prevcurlabs==classes(c))))
        lastgrabTimes.mean(c)=nan;lastgrabTimes.std(c)=nan;lastgrabTimes.count(c)=nan;
    else
        lastgrabTimes.mean(c) = (meannonan(lastgrabTimesV(prevcurlabs==classes(c))));
        lastgrabTimes.std(c) = (stdnonan(lastgrabTimesV(prevcurlabs==classes(c))));
        lastgrabTimes.count(c) = sum(~isnan(lastgrabTimesV(prevcurlabs==classes(c)))& ~isinf(lastgrabTimesV(prevcurlabs==classes(c))));
    end
    if  isempty(lastliftTimesV) || all(isinf(lastliftTimesV(prevcurlabs==classes(c)))) || all(isnan(lastliftTimesV(prevcurlabs==classes(c))))
        liftTimes.mean(c)=nan;liftTimes.std(c)=nan;liftTimes.count(c)=nan;
    else
        liftTimes.mean(c) = (meannonan(lastliftTimesV(prevcurlabs==classes(c))));
        liftTimes.std(c) = (stdnonan(lastliftTimesV(prevcurlabs==classes(c))));
        liftTimes.count(c) = sum(~isnan(lastliftTimesV(prevcurlabs==classes(c)))& ~isinf(lastliftTimesV(prevcurlabs==classes(c))));
    end
end
