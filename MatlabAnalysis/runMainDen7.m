clear;
tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\Den7\8_13_17\8_13_17_1', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\Den7Analysis\8_13_17_1\Analysis\svmAccuracy');

tpalist{2}= main('C:\Users\Hadas\Dropbox\biomedData\Den7\8_7_17\8_7_17_1stAndThird', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\Den7Analysis\8_7_17_1stAndThird\Analysis\svmAccuracy');

tpalist{3}= main('C:\Users\Hadas\Dropbox\biomedData\Den7\8_6_17\8_6_17_1stAndThird', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\Den7Analysis\8_6_17_1stAndThird\Analysis\svmAccuracy');
l=1;
for k=1:length(tpalist)
    for m=1:length(tpalist{k})
   tpalistAll(l).TPA =  tpalist{k}(m).TPA;
   tpalistAll(l).BDA =  tpalist{k}(m).BDA;
   l=l+1;
    end
end
xmlfile = 'XmlM26.xml';

outputPath = 'C:\Users\Hadas\Dropbox\Results9_9_17\Den7Analysis\All\Analysis\svmAccuracy';
mkNewFolder(outputPath);

runAnalysis(outputPath, xmlfile, tpalistAll, 'svmAccuracy');


