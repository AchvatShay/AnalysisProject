function [Neurons] = getAllExperimentNeurons(TPAFile)
% get all Neuron names for the TPA file as list

if ~exist(TPAFile, 'file')
    error(['File ' TPAFile ' does not exist']);
end
tpaData = load(TPAFile);
Neurons = zeros(length(tpaData.strROI), 1);
for nr = 1:length(tpaData.strROI)
    Neurons(nr) = extractROIstr(tpaData.strROI{nr}.Name);
end

end