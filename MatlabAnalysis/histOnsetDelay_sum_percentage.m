function histOnsetDelay_sum_percentage(bins, bins_values_percentage, outputPath, eventName, sfstr, firstlaststr)
    sum_percentage_before_event = sum(bins_values_percentage(bins < 0 & bins >= -0.2));
    sum_percentage_after_event_halfsec = sum(bins_values_percentage(bins > 0 & bins <= 0.5));
    sum_percentage_after_event_sec = sum(bins_values_percentage(bins > 0 & bins <= 1));

    filenameExcel = fullfile(outputPath, 'histOnsetDelay_sum_percentage.xlsx');

    if isfile(filenameExcel)
        [~, ~, excelDataRaw] = xlsread(filenameExcel);
    else
        [~, ~, excelDataRaw] = xlsread('tamplateDelay2EventsHis.xlsx');
    end
    lastrow = size(excelDataRaw,1);

    [~, currentCol] = find(strcmp(excelDataRaw, 'event'));
    excelDataRaw{lastrow+1, currentCol} = eventName;

    [~, currentCol] = find(strcmp(excelDataRaw, 'trails'));
    excelDataRaw{lastrow+1, currentCol} = sfstr;

    [~, currentCol] = find(strcmp(excelDataRaw, 'First\Last'));
    excelDataRaw{lastrow+1, currentCol} = firstlaststr;

    [~, currentCol] = find(strcmp(excelDataRaw, '% of neurons -0.2-0.5 sec'));
    excelDataRaw{lastrow+1, currentCol} = sum_percentage_before_event + sum_percentage_after_event_halfsec;

    [~, currentCol] = find(strcmp(excelDataRaw, '% of neurons -0.2-1 sec'));
    excelDataRaw{lastrow+1, currentCol} = sum_percentage_before_event + sum_percentage_after_event_sec;

    [~, currentCol] = find(strcmp(excelDataRaw, '% of neurons -0.2-0 sec'));
    excelDataRaw{lastrow+1, currentCol} = sum_percentage_before_event;

    [~, currentCol] = find(strcmp(excelDataRaw, '% of neurons 0-1 sec'));
    excelDataRaw{lastrow+1, currentCol} = sum_percentage_after_event_sec;

    [~, currentCol] = find(strcmp(excelDataRaw, '% of neurons 0-0.5 sec'));
    excelDataRaw{lastrow+1, currentCol} = sum_percentage_after_event_halfsec;

    xlswrite(filenameExcel,excelDataRaw);
end
