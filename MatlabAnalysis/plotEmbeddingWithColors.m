function plotEmbeddingWithColors(embedding, colorparam_c, title_str, sz, labelsFontSz)

if ~exist('sz','var')
    sz = 30;
end
if ~exist('labelsFontSz','var')
    labelsFontSz=14;
end
color_mat     = colormap('jet');
colorparam_c1 = 1 + floor((length(color_mat)-1) * (colorparam_c - min(colorparam_c)) / (max(colorparam_c) - min(colorparam_c)));
if any(isnan((colorparam_c1)))
    colorparam_c1 = 1:length(colorparam_c);
end
color_mat     = color_mat(colorparam_c1, :);
switch size(embedding, 2)
    case 1
        plot(colorparam_c, embedding, 'o'), %'MarkerEdgeColor', 'k'
        %         title([title_str ' Embedding']);
        xlabel(title_str, 'FontSize',labelsFontSz); ylabel('\psi_1', 'FontSize',labelsFontSz);
        %         colorbar
    case 2
        scatter(embedding(:,1), embedding(:,2), sz, color_mat, 'filled'), %'MarkerEdgeColor', 'k'
        %         title([title_str ' Embedding']);
        xlabel('\psi_1', 'FontSize',labelsFontSz), ylabel('\psi_2', 'FontSize',labelsFontSz);
        zlabel('\psi_3', 'FontSize',labelsFontSz), hold on
        c=colorbar;
    otherwise
        scatter3(embedding(:,1), embedding(:,2), embedding(:,3), sz, colorparam_c, 'Fill');
        c=colorbar;
        set(c,'Location','EastOutside');
        %         title(title_str);
        xlabel('\psi_1', 'FontSize',labelsFontSz);
        ylabel('\psi_2', 'FontSize',labelsFontSz); zlabel('\psi_3', 'FontSize',labelsFontSz);
        
end

if length(unique(unique(colorparam_c))) < 15
    set(c, 'Ticks', linspace(0,1,length(unique(unique(colorparam_c)))))
    set(c, 'TickLabels', unique(colorparam_c))
end
end