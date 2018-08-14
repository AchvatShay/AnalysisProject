function m = meannonan(x, dim)
if ~exist('dim', 'var')
    dim = 1;
end
x1=x;
x1(isnan(x1)) = 0;

m = sum(x1,dim)./sum(~isnan(x),dim);

