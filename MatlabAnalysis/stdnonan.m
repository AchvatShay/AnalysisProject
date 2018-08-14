function s = stdnonan(x, dim)
if ~exist('dim', 'var')
    dim = 1;
end
x1=x;
x1(isnan(x1)) = 0;
m = sum(x1,dim)./sum(~isnan(x),dim);

r2 = sum((x1).^2,dim)./sum(~isnan(x),dim);

s = sqrt(abs(r2-m.^2));


