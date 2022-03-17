function [x, x0, R2Tr, R2Te, fold_i, nrni, type_i, lam] = LassoCV(Atr, btr, foldsNum, Ate, bte, fold_i, nrni, type_i, ~, ~, lam)
if isempty(lam)
    [B,FitInfo] = lasso(Atr,btr,'CV',foldsNum,  'NumLambda',10);
    lam = FitInfo.Lambda(FitInfo.IndexMinMSE);
else    
    [B,FitInfo] = lasso(Atr,btr,'Lambda',lam);
end

x = B(:, FitInfo.IndexMinMSE);
x0 = FitInfo.Intercept(FitInfo.IndexMinMSE);
meanYtr = mean(btr);
%R2Tr = mean((Atr*x + x0 - mean(btr)).^2)/var(bte);
R2Tr = var(Atr*x + x0)/var(btr);
MSEtr = mean(Atr*x + x0-btr)^2;
corrcoef_tr = corr(Atr*x + x0, btr);

R2Te = var(Ate*x + x0)/var(bte);
% this is what we sould do:
%R2Te = mean((Ate*x + x0 - mean(btr)).^2)/var(bte);
MSEte = mean(Ate*x + x0-bte)^2;
corrcoef_te = corr(Ate*x + x0, bte);


% alternative calculation:
R2Tr_ = max(0,1-mean((btr-(Atr*x + x0)).^2)/var(btr));
R2Te_ = max(0,1-mean((bte-(Ate*x + x0)).^2)/var(bte));

% 
% yhat = Atr*x + x0;
% SST_tr = mean((btr-meanYtr).^2);
% SSR_tr = mean((yhat-meanYtr).^2);
% SSE_tr =  mean((btr - yhat).^2);
% 
% SST = sum(Y-meanY)^2
% SSR = sum(y-meanY)^2
% SSE = sum(Y-y)^2
% 
% 
% SSR_tr/SST_tr
% 1-SSE_tr/SST_tr
% 
% %test
% meanYte = mean(bte);
% yhatte = Ate*x + x0;
% SST_te = mean((bte-meanYte).^2);
% SSR_te = mean((yhatte-meanYte).^2);
% SSE_te =  mean((bte - yhatte).^2);





% b = glmfit(Atr,btr, 'normal');
% x = b(2:end);
% x0 =  b(1);
% var(Ate*b(2:end) + b(1) - bte)/var(bte)
% posindstr = btr>=0;
% 
% 
% 
% idxLambdaMinDeviance = FitInfo.IndexMinMSE;
% B0 = FitInfo.Intercept(idxLambdaMinDeviance);
% coef = [B0; B(:,idxLambdaMinDeviance)];
% yhat = glmval(coef,Atr,'identity');
% R2Tr = 1-var(btr-yhat)/var(btr);
% yhatte = glmval(coef,Ate,'identity');
% R2Te = 1-var(bte-yhatte)/var(bte);

% figure;plot(btr);hold all;plot(yhat);plot(yhat1)
% figure;plot(bte);hold all;plot(yhatte);plot(yhatte1)
