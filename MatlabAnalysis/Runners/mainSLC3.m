
dbstop if error
addpath(genpath('..'));
%Den7 8 13 17
BDA_TAPpath='\\192.114.20.192\g\Yael\2pData\Analysis\SLC3\11_19_2015\11192015_1\';
trajectoriesPath = '';
outputpath='\\192.114.20.141\i\Maria_revisions Neuron\Hadas_analysis4revision\SLC3\11_19_2015';

 mkdir(outputpath);
 tpalist{1}= main(BDA_TAPpath, outputpath, [], trajectoriesPath, 'XmlByBoth.xml');


