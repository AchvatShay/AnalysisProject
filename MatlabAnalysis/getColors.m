function clrs = getColors(strColors)

for k = 1:length(strColors)
    switch strColors{k}
        case 'red'
            clrs(k, :) = [1 0 0];
        case 'blue'
            clrs(k, :) = [0 0 1];
        case 'cyan'
            clrs(k, :) = [0 1 1];
        case 'purple'
            clrs(k, :) = [.5 0 .5];
        case 'yellow'
            clrs(k, :) = [1 1 0];
        otherwise
            error('Unfamiliar color');
    end
end
