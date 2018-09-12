% clear;
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\Den6\2_21_17\2_21_17_1', ...
%     'C:\Users\Hadas\Dropbox\Results9_9_17\Den6Analysis\2_21_17\Analysis\svmAccuracy');
% tpalist{2}= main('C:\Users\Hadas\Dropbox\biomedData\Den6\2_22_17\2_22_17_1', ...
%     'C:\Users\Hadas\Dropbox\Results9_9_17\Den6Analysis\2_22_17\Analysis\svmAccuracy');
tpalist{3}= main('C:\Users\Hadas\Dropbox\biomedData\Den6\2_23_17\2_23_17_1_1stAndThird', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\Den6Analysis\2_23_17_1_1stAndThird\Analysis\svmAccuracy');
tpalist{4}= main('C:\Users\Hadas\Dropbox\biomedData\Den6\2_27_17\2_27_17_1', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\Den6Analysis\2_27_17\Analysis\svmAccuracy');
tpalist{5}= main('C:\Users\Hadas\Dropbox\biomedData\Den6\4_2_17\4_2_17_1', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\Den6Analysis\4_2_17\Analysis\svmAccuracy');
tpalist{6}= main('C:\Users\Hadas\Dropbox\biomedData\Den6\3_1_17\3_1_17_1', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\Den6Analysis\3_1_17\Analysis\svmAccuracy');

MatList={'C:\Users\Hadas\Dropbox\Results9_9_17\Den6Analysis\2_21_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
 'C:\Users\Hadas\Dropbox\Results9_9_17\Den6Analysis\2_22_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
'C:\Users\Hadas\Dropbox\Results9_9_17\Den6Analysis\2_23_17_1_1stAndThird\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
'C:\Users\Hadas\Dropbox\Results9_9_17\Den6Analysis\4_2_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'...
'C:\Users\Hadas\Dropbox\Results9_9_17\Den6Analysis\3_1_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure'};

outputPath='C:\Users\Hadas\Dropbox\Results9_9_17\Den6Analysis\All\PostAnalysis';
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

outputPath = 'C:\Users\Hadas\Dropbox\Results9_9_17\Den6Analysis\All\Analysis\svmAccuracy';
mkNewFolder(outputPath);

runAnalysis(outputPath, xmlfile, tpalistAll, 'svmAccuracy');


