function  [chanceLevel, tmid, accSVM, accRandSVM, confMat] = slidingWinAcc(X, resfile, ...
    labels, winstSec, winendSec, foldsnum, islin, tendTrial)

t = linspace(0,tendTrial, size(X,2));

tmid = (winendSec + winstSec)/2;
rng('default');
randinds = randperm(length(labels));
randLabels = labels(randinds);

%% wins
if exist(resfile,'file')
    load(resfile);
else
    accSVM.raw.mean=[];accRandSVM.raw.mean=[]; 
end

b=hist(labels,unique(labels));
chanceLevel=max(b./sum(b));

for win_i = length(accSVM.raw.mean)+1:length(winstSec)
    t1=tic;
    
    clc;
    disp('---------------------');
    disp(win_i);
    

    Xwin = X(:,t >= winstSec(win_i) & t <= winendSec(win_i),:);  
    rawX=squeeze(mean(Xwin,2))';
    if isempty(accSVM.raw) ||  length(accSVM.raw.mean) < win_i       
        [ ACC, ACCrand, ~, ~, confMat(:, :, win_i), ~, ~, ~, ~, SVMModel] = ...
            svmClassifyAndRand(rawX, labels, randLabels, foldsnum, '', islin, false);
        [accSVM.raw, accRandSVM.raw] = setStats(ACC, ACCrand, win_i, accSVM.raw, accRandSVM.raw);
    end
   
    clc;
    disp('---------------------');
    disp(win_i);    
    save(resfile,'chanceLevel', 'tmid','accSVM','accRandSVM', 'confMat');    
end

end


function [accSVM, accRandSVM] = setStats(ACC, ACCrand, win_i, accSVM, accRandSVM)
accSVM.mean(win_i) = ACC.mean;
accSVM.std(win_i) = ACC.std;
accSVM.accv(:, win_i) = ACC.acc_v;
% raw rand
accRandSVM.mean(win_i) = ACCrand.mean;
accRandSVM.std(win_i) = ACCrand.std;
accRandSVM.accv(:, win_i) = ACCrand.acc_v;
end

