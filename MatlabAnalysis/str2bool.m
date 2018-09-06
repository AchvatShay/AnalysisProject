function boolres = str2bool(str)

switch lower(str)
    case 'true'
        boolres = true;
    case 'false'
        boolres = false;
    otherwise
        error('Cannot cast str to boolean value');
end