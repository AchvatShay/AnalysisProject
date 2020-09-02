function plotTreeWithColors(tree, labels)
color_mat     = colormap('jet');
color_mat = color_mat(8:end-8, :);
colorparam_c1 = 1 + floor((length(color_mat)-1) * (labels - min(labels)) / (max(labels) - min(labels)));
if all(isnan(colorparam_c1))
    color_mat=repmat(color_mat(1,:), size(colorparam_c1,1),1);
else    
color_mat     = color_mat(colorparam_c1, :);
end

nT = length(labels);

treeplot(nodes(tree), '.')
hold on;

[x_layout,y_layout] = treelayout(nodes(tree));

%-- Remove nodes and take only leafs of tree:
x_layout(1 : end - nT) = [];
y_layout(1 : end - nT) = [];
color_mat(1 : end - nT, :) = [];

% scatter(x_layout, y_layout, 50, 1 : length(x_layout), 'fill');
scatter(x_layout, y_layout, 50, color_mat, 'fill');
colormap jet;
c = colorbar;
c.TickLabels=(linspace(min(labels), max(labels), length(c.TickLabels)));

hold off;

end
