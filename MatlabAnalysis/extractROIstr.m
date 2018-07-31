function roiStr = extractROIstr(fullstr)

roiStr=sscanf(fullstr, 'ROI:%d Z:1');
if isempty(roiStr)
    roiStr=sscanf(fullstr, 'ROI:Z:1:%d');
end
if isempty(roiStr)
    roiStr=sscanf(fullstr, 'ROI:Z:2:%d');
end

