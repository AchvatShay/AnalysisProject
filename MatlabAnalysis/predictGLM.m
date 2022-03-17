function yhat = predictGLM(x, x0, X, min_y, invfunc)

coef1 = [x0; x];

yhat = glmval(coef1,X,invfunc)+10*min_y;
maxval = max(3*median(yhat), 100);
yhat(yhat>maxval) = nan;