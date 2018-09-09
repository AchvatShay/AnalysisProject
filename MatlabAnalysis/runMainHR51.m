clear;
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\HR5_1\02_12_17\02_12_17_S', ...
%     'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_1Analysis\02_12_17\Analysis\svmAccuracy');

% tpalist{2}= main('C:\Users\Hadas\Dropbox\biomedData\HR5_1\02_15_16\02_15_16_S', ...
%     'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_1Analysis\02_15_16\Analysis\svmAccuracy');
% tpalist{3}= main('C:\Users\Hadas\Dropbox\biomedData\HR5_1\02_16_17\02_16_17_S', ...
%     'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_1Analysis\02_16_17\Analysis\svmAccuracy');

% tpalist{4}= main('C:\Users\Hadas\Dropbox\biomedData\HR5_1\02_19_17\02_19_17_S', ...
%     'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_1Analysis\02_19_17\Analysis\svmAccuracy');
tpalist{5}= main('C:\Users\Hadas\Dropbox\biomedData\HR5_1\02_21_17\02_21_17_S', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_1Analysis\02_21_17\Analysis\svmAccuracy');

% MatList={'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_1Analysis\02_12_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
%  'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_1Analysis\02_15_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
% 'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_1Analysis\02_16_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
% 'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_1Analysis\02_19_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
% 'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_1Analysis\02_21_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'};
% 
% outputPath='C:\Users\Hadas\Dropbox\Results9_9_17\HR5_1Analysis\All\PostAnalysis';
% mkNewFolder(outputPath); 
% runAverageAnalysis(outputPath, 'XmlM26.xml', tpalist{1}(1:10), MatList, 'accuracy');

% 
% l=1;
% for k=1:length(tpalist)
%     for m=1:length(tpalist{k})
%    tpalistAll(l).TPA =  tpalist{k}(m).TPA;
%    tpalistAll(l).BDA =  tpalist{k}(m).BDA;
%    l=l+1;
%     end
% end
% xmlfile = 'XmlM26.xml';
% 
% outputPath = 'C:\Users\Hadas\Dropbox\Results9_9_17\HR5_1Analysis\All\Analysis\svmAccuracy';
% mkNewFolder(outputPath);
% 
% runAnalysis(outputPath, xmlfile, tpalistAll, 'svmAccuracy');


