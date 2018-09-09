clear;
tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\M30\7_30_18', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\M30Analysis\7_30_18\Analysis\svmAccuracy');

tpalist{2}= main('C:\Users\Hadas\Dropbox\biomedData\M30\8_7_18', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\M30Analysis\8_7_18\Analysis\svmAccuracy');
MatList={'C:\Users\Hadas\Dropbox\Results9_9_17\M30Analysis\7_30_18\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
 'C:\Users\Hadas\Dropbox\Results9_9_17\M30Analysis\7_30_18\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'};

outputPath='C:\Users\Hadas\Dropbox\Results9_9_17\M30Analysis\All\PostAnalysis';
mkNewFolder(outputPath); 
runAverageAnalysis(outputPath, 'XmlM26.xml', tpalist{1}(1:10), MatList, 'accuracy');

l=1;
for k=1:length(tpalist)
    for m=1:length(tpalist{k})
   tpalistAll(l).TPA =  tpalist{k}(m).TPA;
   tpalistAll(l).BDA =  tpalist{k}(m).BDA;
   l=l+1;
    end
end
xmlfile = 'XmlM26.xml';

outputPath = 'C:\Users\Hadas\Dropbox\Results9_9_17\M30Analysis\All\Analysis\svmAccuracy';
mkNewFolder(outputPath);

runAnalysis(outputPath, xmlfile, tpalistAll, 'svmAccuracy');
close all;

