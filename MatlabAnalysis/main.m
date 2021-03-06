function BdaTpaList = main(pth, outputPath, Trials2keep, pthTraj, xmlfile, movpath)
if ~exist('xmlfile','var')
xmlfile = 'XmlBoth.xml';
end
if ~exist('movpath','var')
    movpath=[];
end
% xmlfile = 'XmlD54.xml';
% xmlfile = 'XmlPT3_1nrn.xml';
% xmlfile = 'XmlPT3_nonrns.xml';




mkNewFolder(outputPath);

filesTPA = dir([pth, '\TPA*.mat']);
filesBDA = dir([pth, '\BDA*.mat']);
% filesTRK = dir([pth, '\*.trk']);

if nargin == 2 || isempty(Trials2keep)
    Trials2keep = 1:length(filesTPA);
end
l = 1;
for k=Trials2keep
    BdaTpaList(l).TPA = fullfile(pth, filesTPA(k).name);
    BdaTpaList(l).BDA = fullfile(pth, filesBDA(k).name);
    l = l + 1;
end
% if length(filesTRK) == length(filesTPA)
%     l = 1;
%     for k=Trials2keep
%         ind = strfind(filesTRK(k).name, '-');
%         filename = [filesTRK(k).name(1:ind(end)-1) '-'  num2str(k) '.trk'];
%         BdaTpaList(l).trk = fullfile(filesTRK(1).folder, filename);
%         l = l + 1;
%     end
% end
try
if exist('pthTraj', 'var') && ~isempty(pthTraj)
filesEPC = dir([pthTraj]);
if length(filesEPC) > 2 && length(filesEPC) >= length(filesTPA) + 2
    l = 1;
    for k=Trials2keep
        filecsv = dir(fullfile(pthTraj,  filesEPC(k+2).name, '*.csv'));
        BdaTpaList(l).traj = fullfile(pthTraj, filesEPC(k+2).name, filecsv(1).name);
        l = l + 1;
    end
end
end
catch
    BdaTpaList = getTrajFiles(BdaTpaList, pthTraj, '');

end
if ~isempty(movpath)
    dirlist = dir(movpath);
    l=1;
    for diri = 3:length(dirlist)
        currfile = fullfile(movpath, dirlist(diri).name, 'movie_comb.avi');
        if exist(currfile, 'file')
            BdaTpaList(l).mov = currfile;
        else
          BdaTpaList(l).mov = '';
        end
        l = l +1;
    end
end
%runAnalysis(outputPath, xmlfile, BdaTpaList, 'SingleNeuronAnalysis');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'glmAnalysis');

%runAnalysis(outputPath, xmlfile, BdaTpaList, 'behaveMovieAnalysis');

% runAnalysis(outputPath, xmlfile, BdaTpaList, 'SingleNeuronSignificantAnalysis');
%

return;

runAnalysis(outputPath, xmlfile, BdaTpaList, 'pcaTrajectories');

runAnalysis(outputPath, xmlfile, BdaTpaList, 'delay2events');

% runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMap2D');
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'Pca2D');
runAnalysis(outputPath, xmlfile, BdaTpaList, 'svmAccuracy');

% runAnalysis(outputPath, xmlfile, BdaTpaList, 'tiling');
% runAnalysis(o`utputPath, xmlfile, BdaTpaList, 'tilingNrnsTrials');
%
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotAllNrnsAcrossTrials');
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');
%
% close all;
return;
% runAnalysis(outputPath, xmlfile, BdaTpaList, 'diffMapTrajectories');
runAverageAnalysis(outputPath, xmlfile, BdaTpaList(1:10), MatList, 'accuracy');

 








% this is just an example to see how to extract the neurons' names from a
% tpa file
[Neurons] = getAllExperimentNeurons(BdaTpaList(1).TPA);
% just checking if this code works with 1 neuron to plot or none
xmlfile = 'XmlPT3_1nrn.xml';
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');

xmlfile = 'XmlPT3_nonrns.xml';
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');
% now for more than 1 neuron
xmlfile = 'XmlPT3.xml';
runAnalysis(outputPath, xmlfile, BdaTpaList, 'plotSingleNrnAcrossTrials');

% this is just an example to see how to extract the events' labels from a
% bda file
eventsLabels = getAllExperimentLabels({BdaTpaList.BDA});

% running analysis averaging
analysisName = 'accuracy';
% generalProperty = Experiment(xmlfile);
