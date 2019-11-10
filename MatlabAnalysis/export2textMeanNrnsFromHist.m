function export2textMeanNrnsFromHist(str, filename, chanceLevel,maxbinnum,time2st, time2end, isindicative1, isindicative5, generalProperty )


fid = fopen(filename, 'w');
if ~isempty(chanceLevel)
fprintf(fid, 'chance is: %2.2f\n',chanceLevel);
end
for binsnum = 2:maxbinnum
 count = getIndicativeNrnsMean(isindicative5, 'consecutive', maxbinnum, time2st, time2end);
    fprintf(fid, 'mean %s  nrns  starting from %f to %f with %d consecutive bins and 5 percent confidence: %f\n',...
        str, generalProperty.indicativeNrnsMeanStartTime, generalProperty.indicativeNrnsMeanEndTime, maxbinnum, count);
   count = getIndicativeNrnsMean(isindicative1, 'consecutive', maxbinnum, time2st, time2end);

    fprintf(fid, 'mean %s nrns  starting from %f to %f with %d consecutive bins and 1 percent confidence: %f\n',...
        str, generalProperty.indicativeNrnsMeanStartTime, generalProperty.indicativeNrnsMeanEndTime, maxbinnum, count);
end
for binsnum = 1:maxbinnum
    count = getIndicativeNrnsMean(isindicative5, 'any', binsnum, time2st, time2end);
    fprintf(fid, 'mean %s nrns  starting from %f to %f with any %d bins and 5 percent confidence: %f\n',...
        str, generalProperty.indicativeNrnsMeanStartTime, generalProperty.indicativeNrnsMeanEndTime, binsnum, count);
    
     count = getIndicativeNrnsMean(isindicative1, 'any', binsnum, time2st, time2end);
      fprintf(fid, 'mean %s nrns  starting from %f to %f with any %d bins and 1 percent confidence: %f\n',...
        str, generalProperty.indicativeNrnsMeanStartTime, generalProperty.indicativeNrnsMeanEndTime, binsnum, count);
   end
fclose(fid);