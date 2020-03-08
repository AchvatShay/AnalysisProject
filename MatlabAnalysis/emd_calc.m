function fval = emd_calc(X, Y)    
    % number and length of feature vectors
    [m, ~] = size(X);
    [n, a] = size(Y);
    
    f = zeros(m, n);
    % ground distance matrix
    for i = 1:m
        for j = 1:n
            f(i, j) = vectorsDist_emd(X(i, 1:a), Y(j, 1:a));
        end
    end
    
    f = f';
    f = f(:);
    
    % inequality constraints
    A1 = zeros(m, m * n);
    A2 = zeros(n, m * n);
    for i = 1:m
        for j = 1:n
            k = j + (i - 1) * n;
            A1(i, k) = 1;
            A2(j, k) = 1;
        end
    end
    
    W1 = ones(m, 1) * (1 ./ m);
    W2 = ones(n, 1) * (1 ./ n);
    
    A = [A1; A2];
    b = [W1; W2];
    
    % equality constraints
    Aeq = ones(m + n, m * n);
    beq = ones(m + n, 1) * min(sum(W1), sum(W2));
    % lower bound
    lb = zeros(1, m * n);
    % linear programming
    [x, fval] = linprog(f, A, b, Aeq, beq, lb);
    fval = fval / sum(x);    
end