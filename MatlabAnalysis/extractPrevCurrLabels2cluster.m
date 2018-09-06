function labels2cluster = extractPrevCurrLabels2cluster(labels2clusterXMl)

for c_i = 1:length(labels2clusterXMl.cluster)
    if length(labels2clusterXMl.cluster{c_i}.name) == 1
        labels2cluster{c_i}{1} = labels2clusterXMl.cluster{c_i}.name.Text;
    else
        for name_i = 1:length(labels2clusterXMl.cluster{c_i}.name)
            labels2cluster{c_i}{name_i} = labels2clusterXMl.cluster{c_i}.name{name_i}.Text;
        end
    end
end
