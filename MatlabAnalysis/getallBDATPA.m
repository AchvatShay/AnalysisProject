function BdaTpaList = getallBDATPA(pth, files)
% files = {'2_21_17\2_21_17_1','2_22_17/2_22_17_1' '4_2_17/4_2_17_1'  '2_27_17/2_27_17_1stAndThird' '3_1_17/3_1_17_1' ...
%              '2_23_17\2_23_17_1_1stAndThird'};
%    pth = 'C:\Users\Hadas\Dropbox\biomedData\Den6';
  L=[];  
l=1;
n=1;
for f=1:length(files)
list=dir(fullfile(pth, files{f}, '*.mat'));
for k=1:length(list)
    if ~isempty(strfind(list(k).name, 'TPA'))
        BdaTpaList(l).TPA = fullfile(list(k).folder, list(k).name);
        l=l+1;
    end
    if ~isempty(strfind(list(k).name, 'BDA'))
        BdaTpaList(n).BDA  = fullfile(list(k).folder, list(k).name);
        n=n+1;
    end
    

end
% L(end+1) = (length(TPAlist))
end
disp(diff(L))