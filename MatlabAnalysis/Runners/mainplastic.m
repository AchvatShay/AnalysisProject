dbstop if error
addpath(genpath('..'));
%% plastic
BDA_TAPpath = '\\192.114.20.141\i\Hadas_Data\plastic\7_19_18';
trajectoriesPath='';
outputpath = '\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\plastic\7_19_18\';
tpalist{1}= mainHadasPlastic(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlByBothReg.xml', '');
tpalist{1}= mainHadasPlastic(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlByBothFailure.xml', '');
