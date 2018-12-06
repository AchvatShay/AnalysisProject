function [norm_val, x_val, y_val, z_val] = calcDistCreateVectores(matrix_embedding, start_loop, end_loop)
    norm_val = 0;
    x_val = 0;
    y_val = 0;
    z_val = 0;
    for index_norm = start_loop : end_loop
         vector_norm_A = [matrix_embedding(index_norm, 1), matrix_embedding(index_norm, 2), matrix_embedding(index_norm, 3)];
         vector_norm_B = [matrix_embedding(index_norm + 1, 1), matrix_embedding(index_norm + 1, 2), matrix_embedding(index_norm + 1, 3)];
         norm_val = norm_val + norm(vector_norm_B - vector_norm_A);
         x_val = x_val + abs(matrix_embedding(index_norm + 1, 1) - matrix_embedding(index_norm, 1));
         y_val = y_val + abs(matrix_embedding(index_norm + 1, 2) - matrix_embedding(index_norm, 2));
         z_val = z_val + abs(matrix_embedding(index_norm + 1, 3) - matrix_embedding(index_norm, 3));
    end
end