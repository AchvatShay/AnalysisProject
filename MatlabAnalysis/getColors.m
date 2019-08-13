function clrs = getColors(strColors)

for k = 1:length(strColors)
    switch strColors{k}
        case 'red'
            clrs(k, :) = [1 0 0];
        case 'dark_red'
            clrs(k, :) = [0.584 0 0.165];
        case 'blue'
            clrs(k, :) = [0 0 1];
        case 'dark_blue'
            clrs(k, :) = [0 0 0.35];
        case 'light_pink'
            clrs(k, :) = [0.945 0.604 0.71];
        case 'dark_pink'
            clrs(k, :) = [0.945 0 0.71];
        case 'light_green'
            clrs(k, :) = [0 0.816 0.302];
        case 'dark_green'
            clrs(k, :) = [0 0.35 0.165];
        case 'light_orange'
            clrs(k, :) = [1 0.765 0.302];
        case 'dark_orange'
            clrs(k, :) = [1 0.502 0];
        case 'light_brown'
            clrs(k, :) = [0.71 0.4 0.114];
        case 'dark_brown'
            clrs(k, :) = [0.4 0.263 0.13];
        case 'light_grey'
            clrs(k, :) = [0.52 0.52 0.51];
        case 'dark_grey'
            clrs(k, :) = [0.243 0.243 0.243];
        case 'cyan'
            clrs(k, :) = [0 1 1];
        case 'purple'
            clrs(k, :) = [.5 0 .5];
        case 'light_purple'
            clrs(k, :) = [0.7 0.52 0.753];
        case 'yellow'
            clrs(k, :) = [1 1 0];
        case 'dark_yellow'
            clrs(k, :) = [0.8 0.8 0];
        case 'green_atogram'
            clrs(k, :) = [118, 255, 3] ./ 255;
        case 'blue_atogram'
            clrs(k, :) = [41, 98, 255] ./ 255;
        otherwise
            error('Unfamiliar color');
    end
end
