function [selfBymaster, self] = findSelfByMasterOrderResults(selfResults, index_events, masterResults, imagingData)
    self_eventName = selfResults{index_events}.eventName;
    self_table = selfResults{index_events}.table;
    self_meanDat = selfResults{index_events}.meanData;
    for i_master = 1:length(masterResults.results)
        if (strcmp(masterResults.results{i_master}.eventName, self_eventName))
            master_table = masterResults.results{i_master}.table;
            selfBymasterIndex = 1;
            for neuronesIndex = 1:size(master_table,1)
                master_neuronName = master_table{neuronesIndex, 2};
                selfIndexNeuronName = find(self_table{:, 2} == master_neuronName);

                if isempty(selfIndexNeuronName)
                    continue;
                end

                self_neurons_location = imagingData.roiNames(:,1)-master_neuronName==0;
                selfBymaster.meanDat(selfBymasterIndex, :) = self_meanDat(self_neurons_location, :);
                selfBymaster.neuronesNames(selfBymasterIndex) = master_neuronName;
                selfBymaster.selfTiming(selfBymasterIndex) = self_table{selfIndexNeuronName, 4};
                selfBymaster.masterTiming(selfBymasterIndex) = master_table{neuronesIndex, 4};
                selfBymaster.masterLocation(selfBymasterIndex) = master_table{neuronesIndex, 1};
                selfBymaster.selfLocation(selfBymasterIndex) = self_table{selfIndexNeuronName, 1};
                selfBymasterIndex = selfBymasterIndex + 1;
            end

            selfIndex = 1;
            for n_i = 1:size(self_table, 1)
                masterIndexNeuronName = find(master_table{:, 2} == self_table{n_i, 2}, 1);

                if isempty(masterIndexNeuronName)
                    continue;
                end

                self.timing(selfIndex) = self_table{n_i, 4};
                self_neurons_location = imagingData.roiNames(:,1)-self_table{n_i,2}==0;
                self.MeanData(selfIndex, :) = self_meanDat(self_neurons_location, :);
                self.neuronsName(selfIndex) = self_table{n_i,2};
                selfIndex = selfIndex + 1;
            end

            break;
        end
    end
end