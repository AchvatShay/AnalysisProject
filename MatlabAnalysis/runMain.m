% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\PT3\3_13_18\3_13_18_1', ...
%      'restilingPT3_3_13_18');
 

 
 
 
tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\M26\9_28_17', ...
    'resssM26_92817', []);

tpalist{1}= main('C:\Users\Hadas\Dropbox (Personal)\biomedData\M27\2_8_18', ...
     'M27_2818', []);

% tpalist{1}= main('C:\Users\Hadas\Dropbox (Personal)\biomedData\M27\2_8_18','M27');

% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\Den6\2_23_17\2_23_17_1', ...
%      'restilingDen6_2_23_17',[2:18 20 26:30 82:86 93]);
% 
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\Den6\2_27_17\2_27_17_1stAndThird', ...
%      'restilingDen6_2_27_17');
% 
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\Den6\2_21_17\2_21_17_1', ...
%      'restilingDen6_2_21_17',[1:31 33 34 ]);

% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\Den6\4_2_17\4_2_17_1', ...
%      'restilingDen6_4_2_17', [1:16 18:27 29:38]);
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\GS5\8_10_17', ...
%      'restilingGS5_8_10_17',1:30);

% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\GS5\8_9_17', ...
%      'restilingGS5_8_9_17');
% 

% 
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\Den6\3_1_17\3_1_17_1', ...
%      'restilingDen6_3117');
% 
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\M24\6_12_17', ...
%      'restilingM24_61217', [1 2 5 10 11 13:21 23:25 27:29 33 34 35 37 39:49]);
% 
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\M27\1_3_18', ...
%      'restilingM27_1318');
% 
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\D54\1_23_18', ...
%      'restilingD54_12318taste');
% 
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\D10\7_23_14_1-35', ...
%      'restilingD10_72314ctrl', [1 2 4:7 9:22]);
% 
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\D19\8_6_14_1-20', ...
%      'restilingD10_8414', 1:20);
% 
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\D10\8_4_14', ...
%      'restilingD10_8414', 1:60);
% 
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\D10\8_6_14', ...
%      'restilingD10_8614ctrl', 1:20);
% 
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\D10\8_6_14', ...
%      'restilingD10_8614', [1:32 34:56 58:60]);
%   tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\D10\8_6_14', ...
%      'restilingD10_8614', [1:11 13:16 18:25 27 34 36:56 58:60]);
% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\D10\8_1_14', ...
%     'restilingD10_8114',[1:9 11:12 14:18 21:30]);

% tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\D10\8_6_14_21-60', ...
%     'C:\Users\Hadas\Dropbox\AnalysisImages9_9_17\8_6_14_21-60');

tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\M26\9_28_17', ...
    'restilingM26_92817', [1:4 6:52 54:70]);
tpalist{1}= main('C:\Users\Hadas\Dropbox\biomedData\Den7\8_13_17\8_13_17_1', ...
    'restilingDen7_81317', [1:17 19:52 54:57 59:80]);

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


