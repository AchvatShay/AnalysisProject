dbstop if error
addpath(genpath('..'));
try
% M27 1 8 18
trajectoriesPath='D:\Maria\Layer 2-3\Videos\M27\1_8_18';
BDA_TAPpath ='D:\Maria\Layer 2-3\Analysis\M27\1_8_18';
 outputpath = 'I:\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer23\M27_1_8_18';
 mkdir(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlByBoth20.xml');
end
try
% M27 1 18 18
trajectoriesPath='D:\Maria\Layer 2-3\Videos\M27\1_18_18';
BDA_TAPpath ='D:\Maria\Layer 2-3\Analysis\M27\1_18_18';
 outputpath = 'I:\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer23\M27_1_18_1';
 mkdir(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlByBoth20.xml');
end
try

% M27 1 10 18
trajectoriesPath='D:\Maria\Layer 2-3\Videos\M27\1_10_18';
BDA_TAPpath ='D:\Maria\Layer 2-3\Analysis\M27\1_10_18';
 outputpath = 'I:\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer23\M27_1_10_1';
 mkdir(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlByBoth20.xml');
end
try
 
% M27 1 3 18
trajectoriesPath='D:\Maria\Layer 2-3\Videos\M27\1_3_18';
BDA_TAPpath ='D:\Maria\Layer 2-3\Analysis\M27\1_3_18';
 outputpath = 'I:\Maria_revisions Neuron\Hadas_analysis4revision\orofacial_glm\layer23\M27_1_3_17';
 mkdir(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlByBoth.xml');
end
return;
% M27 12 31 17
trajectoriesPath='D:\Maria\Layer 2-3\Videos\M27\12_31_17';
BDA_TAPpath ='D:\Maria\Layer 2-3\Analysis\M27\12_31_17';
 outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\M27_12_31_17Hist_3segs_regressionWithFacemap';
 mkdir(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlByBoth.xml');

%% M26 10 1 17

BDA_TAPpath = 'D:\Maria\Layer 2-3\Analysis\M26\10_1_17';
 trajectoriesPath = 'D:\Maria\Layer 2-3\Videos\M26\10_1_17';
 outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\M26_10117Hist_3segs_regressionWithFacemap';
 movpath='c';
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlByBoth.xml', '');


 
%% D54 10_25_17
outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\hadas\glmAnalysisRes\D54_10_25_17Hist_3segs_regressionWithFacemap';

trajectoriesPath='D:\Maria\Layer 2-3\Videos\D54\10_25_17';
BDA_TAPpath= 'D:\Maria\Layer 2-3\Analysis\D54\10_25_17';
 mkdir(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlBothAMwithSF_D_20_tone4.xml');

%% M26 9 24 17

BDA_TAPpath = 'D:\Maria\Layer 2-3\Analysis\M26\9_24_17';
 trajectoriesPath = 'D:\Maria\Layer 2-3\Videos\M26\9_24_17';
 outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\M24_92817Hist_3segs_regressionWithFacemap';
 movpath='c';
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlByBoth.xml', '');

%% M144
BDS_TAPpath = 'I:\Maria_revisions Neuron\Analysis\M14\4_21_14_51-70';
trajectoriesPath = '';
 outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\M14_4_21_15_51_70';
 movpath='c';
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlByBoth.xml', '');

 %% M26 9 28 17

BDA_TAPpath = 'D:\Maria\Layer 2-3\Analysis\M26\9_28_17';
 trajectoriesPath = 'D:\Maria\Layer 2-3\Videos\M26\9_28_17';
 outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\M26_92817Hist_3segs_regressionWithFacemap';
 movpath='c';
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlByBoth.xml', '');

%% M30 8_5_18
outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\hadas\glmAnalysisRes\M30_8_5_18';

trajectoriesPath = '\\192.114.21.62\g\Shahar\Videos\M30\2018-08-05';
BDA_TAPpath = '\\192.114.20.42\e\shahar\Analysis\M30\8_5_18';
 mkdir(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF.xml');

%% Den 6 2_23_17_1
outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\hadas\glmAnalysisRes\Den6_2_23_17';

trajectoriesPath = '\\192.114.20.42\e\shahar\Videos\Den6\2017-02-23';
BDA_TAPpath = '\\192.114.21.62\f\shahar\Dropbox (Technion Dropbox)\Shahar\success- failure project\PT neurons\Den6\2_23_17\2_23_17_1\2_23_17_1_1-35';
 mkdir(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF.xml');



%% D54 1_18_18
outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\hadas\glmAnalysisRes\D54_1_18_18';

trajectoriesPath='D:\Maria\Layer 2-3\Videos\D54\1_18_18';
BDA_TAPpath= 'D:\Maria\Layer 2-3\Analysis\D54\1_18_18';
 mkdir(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF_D_30_tone8.xml');

%% PT3 5_29_18
outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\hadas\glmAnalysisRes\PT3_5_29_18';

trajectoriesPath='\\192.114.21.62\g\Shahar\Videos\PT3\2018-05-29';
BDA_TAPpath= '\\192.114.21.62\f\shahar\Dropbox (Technion Dropbox)\Shahar\success- failure project\PT neurons\PT3\5_29_18\5_29_18_1';
 mkdir(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF_D_30_tone4.xml');


 
%% D10 7_23_14_36-80
outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\hadas\glmAnalysisRes\D10_7_23_14_36-80';
trajectoriesPath = 'D:\Maria\Layer 2-3\Videos\D10\7_23_14_36-80';
BDA_TAPpath ='D:\Maria\Layer 2-3\Analysis\D10\7_23_14_36-80';
 mkdir(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF_D10.xml');


%% 7_23_14_11-35
% outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\hadas\glmAnalysisRes\7_23_14_11-35';
% trajectoriesPath='D:\Maria\Layer 2-3\Videos\D10\7_23_14_1-35';
% BDA_TAPpath='D:\Maria\Layer 2-3\Analysis\D10\7_23_14_1-35';
%  mkdir(outputpath);
%  tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF_D10.xml');

%% D10 8 1 14
outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\hadas\glmAnalysisRes\D10_8_1_14';
trajectoriesPath = 'D:\Maria\Layer 2-3\Videos\D10\8_1_14';
BDA_TAPpath ='D:\Maria\Layer 2-3\Analysis\D10\8_1_14';
 mkdir(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF_D10.xml');

%% D10 8 6 14
outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\hadas\glmAnalysisRes\D10_8_6_14';
trajectoriesPath = 'D:\Maria\Layer 2-3\Videos\D10\8_6_14_1-20';
BDA_TAPpath ='D:\Maria\Layer 2-3\Analysis\D10\8_6_14_1-20';
 mkdir(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF_D10.xml');


%  
% %% M26 9 24 17
% % trajectoriesPath='D:\Maria\Layer 2-3\Videos\M26\9_24_17';
% % BDA_TAPpath ='D:\Maria\Layer 2-3\Analysis\M26\9_24_17';
% %  outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\M26_9_24_17Hist';
% %  mkdir(outputpath);
% %  tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF.xml');
% 
% % M27 1 3 17
% trajectoriesPath='D:\Maria\Layer 2-3\Videos\M27\1_3_18';
% BDA_TAPpath ='D:\Maria\Layer 2-3\Analysis\M27\1_3_18';
%  outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\M27_1_3_18Hist';
%  mkdir(outputpath);
%  tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF.xml');
% 
%  
% % %% Den 6 2 22 17
% % trajectoriesPath='\\192.114.20.42\e\shahar\Videos\Den6\2017-02-22\2017-02-22-1';
% % BDA_TAPpath ='\\192.114.21.62\f\shahar\Dropbox (Technion Dropbox)\Shahar\success- failure project\PT neurons\Den6\2_22_17\2_22_17_1';
% %  outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\Den6_2_22_17Hist';
% %  mkNewFolder(outputpath);
% %  tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF.xml');
% %  
% %  
trajectoriesPath='\\192.114.20.42\g\shahar\TwoPhotonExp\Videos\Den7\2017-08-13';
BDA_TAPpath ='\\192.114.20.42\g\shahar\TwoPhotonExp\Analysis\Den7\8_13_17\8_13_17_1';
 outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\Den7_81317Hist';
 mkNewFolder(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF.xml');

% %  
% % BDA_TAPpath = 'D:\Maria\Layer 2-3\Analysis\D54\8_23_17';
% %  trajectoriesPath='D:\Maria\Layer 2-3\Videos\D54\8_23_17';
% %  outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\D54_82317Hist';
% %  mkNewFolder(outputpath);
% %  tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF.xml');
% %  
% % % BDA_TAPpath = 'D:\Maria\Layer 2-3\Analysis\D10\8_1_14';
% % %  trajectoriesPath = '';
% % %  outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\D108114';
% % %  tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF.xml');
% % 
% % %  
% %  BDA_TAPpath = 'D:\Maria\Layer 2-3\Analysis\M26\9_28_17';
% %  trajectoriesPath = 'D:\Maria\Layer 2-3\Videos\M26\9_28_17';
% %  outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\M26_92817AtMouthAlonePostvelacWithTone';
% %  tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBoth.xml');
% % %  
% %  outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\M26_92817athmouthwithreward';
% %  tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlBothathmouthwithreward.xml');
%  
%  BDA_TAPpath = '\\192.114.20.42\e\shahar\Analysis\PT3\3_13_18\3_13_18_1';
%  trajectoriesPath = 'C:\Users\Jackie.MEDICINE\Dropbox (Technion Dropbox)\AnalysisResultsShay\Hadas\trajectoriesData\PT3\3_13_18_1';
%  outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\PT3_31318Hist_3segs';
%  tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF.xml');
%  
%   outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\PT3_31318withreward';
%  tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlBothathmouthwithreward.xml');
%  
% 
%  
%  
%   BDA_TAPpath = '\\192.114.20.42\e\shahar\Analysis\PT3\3_13_18\3_13_18_1';
%  trajectoriesPath = 'C:\Users\Jackie.MEDICINE\Dropbox (Technion Dropbox)\AnalysisResultsShay\Hadas\trajectoriesData\PT3\3_13_18_1';
%  outputpath = 'C:\Users\Jackie.MEDICINE\Desktop\MatlabAnalysisResults\PT3_31318AtMouthWithSFPostvelacWithTone';
%  tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, '../XmlBothAMwithSF.xml');
% 
%  
