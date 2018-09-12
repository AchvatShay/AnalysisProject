clear;
tpalist{1}= getfiles('C:\Users\Hadas\Dropbox\biomedData\PT3\3_13_18\3_13_18_1', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\PT3Analysis\3_13_18\Analysis\svmAccuracy');

% tpalist{2}= getfiles('C:\Users\Hadas\Dropbox\biomedData\PT3\3_28_18\3_28_18_1', ...
%     'C:\Users\Hadas\Dropbox\Results9_9_17\PT3Analysis\3_28_18\Analysis\svmAccuracy');
tpalist{2}= getfiles('C:\Users\Hadas\Dropbox\biomedData\PT3\4_11_18\4_11_18_1', ...
    'C:\Users\Hadas\Dropbox\Results9_9_17\PT3Analysis\4_11_18\Analysis\svmAccuracy');
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

outputPath = 'C:\Users\Hadas\Dropbox\Results9_9_17\PT3Analysis\All\Analysis\svmAccuracy';
mkNewFolder(outputPath);

runAnalysis(outputPath, xmlfile, tpalistAll, 'svmAccuracy');


