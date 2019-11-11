function C = getConfidenceInterval(m, s, n, perc)

SEM = s/sqrt(n);               % Standard Error
ts = tinv([ perc 1-perc],(n)-1);      % T-Score


C = bsxfun(@plus, ts'*SEM(:).',m(:)') ;
if any(isnan(C))
%     disp(1)
end