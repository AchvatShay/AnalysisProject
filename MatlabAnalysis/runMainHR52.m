clear;
tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\HR5_2\03_28_17_S', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_2Analysis\03_28_17_S\Analysis\svmAccuracy');

tpalist{2}= main('C:\Users\Hadas\Dropbox\biomedData\HR5_2\03_30_17_S', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_2Analysis\03_30_17_S\Analysis\svmAccuracy');
tpalist{3}= main('C:\Users\Hadas\Dropbox\biomedData\HR5_2\04_3_17_S', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_2Analysis\04_3_17_S\Analysis\svmAccuracy');

% MatList={'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_2Analysis\03_28_17_S\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
%  'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_2Analysis\03_30_17_S\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
% 'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_2Analysis\04_3_17_S\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'};
% outputPath='C:\Users\Hadas\Dropbox\Results9_9_17\HR5_2Analysis\All\PostAnalysis';
% mkNewFolder(outputPath); 
% runAverageAnalysis(outputPath, 'XmlM26.xml', tpalist{1}(1:10), MatList, 'accuracy');

l=1;
for k=1:length(tpalist)
    for m=1:length(tpalist{k})
   tpalistAll(l).TPA =  tpalist{k}(m).TPA;
   tpalistAll(l).BDA =  tpalist{k}(m).BDA;
   l=l+1;
    end
end
close all
% xmlfile = 'XmlM26.xml';
% 
% outputPath = 'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_2Analysis\All\Analysis\svmAccuracy';
% mkNewFolder(outputPath);
% 
% runAnalysis(outputPath, xmlfile, tpalistAll, 'svmAccuracy');


