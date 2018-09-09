clear;
tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\M24\5_22_17', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\M24Analysis\5_22_17\Analysis\svmAccuracy');

tpalist{2}= main('C:\Users\Hadas\Dropbox\biomedData\M24\6_12_17', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\M24Analysis\6_12_17\Analysis\svmAccuracy');

tpalist{3}= main('C:\Users\Hadas\Dropbox\biomedData\M24\6_18_17', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\M24Analysis\6_18_17\Analysis\svmAccuracy');

MatList={'C:\Users\Hadas\Dropbox\Results9_9_17\M24Analysis\5_22_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
 'C:\Users\Hadas\Dropbox\Results9_9_17\M24Analysis\6_12_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
'C:\Users\Hadas\Dropbox\Results9_9_17\M24Analysis\6_18_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'};
outputPath='C:\Users\Hadas\Dropbox\Results9_9_17\M24Analysis\All\PostAnalysis';
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

outputPath = 'C:\Users\Hadas\Dropbox\Results9_9_17\M24Analysis\All\Analysis\svmAccuracy';
mkNewFolder(outputPath);

runAnalysis(outputPath, xmlfile, tpalistAll, 'svmAccuracy');


