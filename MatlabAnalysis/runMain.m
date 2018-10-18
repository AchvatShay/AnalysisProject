% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\D10\8_6_14', ...
%     'restilingD10_8614', [1:32 34:56 58:60]);
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\D10\8_1_14', ...
%     'restilingD10_8114',[1:9 11:12 14:18 21:30]);

tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\D10\8_6_14_21-60', ...
    'C:\Users\Hadas\Dropbox\AnalysisImages9_9_17\8_6_14_21-60');

% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\M26\9_28_17', ...
%     'restilingM26_92817', [1:4 6:52 54:70]);
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\Den7\8_13_17\8_13_17_1', ...
%     'restilingDen7_81317', [1:17 19:52 54:57 59:80]);

% tpalist{2}= main('C:\Users\Hadas\Dropbox\biomedData\Den7\8_7_17\8_7_17_1stAndThird', ...
%     'C:\Users\Hadas\Dropbox\Results9_9_17\Den7Analysis\8_7_17_1stAndThird\Analysis\svmAccuracy');
% 
% tpalist{3}= main('C:\Users\Hadas\Dropbox\biomedData\Den7\8_6_17\8_6_17_1stAndThird', ...
%     'C:\Users\Hadas\Dropbox\Results9_9_17\Den7Analysis\8_6_17_1stAndThird\Analysis\svmAccuracy');
l=1;
for k=1:length(tpalist)
    for m=1:length(tpalist{k})
   tpalistAll(l).TPA =  tpalist{k}(m).TPA;
   tpalistAll(l).BDA =  tpalist{k}(m).BDA;
   l=l+1;
    end
end
xmlfile = 'XmlM26.xml';
runAnalysis('C:\Users\Hadas\Dropbox\Results9_9_17\Den7Analysis\All\Analysis\svmAccuracy', xmlfile, tpalistAll, 'svmAccuracy');


