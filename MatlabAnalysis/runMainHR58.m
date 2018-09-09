tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\HR5_8\01_02_18_S', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_8Analysis\01_02_18_S\Analysis\svmAccuracy');

tpalist{2}= main('C:\Users\Hadas\Dropbox\biomedData\HR5_8\01_09_18_S', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_8Analysis\01_09_18_S\Analysis\svmAccuracy');
tpalist{3}= main('C:\Users\Hadas\Dropbox\biomedData\HR5_8\01_11_18_S', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_8Analysis\01_11_18_S\Analysis\svmAccuracy');
tpalist{4}= main('C:\Users\Hadas\Dropbox\biomedData\HR5_8\01_17_18_S', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_8Analysis\01_17_18_S\Analysis\svmAccuracy');
tpalist{5}= main('C:\Users\Hadas\Dropbox\biomedData\HR5_8\01_24_18_S', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_8Analysis\01_24_18_S\Analysis\svmAccuracy');

MatList={'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_8Analysis\01_02_18_S\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
 'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_8Analysis\01_09_18_S\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
 'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_8Analysis\01_11_18_S\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
 'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_8Analysis\01_17_18_S\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_8Analysis\01_24_18_S\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'};

outputPath='C:\Users\Hadas\Dropbox\Results9_9_17\HR5_8Analysis\All\PostAnalysis';
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
close all;
xmlfile = 'XmlM26.xml';

outputPath = 'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_8Analysis\All\Analysis\svmAccuracy';
mkNewFolder(outputPath);

runAnalysis(outputPath, xmlfile, tpalistAll, 'svmAccuracy');


