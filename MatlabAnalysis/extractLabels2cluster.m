function [labels2cluster, clrs] = extractLabels2cluster(labels2clusterXMl)

for c_i = 1:length(labels2clusterXMl.cluster)
    if length(labels2clusterXMl.cluster{c_i}.name) == 1
        labels2cluster{c_i}{1} = labels2clusterXMl.cluster{c_i}.name.Text;
    else
        for name_i = 1:length(labels2clusterXMl.cluster{c_i}.name)
            labels2cluster{c_i}{name_i} = labels2clusterXMl.cluster{c_i}.name{name_i}.Text;
        end
    end
end


for c_i = 1:length(labels2clusterXMl.cluster)
    if length(labels2clusterXMl.cluster{c_i}.color) == 1
        clrs{c_i}{1} = colorStr2Rgb(labels2clusterXMl.cluster{c_i}.color.Text);
    else
        for name_i = 1:length(labels2clusterXMl.cluster{c_i}.color)
            clrs{c_i}{name_i} = colorStr2Rgb(labels2clusterXMl.cluster{c_i}.color{name_i}.Text);
        end
    end
end