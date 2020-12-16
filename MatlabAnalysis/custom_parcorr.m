function C = custom_parcorr(data_to_calc)
    N = size(data_to_calc, 1);
    C = nan(N);
    for i=1:N
        for j = i:N
            if i == j
               C(i, j) = 1;
               continue;
            end
            
            x = data_to_calc(i, :);
            y = data_to_calc(j, :);
            z = data_to_calc(setdiff(1:N, [i j]), :);
            C(i, j) = partialcorr(x', y', z'); 
            C(j, i) = C(i, j); 
        end
    end    
end