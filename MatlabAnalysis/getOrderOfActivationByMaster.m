function [kendall_r_order, Pearson_r_order, Spearman_r_order, kendall_r_t, Pearson_r_t, Spearman_r_t] = getOrderOfActivationByMaster(outputPath, generalProperty, imagingData, BehaveData, masterResults)
    selfResults = getOrderOFActivationByData([outputPath , '\getOrderOFActivationByData\'], generalProperty, imagingData, BehaveData);
    for index_events = 1:length(selfResults)
        self_eventName = selfResults{index_events}.eventName;
        self_alignedEventName = selfResults{index_events}.alignedEventName;
        tNew = selfResults{index_events}.time;
        [selfBymaster, self] = findSelfByMasterOrderResults(selfResults, index_events, masterResults, imagingData);
        
        ordermatrix.error = abs(selfBymaster.selfLocation - selfBymaster.masterLocation);
        ordermatrix.std = std(ordermatrix.error);
         
        X_order = [selfBymaster.selfLocation', selfBymaster.masterLocation'];
        [kendall_r_order{index_events}, kendall_p_order] = corr(X_order, 'type', 'kendall');
        [Pearson_r_order{index_events}, Pearson_p_order] = corr(X_order, 'type', 'Pearson');
        [Spearman_r_order{index_events}, Spearman_p_order] = corr(X_order, 'type', 'Spearman');

        X_timing = [self.timing', selfBymaster.masterTiming'];
        [kendall_r_t{index_events}, kendall_p_t] = corr(X_timing, 'type', 'kendall');
        [Pearson_r_t{index_events}, Pearson_p_t] = corr(X_timing, 'type', 'Pearson');
        [Spearman_r_t{index_events}, Spearman_p_t] = corr(X_timing, 'type', 'Spearman');
        
        self_start_p = findClosestDouble(self.timing,generalProperty.pearsonOnlyFromStartTime);
        self_end_p = findClosestDouble(self.timing,generalProperty.pearsonOnlyFromEndTime);
        X_timing_sec = [self.timing(self_start_p:self_end_p)', selfBymaster.masterTiming(self_start_p:self_end_p)'];
        [kendall_r_t_sec{index_events}, kendall_p_t_sec] = corr(X_timing_sec, 'type', 'kendall');
        [Pearson_r_t_sec{index_events}, Pearson_p_t_sec] = corr(X_timing_sec, 'type', 'Pearson');
        [Spearman_r_t_sec{index_events}, Spearman_p_t_sec] = corr(X_timing_sec, 'type', 'Spearman');
        
        
        [~, ~, excelDataRaw] = xlsread('OrderAndTimingTemplate.xlsx');
        
        % Normality assumtion test (Kolmogorov-Smirnov test, H=1 for sig and 0 for non sig)
        [Hx,px] = kstest(selfBymaster.selfLocation'); 
        [Hy,py] = kstest(selfBymaster.masterLocation');
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'Norm test for SEFL :'));
        excelDataRaw{lineIndex, currentCol+1} = Hx;
        excelDataRaw{lineIndex, currentCol+2} = px;
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'Norm test for MASTER :'));
        excelDataRaw{lineIndex, currentCol+1} = Hy;
        excelDataRaw{lineIndex, currentCol+2} = py;
        
        n = length(selfBymaster.selfLocation');
        SE_t= sqrt((1-(Pearson_r_order{index_events}(1,2))^2)/(n-2));
        alphaval = 0.05;
        low_tbased_interaval = Pearson_r_order{index_events}(1,2) - SE_t * abs(tinv(alphaval/2, n-2));
        high_tbased_interaval = Pearson_r_order{index_events}(1,2) + SE_t * abs(tinv(alphaval/2, n-2));
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'confidence_intervals for rh (P)'));
        excelDataRaw{lineIndex, currentCol+1} = Pearson_r_order{index_events}(1,2);
        excelDataRaw{lineIndex, currentCol+2} = [num2str(low_tbased_interaval) '-' num2str(high_tbased_interaval)];
        
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'Pearson-order'));
        excelDataRaw{lineIndex, currentCol+1} = Pearson_r_order{index_events}(1,2);
        excelDataRaw{lineIndex, currentCol+2} = Pearson_p_order(1,2);
        
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'Kendall-order'));
        excelDataRaw{lineIndex, currentCol+1} = kendall_r_order{index_events}(1,2);
        excelDataRaw{lineIndex, currentCol+2} = kendall_p_order(1,2);
        
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'Spearman-order'));
        excelDataRaw{lineIndex, currentCol+1} = Spearman_r_order{index_events}(1,2);
        excelDataRaw{lineIndex, currentCol+2} = Spearman_p_order(1,2);
        
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'std-order'));
        excelDataRaw{lineIndex, currentCol+1} = ordermatrix.std;
        
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'Pearson-timing'));
        excelDataRaw{lineIndex, currentCol+1} = Pearson_r_t{index_events}(1,2);
        excelDataRaw{lineIndex, currentCol+2} = Pearson_p_t(1,2);
        
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'Kendall-timing'));
        excelDataRaw{lineIndex, currentCol+1} = kendall_r_t{index_events}(1,2);
        excelDataRaw{lineIndex, currentCol+2} = kendall_p_t(1,2);
        
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'Spearman-timing'));
        excelDataRaw{lineIndex, currentCol+1} = Spearman_r_t{index_events}(1,2);
        excelDataRaw{lineIndex, currentCol+2} = Spearman_p_t(1,2);
        
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'std-timing'));
        excelDataRaw{lineIndex, currentCol+1} = std(abs(self.timing - selfBymaster.masterTiming));
        
        
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'Pearson-timing-partial'));
        excelDataRaw{lineIndex, currentCol+1} = Pearson_r_t_sec{index_events}(1,2);
        excelDataRaw{lineIndex, currentCol+2} = Pearson_p_t_sec(1,2);
        
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'Kendall-timing-partial'));
        excelDataRaw{lineIndex, currentCol+1} = kendall_r_t_sec{index_events}(1,2);
        excelDataRaw{lineIndex, currentCol+2} = kendall_p_t_sec(1,2);
        
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'Spearman-timing-partial'));
        excelDataRaw{lineIndex, currentCol+1} = Spearman_r_t_sec{index_events}(1,2);
        excelDataRaw{lineIndex, currentCol+2} = Spearman_p_t_sec(1,2);
               
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'Timing-partial'));
        excelDataRaw{lineIndex, currentCol+1} = generalProperty.pearsonOnlyFromStartTime;
        
        [b,~,~] = glmfit(selfBymaster.selfLocation',selfBymaster.masterLocation');

        yhat = b(1) + (b(2).* (selfBymaster.selfLocation'));
        SEyhat = sqrt(sum((selfBymaster.masterLocation'-yhat).^ 2) ./ (n-2));
        CI = abs(tinv(alphaval/2, n-2)) * SEyhat .* sqrt(0.5 + ((selfBymaster.selfLocation' - mean(selfBymaster.selfLocation)) .^ 2) ./ ((n-2) * var(selfBymaster.selfLocation)));
        ci_up = yhat + CI;
        ci_down = yhat - CI;
        
        neuronsOutOfBorderIndex = find(selfBymaster.masterLocation' > ci_up | selfBymaster.masterLocation' < ci_down);
        neuronsInsideOfBorderIndex = find(selfBymaster.masterLocation' <= ci_up & selfBymaster.masterLocation' >= ci_down);
        
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'Neurons Out of confidence_intervals'));
        excelDataRaw((lineIndex + 1): (lineIndex + length(neuronsOutOfBorderIndex)), currentCol) = num2cell(selfBymaster.neuronesNames(neuronsOutOfBorderIndex));
        [lineIndex, currentCol] = find(strcmp(excelDataRaw, 'Neurons Inside of confidence_intervals'));
        excelDataRaw((lineIndex + 1): (lineIndex + length(neuronsInsideOfBorderIndex)), currentCol) = num2cell(selfBymaster.neuronesNames(neuronsInsideOfBorderIndex));
        
        filenameExcel = fullfile(outputPath, ['OrderAndTimingByMAster_analysisResults', self_eventName, 'By', self_alignedEventName, 'Method_', generalProperty.orderMethod, '.xlsx']);
        xlswrite(filenameExcel,excelDataRaw);
        
        fig = figure;
        hold on;
        
        dcm_obj = datacursormode(fig);
        set(dcm_obj,'UpdateFcn',@getRealNeuronNameCursor)      
        im = imagesc(tNew, 1:size(selfBymaster.meanDat, 1), selfBymaster.meanDat);
        im.UserData = selfBymaster.neuronesNames;
        plot(selfBymaster.masterTiming, 1:size(selfBymaster.meanDat, 1), 'color', 'blue', 'lineWidth', 2);
        plot(selfBymaster.selfTiming, 1:size(selfBymaster.meanDat, 1), 'color', 'black', 'lineWidth', 2);
        colormap jet;
        ylabel('Neurons','FontSize',10);
%         placeToneTime(toneTime, 3);
        xlim([tNew(findClosestDouble(tNew, generalProperty.alignedOrderPlot_start_time)),tNew(findClosestDouble(tNew, generalProperty.alignedOrderPlot_end_time))]);
        ylim([1, size(selfBymaster.meanDat, 1)]);
        
        title('Order By master-WithTiming');
        legend('Master Timing','Self Timing Orderd By Master')
        
        mysave(fig, fullfile(outputPath, ['activation_order_'  self_eventName 'By' self_alignedEventName, 'Method_', generalProperty.orderMethod, '_plot']));
        
        fig = figure;
        fig.Units = 'normalized';
        fig_width = fig.Position(3);
        hold on;
        
        dcm_obj = datacursormode(fig);
        set(dcm_obj,'UpdateFcn',@getRealNeuronNameCursor)
        
        sp1 = subplot(2,8, 1:7);
        
%         sp1.Position = [sp1.Position(1), sp1.Position(2), ];
        
        im1 = imagesc(tNew, 1:size(selfBymaster.meanDat, 1), selfBymaster.meanDat);
        
        im1.UserData = selfBymaster.neuronesNames;
               
        colormap jet;
        ylabel('Neurons','FontSize',10);
%         placeToneTime(toneTime, 3);
        xlim([tNew(findClosestDouble(tNew, generalProperty.alignedOrderPlot_start_time)),tNew(findClosestDouble(tNew, generalProperty.alignedOrderPlot_end_time))]);
        ylim([1, size(selfBymaster.meanDat, 1)]);
        title('Order By master');
        set(gca,'YDir','normal');
        
        sp_2 = subplot(2, 8, 8);
        imagesc(1, 1:size(selfBymaster.meanDat, 1), selfBymaster.selfLocation');
        colormap jet;
        set(gca,'YDir','normal');
        set(gca,'YTickLabel', []);
        set(gca,'XTickLabel', []);
        sp_2.Position = [sp_2.Position(1), sp_2.Position(2), fig_width*0.05, sp_2.Position(4)];
        
        subplot(2, 8, 9:15);
        hold on;
        im2 = imagesc(tNew, 1:size(self.MeanData, 1), self.MeanData);
        
        im2.UserData = self.neuronsName;
        plot(selfBymaster.masterTiming, 1:size(selfBymaster.meanDat, 1), 'color', 'red', 'lineWidth', 1.5);
        plot(self.timing, 1:size(self.MeanData, 1), 'color', 'black', 'lineWidth', 2);
        colormap jet;
        ylabel('Neurons','FontSize',10);
%         placeToneTime(toneTime, 3);
        xlim([tNew(findClosestDouble(tNew, generalProperty.alignedOrderPlot_start_time)),tNew(findClosestDouble(tNew, generalProperty.alignedOrderPlot_end_time))]);
        ylim([1, size(self.MeanData, 1)]);
        title('Order By Self');
        
        legend(gca, {'Master Timing','Self Timing'})
        
        set(gca,'YDir','normal');
        
        sp_4 = subplot(2, 8, 16);
        sp_4.Position = [sp_4.Position(1), sp_4.Position(2), fig_width*0.05, sp_4.Position(4)];
        imagesc(1, 1:size(selfBymaster.meanDat, 1), (1:size(selfBymaster.meanDat, 1))');
        colormap jet;
        set(gca,'YDir','normal');
        set(gca,'YTickLabel', []);
        set(gca,'XTickLabel', []);
        
        mysave(fig, fullfile(outputPath, ['activation_order_withoutTiming'  self_eventName 'By' self_alignedEventName 'Method_' generalProperty.orderMethod '_plot']));                
        
        fig = figure;
        hold on;
        
        [sortX, I] = sort(selfBymaster.selfLocation);
        x = selfBymaster.selfLocation';
        
        lo = yhat - CI;
        hi = (yhat + CI);
        
        hp = patch([x(I); x(I(end:-1:1)); x(1)], [lo(I); hi(I(end:-1:1)); lo(1)], 'r');
        hl = line(x,yhat);
        set(hp, 'facecolor', [1 0.8 0.8], 'edgecolor', 'none');
        set(hl, 'color', 'r', 'marker', 'x');
        
        sc = scatter(selfBymaster.selfLocation, selfBymaster.masterLocation, 'black', '*');
        ylabel('By Master','FontSize',10);
        xlabel('By Self','FontSize',10);
        title('Order in self vs master for each neuron');
        dcm_obj = datacursormode(fig);
        set(dcm_obj,'UpdateFcn',@getRealNeuronNameCursor)      
        sc.UserData = [selfBymaster.neuronesNames', selfBymaster.masterLocation'];
          
        mysave(fig, fullfile(outputPath, ['activation_order_SelfVSMaster'  self_eventName 'By' self_alignedEventName 'Method_' generalProperty.orderMethod '_plot']));
    end
end