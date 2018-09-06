function [ dprime, dprimerand] = dPrimeAndRand(X, Y, Yrand)

dprime = getDprime(X,Y);
dprimerand = getDprime(X,Yrand);


end
function dprime = getDprime(X,Y)
labels = unique(Y);
if length(labels) ~= 2
dprime = [];
warning('Dprime is well defined for 2 labels only');
return;
end
meanS = mean(X(Y==labels(1), :));
meanF = mean(X(Y==labels(2), :));

varS = var(X(Y==labels(1), :));
varF = var(X(Y==labels(2), :));
dprime = (meanS-meanF)./sqrt(0.5*(varS+varF));
end
