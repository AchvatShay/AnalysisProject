function  [chanceLevel, tmid, SVMsingle, trialsNum] = slidingWinAccSN(X, resfile, ...
    labels, winstSec, winendSec, foldsnum, islin, tendTrial)

t = linspace(0,tendTrial, size(X,2));

tmid = (winendSec + winstSec)/2;
rng('default');
randinds = randperm(length(labels));
randLabels = labels(randinds);
trialsNum = size(X, 3);

b=hist(labels,unique(labels));
chanceLevel=max(b./sum(b));
%% wins
if exist(resfile,'file')
    load(resfile);
else
    SVMsingle.raw.acc.mean=[];
end


for win_i = size(SVMsingle.raw.acc.mean,2)+1:length(winstSec)
    t1=tic;
    
    clc;
    disp('---------------------');
    disp(win_i);
    
    
    Xwin = X(:,t >= winstSec(win_i) & t <= winendSec(win_i),:);
    rawX=squeeze(mean(Xwin,2))';
    if isempty(SVMsingle.raw.acc.mean) ||  size(SVMsingle.raw.acc.mean, 2) < win_i
        for nr_i  =1:size(rawX, 2)
            [ACC, ACCrand] = ...
                svmClassifyAndRand(rawX(:, nr_i), labels, randLabels, foldsnum, '', islin, false);
            SVMsingle.raw.acc.mean(nr_i,win_i) = ACC.mean;
            SVMsingle.raw.accrand.mean(nr_i,win_i)= ACCrand.mean;
            SVMsingle.raw.acc.std(nr_i,win_i) = ACC.std;
            SVMsingle.raw.accrand.std(nr_i,win_i)= ACCrand.std;            
        end
    end
    
    
    clc;
    disp('---------------------');
    disp(win_i);
    save(resfile,'chanceLevel', 'tmid', 'SVMsingle', 'trialsNum');
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

