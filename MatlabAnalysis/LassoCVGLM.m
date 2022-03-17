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

minval = min([btr; bte]);
btr1 = btr - 10*minval;

% glmval = fitglm(Atr, btr, 'Distribution', distr, 'Link', invfunc);
% y1 = predict(glmval, Ate);
% y1 = predict(glmval, Atr);
if isempty(lam) || isnan(lam)
    [~,FitInfo1] = lassoglm(Atr,btr1,distr,'CV',foldsNum,  'NumLambda',10,'Standardize',1, 'LambdaRatio',1e-4,'MaxIter', 1e3, 'Options', statset('UseParallel',true));
    lam = FitInfo1.Lambda(FitInfo1.IndexMinDeviance);
end
[x,sFitInfo1] = lassoglm(Atr,btr1,distr,'Lambda',lam,'Standardize',1);


x0 = sFitInfo1.Intercept;
yhattr = predictGLM(x, x0, Atr, minval, invfunc);
% coef1 = [x0; x];

% yhattr = glmval(coef1,Atr,invfunc);
% maxval = max(10, 3*median(yhattr));
% 
% yhattr(yhattr>maxval) = 0;
meanYtr = mean(btr);
R2Tr = nanmean((yhattr - meanYtr).^2)/var(btr);
corrcoef_tr = corr(yhattr, btr);
MSEtr = mean(yhattr-btr)^2;

yhatte = predictGLM(x, x0, Ate, minval, invfunc);

% yhatte = glmval(coef1,Ate,invfunc);
% maxval = max(10, 3*median(yhatte));
% yhatte(yhatte>maxval) = 0;
R2Te = nanmean((yhatte - meanYtr).^2)/var(bte);
% corrcoef_te = corr(yhatte, bte);
% MSEte = mean(yhatte-bte)^2;
% %
% 
% % alternative calculation:
% R2Tr_ = max(0,1-mean((btr-yhattr).^2)/var(btr));
% R2Te_ = max(0,1-mean((bte-yhatte).^2)/var(bte));



