function [x, x0, R2Tr, R2Te, fold_i, nrni, type_i, lam] = LassoCVGLM(Atr, btr, foldsNum, Ate, bte, fold_i, nrni, type_i, distr, invfunc, lam)

if ~exist('lam','var')
    lam = [];
end
if ~exist('distr','var')
    distr = 'gamma';
end
if ~exist('invfunc','var')
    invfunc = 'reciprocal';
end
posindstr = btr>=0;

% glmval = fitglm(Atr(posindstr, :), btr(posindstr), 'Distribution', distr, 'Link', invfunc);
% y1 = predict(glmval, Ate(posindste, :));
% y1 = predict(glmval, Atr(posindstr, :));
if isempty(lam)
[~,FitInfo1] = lassoglm(Atr(posindstr, :),btr(posindstr),distr,'CV',foldsNum,  'NumLambda',10,'Standardize',1, 'LambdaRatio',1e-4,'MaxIter', 1e3, 'Options', statset('UseParallel',true));

%[~,FitInfo1] = lassoglm(Atr(posindstr, :),btr(posindstr),distr,'CV',foldsNum,  'NumLambda',10,'Standardize',1, 'LambdaRatio',1e-4,'MaxIter', 1e2);

idxLambda1SEe = FitInfo1.Index1SE;
[x,sFitInfo1] = lassoglm(Atr(posindstr, :),btr(posindstr),distr,'Lambda',FitInfo1.Lambda(idxLambda1SEe),'Standardize',1);
lam = FitInfo1.Lambda(idxLambda1SEe);
else
[x,sFitInfo1] = lassoglm(Atr(posindstr, :),btr(posindstr),distr,'Lambda',lam,'Standardize',1);
end

x0 = sFitInfo1.Intercept;
coef1 = [x0; x];

posindste = bte>0;

yhattr = glmval(coef1,Atr(posindstr,:),invfunc);
meanYtr = mean(btr);
R2Tr = mean((yhattr - meanYtr).^2)/var(btr);
corrcoef_tr = corr(yhattr, btr(posindstr));
MSEtr = mean(yhattr-btr(posindstr))^2;

yhatte = glmval(coef1,Ate(posindste,:),invfunc);
R2Te = mean((yhatte - meanYtr).^2)/var(bte);
corrcoef_te = corr(yhatte, bte(posindste));
MSEte = mean(yhatte-btr(posindste))^2;
% 

% alternative calculation:
R2Tr_ = max(0,1-mean((btr(posindstr)-yhattr).^2)/var(btr(posindstr)));
R2Te_ = max(0,1-mean((bte(posindste)-yhatte).^2)/var(bte(posindste)));



