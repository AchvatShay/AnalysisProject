function calculateOrderTimingAnalysis(self_timing, self_neuronsName, master_timing, master_neuronesNames, eventName, alignedEventName, orderMethod,  outputPath, tNew)
    startIndex = 1;
    endIndex = size(self_timing, 2);
    endIndexStr = num2str(endIndex);
    Pearson_r_t_index = 1;
    
    [b,~,~] = glmfit(self_timing(:)', master_timing(:)');
    yhat = b(1) + (b(2).* (self_timing));
    n = length(self_timing);
    alphaval = 0.05;
        
    SEyhat = sqrt(sum((master_timing'-yhat).^ 2) ./ (n-2));
    CI = abs(tinv(alphaval/2, n-2)) * SEyhat .* sqrt(0.5 + ((self_timing - mean(self_timing)) .^ 2) ./ ((n-2) * var(self_timing)));
    
    fig = figure;
    
    fig.Position(4) = 700;
    hold on;
    
    subplot(3,4,1:4);
    hold on;
    ylabel('By Master','FontSize',10);
    xlabel('By Self','FontSize',10);
    title('Timing in self vs master for each neuron');
  
    [~, I] = sort(self_timing);
    x = self_timing';

    lo = yhat - CI;
    hi = (yhat + CI);

    hp = patch([x(I); x(I(end:-1:1)); x(1)], [lo(I)'; hi(I(end:-1:1))'; lo(1)], 'r');
    hl = line(x,yhat);
    set(hp, 'facecolor', [1 0.8 0.8], 'edgecolor', 'none');
    set(hl, 'color', 'r', 'marker', 'x');
    
    sc = scatter(self_timing, master_timing, 'black', '*');
   
    subp = subplot(3,4,5:8);
    hold on;
    ylabel('Order of activation By Self','FontSize',10);
    xlabel('Time','FontSize',10);
   
    locationOfMinDiff = find((hi-lo) == min(hi-lo));
   
    %ADD TTEST2 and Pearson
    [h_all, p_all] = ttest2(self_timing(locationOfMinDiff(1) : endIndex)', master_timing(locationOfMinDiff(1) : endIndex)');
    [PearsonResults_all, ~] = corr([self_timing(locationOfMinDiff(1) : endIndex)', master_timing(locationOfMinDiff(1) : endIndex)'], 'type', 'Pearson');
    rsem = sqrt(mean((self_timing(locationOfMinDiff(1) : endIndex)-master_timing(locationOfMinDiff(1) : endIndex)).^2));    
    Pearson_all = PearsonResults_all(1, 2);
    
    plot(self_timing, 1:size(self_timing, 2), 'color', 'black', 'lineWidth', 1.5);
    plot(master_timing, 1:size(master_timing, 2), 'color', 'red', 'lineWidth', 2);
    
    refline([0 locationOfMinDiff(1)]);
    
    legend(gca, {'Self Timing','Master Timing', 'Start Point For Significant Change'})
    
    message = sprintf(['T test form order :' num2str(locationOfMinDiff(1)) ' to end.\nh=' num2str(h_all) ',p=' num2str(p_all) ' Pearson:' num2str(Pearson_all) ' RSEM:' num2str(rsem)]);
    annotation('textbox',[subp.Position(1), subp.Position(2) - 0.2, 0.10, 0.10],'String', message);
    
    mysave(fig, fullfile(outputPath, ['activation_timing_SelfVSMaster_type1'  eventName 'By' alignedEventName 'Method_' orderMethod '_plot']));
 
    dalta_timing = self_timing - master_timing;
    mean_dalta_timing = (mean(dalta_timing));
    std_dalta_timing = std(dalta_timing)*0.6;
    fig = figure;
    fig.Position(4) = 700;
    hold on;
    
    subplot(3,4,1:4);
    hold on;
    ylabel('Time (Self - Master)','FontSize',10);
    xlabel('Order of activation By Self','FontSize',10);
    
    plot(1:length(dalta_timing),dalta_timing, 'black');
    plot(1:length(dalta_timing), mean_dalta_timing*ones(1,length(dalta_timing)), 'blue');    
    plot(1:length(dalta_timing), (mean_dalta_timing+std_dalta_timing)*ones(1,length(dalta_timing)), 'green');
    plot(1:length(dalta_timing), (mean_dalta_timing-std_dalta_timing)*ones(1,length(dalta_timing)), 'green');
    
    if (mean_dalta_timing < 0)
        timingOutOfBound = find(dalta_timing < mean_dalta_timing-std_dalta_timing);
    elseif(mean_dalta_timing > 0)
        timingOutOfBound = find(dalta_timing > mean_dalta_timing+std_dalta_timing);
    else
        timingOutOfBound = find(dalta_timing > mean_dalta_timing+std_dalta_timing | dalta_timing < mean_dalta_timing-std_dalta_timing);
    end
    
    
    subp = subplot(3,4,5:8);
    hold on;
    ylabel('Order of activation By Self','FontSize',10);
    xlabel('Time','FontSize',10);
   
    plot(self_timing, 1:size(self_timing, 2), 'color', 'black', 'lineWidth', 1.5);
    plot(master_timing, 1:size(master_timing, 2), 'color', 'red', 'lineWidth', 2);
        
    refline([0 timingOutOfBound(1)]);
    legend(gca, {'Self Timing','Master Timing', 'Start Point For Significant Change'})
    
    %ADD TTEST2 AND PEARSON
    [h_all, p_all] = ttest2(self_timing(timingOutOfBound(1) : endIndex)', master_timing(timingOutOfBound(1) : endIndex)');
    [PearsonResults_all, ~] = corr([self_timing(timingOutOfBound(1) : endIndex)', master_timing(timingOutOfBound(1) : endIndex)'], 'type', 'Pearson');
    rsem = sqrt(mean((self_timing(timingOutOfBound(1) : endIndex)-master_timing(timingOutOfBound(1) : endIndex)).^2));    
  
    Pearson_all = PearsonResults_all(1, 2);
    
    message = sprintf(['T test form order :' num2str(timingOutOfBound(1)) ' to end.\nh=' num2str(h_all) ',p=' num2str(p_all) ' Pearson:' num2str(Pearson_all) ' RSEM:' num2str(rsem)]);
       
    annotation('textbox',[subp.Position(1), subp.Position(2) - 0.2, 0.10, 0.10],'String', message);
    
    mysave(fig, fullfile(outputPath, ['activation_timing_SelfVSMaster_type2'  eventName 'By' alignedEventName 'Method_' orderMethod '_plot']));
 
    
    while((endIndex - startIndex + 1) >= 50)
        X_timing = [self_timing(startIndex : endIndex)', master_timing(startIndex : endIndex)'];
    
        [PearsonResults, ~] = corr(X_timing, 'type', 'Pearson');
        [kendallResults, ~] = corr(X_timing, 'type', 'kendall');
        [h(Pearson_r_t_index), p(Pearson_r_t_index)] = ttest2(self_timing(startIndex : endIndex)', master_timing(startIndex : endIndex)');
        rsemAll(Pearson_r_t_index) = sqrt(mean((self_timing(startIndex : endIndex)-master_timing(startIndex : endIndex)).^2));
        
%         figure;
%         hold on;
%         
%         plot(self_timing(startIndex : endIndex), 1:size(self_timing(startIndex : endIndex), 2), 'color', 'black', 'lineWidth', 1.5);
%         plot(master_timing(startIndex : endIndex), 1:size(master_timing(startIndex : endIndex), 2), 'color', 'red', 'lineWidth', 1.5);
%         plot(self_timing(startIndex : endIndex) + rsemAll(Pearson_r_t_index), 1:size(self_timing(startIndex : endIndex), 2), 'color', 'blue', 'lineWidth', 1.5);
%         
%         legend(gca, {'Self Timing','Master Timing', 'Self after fix with rsem'})
%         [h_all_fix, p_all_fix] = ttest2((self_timing(startIndex : endIndex) + rsemAll(Pearson_r_t_index))', master_timing(startIndex : endIndex)');
%         text(self_timing(startIndex), size(self_timing, 2), ['Ttest Befor self fix:h=' num2str(h(Pearson_r_t_index)) ',p=' num2str(p(Pearson_r_t_index))]);
%         text(self_timing(startIndex), size(self_timing, 2), ['Ttest After self fix:h=' num2str(h_all_fix) ',p=' num2str(p_all_fix)]);
%     
%         mysave(fig, fullfile(outputPath, ['activation_timing_SelfVSMaster_window' [num2str(startIndex) '-' endIndexStr] '_' eventName 'By' alignedEventName 'Method_' orderMethod '_plot']));        
%         
        kendall_r_t(Pearson_r_t_index) = kendallResults(1, 2);
        Pearson_r_t(Pearson_r_t_index) = PearsonResults(1, 2);
        categoricalTimingRCorr{Pearson_r_t_index} = [num2str(startIndex) '-' endIndexStr];

        spliteTime = round((endIndex - startIndex + 1) / 2);
        startIndex = startIndex + spliteTime;
        
        Pearson_r_t_index = Pearson_r_t_index + 1;
        X_timing = [];
    end
    
    plotXRCorr = categorical(categoricalTimingRCorr);
    plotXRCorr = reordercats(plotXRCorr,categoricalTimingRCorr);
    fig = figure;
    hold on;
    sp_1 = subplot(2, 4, 1:4);
    hold on;
        
    ylabel('Corr Pearson','FontSize',10);
    xlabel('Neurons By Order Included','FontSize',10);
    title('Corr Pearson By Order Window');     
    
    b = bar(plotXRCorr, Pearson_r_t);
    
    xtips1 = 1:length(plotXRCorr);
    ytips1 = b.YData;
    labels1 = string(b.YData);   
    text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
   
    
    sp_2 = subplot(2, 4, 5:8);
    hold on;
        
    ylabel('Corr Kendall','FontSize',10);
    xlabel('Neurons By Order Included','FontSize',10);
    title('Corr Kendall By Order Window');     
    
    b = bar(plotXRCorr, kendall_r_t);
   
     xtips1 = 1:length(plotXRCorr);
    ytips1 = b.YData;
    labels1 = string(b.YData);   
    text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
    
 
    mysave(fig, fullfile(outputPath, ['TimingSelfVsMasterWindowCorr' eventName 'By' alignedEventName 'Method_' orderMethod]));
    fig = figure;
    hold on;
   
    
    sp_3 = subplot(2, 4, 1:4);
    hold on;
        
    ylabel('Pvalue','FontSize',10);
    xlabel('Neurons By Order Included','FontSize',10);
    title('T test for paired samples, Blue=equal means, Red=unequal means');     
    
    b = bar(plotXRCorr(h == 0), p(h == 0), 'blue');
    b = bar(plotXRCorr(h ~= 0), p(h ~= 0), 'red');
    
    sp_4 = subplot(2, 4, 5:8);
    hold on;
        
    ylabel('RSEM','FontSize',10);
    xlabel('Neurons By Order Included','FontSize',10);
    title('RSEM By Order Window');     
    
    b = bar(plotXRCorr, rsemAll);
   
     xtips1 = 1:length(plotXRCorr);
    ytips1 = b.YData;
    labels1 = string(b.YData);   
    text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
   
    
    mysave(fig, fullfile(outputPath, ['TimingSelfVsMasterWindowTtest' eventName 'By' alignedEventName 'Method_' orderMethod]));                       
end