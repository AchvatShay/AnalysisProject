function rgbColor = colorStr2Rgb(colorStr)

switch lower(colorStr)
    case 'red'
        rgbColor = [256 0 0];
    case 'blue'
        rgbColor = [0 0 256];
    case 'black'
        rgbColor = [0 0 0];
    case 'purpule'
        rgbColor = [128,0,128];
    case 'cyan'
    rgbColor = [0,255,255];
    case 'gray'
        rgbColor = [128,128,128];
    otherwise
        error([colorStr ' is unrecognized color']);
end

rgbColor = rgbColor/256;