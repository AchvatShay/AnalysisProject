function timelist=str2timestamplist(Xmllist)


if length(Xmllist.time_stamp) == 1

timelist = str2double(Xmllist.time_stamp.Text);
else
for ti = 1:length(Xmllist.time_stamp)
timelist(ti) = str2double(Xmllist.time_stamp{ti}.Text);
end
end