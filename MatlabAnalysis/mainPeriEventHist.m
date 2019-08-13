clear;
%% user input
outputPath = 'E:\Dropbox (Technion Dropbox)\';    % path to the results directory
xlsFile = 'Runners\periEventAnalysisForJackie_PT.xlsx';  % path to the input excel file
sheet_name ='Example2';         % working sheet in the excel file
xmlfile = 'Runners\XmlByBoth.xml';             % xml file

%% begining of code
mkNewFolder(outputPath);
[NUM,TXT,RAW]=xlsread(xlsFile, sheet_name);
mkNewFolder('temp');
trialssum = 0;
for pi = 2:size(TXT,1)
    BdaTpaList = [];
    % loading bda tpa
    pth = TXT{pi, 1};
    filesTPA = dir([pth, '\TPA*.mat']);
    filesBDA = dir([pth, '\BDA*.mat']);
    l=1;
    for k=1:length(filesTPA)
        BdaTpaList(l).TPA = fullfile(filesTPA(k).folder, filesTPA(k).name);
        BdaTpaList(l).BDA = fullfile(filesBDA(k).folder, filesBDA(k).name);
        l = l + 1;
    end
    
    generalProperty = Experiment(xmlfile);
    
    [imagingData, BehaveData] = loadData(BdaTpaList, generalProperty);
    
    
    
    if isnumeric(RAW{pi,2})
        indicativePerc = num2str(RAW{pi,2});
        outputPathIndic = fullfile(outputPath, RAW{pi,4},RAW{pi,5});
        mkNewFolder(outputPathIndic);
        isindicative = getIndicatives(outputPathIndic, generalProperty, imagingData, BehaveData, str2double(indicativePerc)/100);
        nrnsList = find(sum(isindicative, 2)>0);
        N(pi) = length(nrnsList);
    else
        nrnsList=1:size(imagingData.samples,1);
        nrnsList = eval(['nrnsList(' TXT{pi,3} ')']);
        N(pi) = length(nrnsList);
    end
    if ~isempty(nrnsList)
    imagingData.roiNames=imagingData.roiNames(nrnsList);
    imagingData.samples=imagingData.samples(nrnsList, :, :);
    trialssum = trialssum + size(imagingData.samples, 3); 
    [res{pi}, strTrials, Events2plotDelay]=getPeriEventHist( generalProperty, imagingData, BehaveData);
    end
end
labelsFontSz = generalProperty.visualization_labelsFontSize;
for si = 1:length(strTrials)
    for evi = 1:length(Events2plotDelay)
        resAll.first{evi, si}=[];resAll.last{evi, si}=[];
        for pi=2:size(TXT,1)
            if N(pi)>0 && ~isempty(res{pi}.first{evi, si}  )
                resAll.first{evi, si} = cat(1, resAll.first{evi, si}, res{pi}.first{evi, si}(:));
            end
            if N(pi)>0 && ~isempty(res{pi}.last{evi, si}  )
                resAll.last{evi, si} = cat(1, resAll.last{evi, si}, res{pi}.last{evi, si}(:));
            end
        end
        if ~isempty(resAll.first{evi, si})
            
            figure;
            [hist2onset,bins] = hist(resAll.first{evi, si},100);
            
            bins_values_percentage = hist2onset/sum(N)*100;
            bar(bins, bins_values_percentage, 'FaceColor',[192,192,192]/255);
            
            histOnsetDelay_sum_percentage(bins, bins_values_percentage, outputPath, Events2plotDelay{evi}, strTrials{si}, 'First');
            
            xlabel('Delay Time [sec]', 'FontSize',labelsFontSz);
            ylabel('Neurons [%]', 'FontSize',labelsFontSz);
            set(gca, 'Box','off');
            a=get(gcf,'Children');
            setAxisFontSz(a(end), labelsFontSz);
            suptitle(['Delay to Onset, '  ' First ' Events2plotDelay{evi} ' ' strTrials{si}]);
            placeToneTime(0,2);
            c=get(gca,'Children');
            set(c(1),'Color','r')
            mysave(gcf, fullfile(outputPath, ['histOnsetDelayFirst'  Events2plotDelay{evi} strTrials{si} '_allnrns']));
        end
        if ~isempty(resAll.last{evi, si})
            figure;
            [hist2onset,bins] = hist(resAll.last{evi, si},100);
            
            bins_values_percentage = hist2onset/sum(N)*100;
            bar(bins, bins_values_percentage, 'FaceColor',[192,192,192]/255);
            
            histOnsetDelay_sum_percentage(bins, bins_values_percentage, outputPath, Events2plotDelay{evi}, strTrials{si}, 'Last');
            
            xlabel('Delay Time [sec]', 'FontSize',labelsFontSz);
            ylabel('Neurons [%]', 'FontSize',labelsFontSz);
            set(gca, 'Box','off');
            a=get(gcf,'Children');
            setAxisFontSz(a(end), labelsFontSz);
            suptitle(['Delay to Onset, '  ' Last ' Events2plotDelay{evi} ' ' strTrials{si}]);
            placeToneTime(0,2);
            c=get(gca,'Children');
            set(c(1),'Color','r')
            mysave(gcf, fullfile(outputPath, ['histOnsetDelayLast'  Events2plotDelay{evi} strTrials{si} '_allnrns']));
        end
        
    end
end