
classdef Experiment %< handle
    
    
    properties (Constant)
        % global constants see Par file
        
        
    end
    properties
        name  = 0;
        Type  = 'hand_reach'; % 'lick' 'pedal'
        Depth = 200;
        ImagingSamplingRate = 360/12;
        BehavioralSamplingRate = 2400/12;
        BehavioralDelay  = 20;
        ToneTime = 4;
        Duration = 12;
        atogramStartTime = -2;
        atogramEndTime = 4;
        Injection = 'None'; %'saline' 'cno';
        PelletPertubation = 'None';
        Neurons2keep = 0;
        Neurons2plot = 0;
        %         Trials2keep = 0;
        analysis_pca_thEffDim=0.95;
        visualization_legendLocation = 'Best';
        visualization_labelsFontSize = 14;
        visualization_viewparams1 = 0;
        visualization_viewparams2 = 0;
        time2startCountGrabs = 4;
        time2endCountGrabs = 4 + 2;
        startBehaveTime4trajectory = 4;
        endBehaveTime4trajectory = 4 + 2;
        visualization_startTime2plot = 1.5;
        Events2plot = {'lift' 'grab' 'atmouth'};
        Events2plotDelay = {'tone' 'lift' 'grab' 'atmouth'};
        Events2plotDelayNumber = {1 1 1 1}
        Events2plotDelayColor = {};
           
        startTimeGrabCountHis = 4;
        endTimeGrabCountHis = 6;
        
        behaveTimeDiff = {'lift', 'grab'};
        
        centerOfMassStartTime = 4;
        centerOfMassEndTime = 6;
        
        orderMethod = 'peak';
        orderActivationFileLocation = '';
        min_points_above_baseline = 3;
        trailsToRun = '1:end';
        alignedOrderByDataAccordingToEvent_eventName = '';
        alignedOrderByDataAccordingToEvent_eventNum = 0;
        alignedOrderPlot_start_time = 0;
        alignedOrderPlot_end_time = 8;
        pearsonOnlyFromStartTime = 4;
        pearsonOnlyFromEndTime = 6;
        
        min_points_above_baseline_FWHM = 3;
        eventName_FWHM = 'tone';
        min_points_under_FWHM = 5;
        data_downsamples_FWHM = 3;
        
        delay2events_start_time = 0;
        delay2events_end_time = 2;
        
        tastesLabels = {};%{'sucrose','quinine','regular'};% to be populized by the xml
        tastesColors = {};%{'cyan', 'purpile', 'blue'};  % to be populized by the xml      
        
        atogramLabels = {};
        atogramColors = {};      
        
        do_Plot3DTraj = false;
        traj3D_startTime = 4;
        traj3D_endTime = 6;
        traj3DLabels = {};
        traj3DColors = {};
        
        foldsNum = 10;
        linearSVN = true;
        slidingWinLen = 1;
        slidingWinHop = 0.5;
        visualization_conf_percent4acc = 0.05;
        visualization_time4confplotNext = 2.5;
        visualization_time4confplot = 2.5;
        DetermineSucFailBy = 'suc';
        includeOmissions = false;
        labels2cluster = [];
        prevcurrlabels2cluster = [];
        prevcurrlabels2clusterClrs = [];
        labels2clusterClrs = [];
        visualization_bestpcatrajectories2plot = 5;
        successLabel = 'success';
        failureLabel = 'failure';
        indicativeNrnsMeanStartTime = 0;
        indicativeNrnsMeanEndTime = 8;
        indicativeNrns_maxbinnum = 2;
        indicativePvalues = [0.05 0.01 0.001];

        significantNrnsMeanStartTime = 0;
        significantNrnsMeanEndTime = 8;
        significantNrns_maxbinnum = 2;
        significantPvalues = [0.05 0.01 0.001];
        locations_stripesNum = 5;
        glm_events_names= {};
        glm_events_types= {};
       
        glmKinematics_pos = false;
        glmKinematics_vel = false;
        glmKinematics_acc = false;
        glmSeg=[];
        glm_energyTh = .8;
        glm_facial_features_dim = 20;
        indicativeAmplitudeStartTime=5;
        indicativeAmplitudeEndTime=8;
        
        winLenRoiCorrelation = 1;
        winHopRoiCorrelation = 0.5;
        corrTypeRoiCorrelation = 'corr';
        
        RoiSplit_d1 = [];
        RoiSplit_d2 = []; 
        RoiSplit_I1 = [];
        RoiSplit_I2 = []; 
        roiLabels = [];
		
		 %eventsTimeDiffEvents = {'lift', 'grab'};
    end
    methods
        function obj = Experiment(xmlfile)            
            xmlstrct = xml2struct(xmlfile);
            obj.indicativeAmplitudeEndTime = str2double( xmlstrct.GeneralProperty.Experiment.analysisParams.indicativeAmplitudeEndTime.Text); 
            obj.indicativeAmplitudeStartTime = str2double( xmlstrct.GeneralProperty.Experiment.analysisParams.indicativeAmplitudeStartTime.Text); 
            obj.glm_facial_features_dim = str2double( xmlstrct.GeneralProperty.Experiment.analysisParams.glm_facial_features_dim.Text);
            obj.glm_energyTh = str2double( xmlstrct.GeneralProperty.Experiment.analysisParams.glm_energyTh.Text);
            for k=1:length(xmlstrct.GeneralProperty.Experiment.analysisParams.glmSegments.seg)
                if length(xmlstrct.GeneralProperty.Experiment.analysisParams.glmSegments.seg) == 1
                    obj.glmSeg(1,k) = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.glmSegments.seg.start.Text);
                    obj.glmSeg(2,k) = str2double( xmlstrct.GeneralProperty.Experiment.analysisParams.glmSegments.seg.end.Text);
                else
                    obj.glmSeg(1,k) = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.glmSegments.seg{k}.start.Text);
                    obj.glmSeg(2,k) = str2double( xmlstrct.GeneralProperty.Experiment.analysisParams.glmSegments.seg{k}.end.Text);
                end
            end
            if strcmp(xmlstrct.GeneralProperty.Experiment.analysisParams.glmKinematics.position.Text, 'true')
            obj.glmKinematics_pos = true;
            end
            if strcmp(xmlstrct.GeneralProperty.Experiment.analysisParams.glmKinematics.velosity.Text, 'true')
            obj.glmKinematics_vel = true;
            end
            if strcmp(xmlstrct.GeneralProperty.Experiment.analysisParams.glmKinematics.accelration.Text, 'true')
            obj.glmKinematics_acc = true;
            end
            obj.analysis_pca_thEffDim = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.pca_thEffDim.Text);
            for k=1:length(xmlstrct.GeneralProperty.Experiment.analysisParams.glmBehaveEvents.event)
               obj.glm_events_names{k} = xmlstrct.GeneralProperty.Experiment.analysisParams.glmBehaveEvents.event{k}.name.Text; 
               obj.glm_events_types{k} = xmlstrct.GeneralProperty.Experiment.analysisParams.glmBehaveEvents.event{k}.type.Text; 
            end
            obj.locations_stripesNum = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.locations_stripesNum.Text);
            obj.significantNrns_maxbinnum = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.significantNrns_maxbinnum.Text);
            obj.significantNrnsMeanStartTime = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.significantNrnsMeanStartTime.Text);
            obj.significantNrnsMeanEndTime = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.significantNrnsMeanEndTime.Text);
            obj.significantPvalues = zeros(length(xmlstrct.GeneralProperty.Experiment.analysisParams.significantPvalue.val),1);
            for k=1:length(xmlstrct.GeneralProperty.Experiment.analysisParams.significantPvalue.val)
            obj.significantPvalues(k) = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.significantPvalue.val{k}.Text);
            end
            obj.indicativeNrns_maxbinnum = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.indicativeNrns_maxbinnum.Text);
            obj.indicativeNrnsMeanStartTime = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.indicativeNrnsMeanStartTime.Text);
            obj.indicativeNrnsMeanEndTime = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.indicativeNrnsMeanEndTime.Text);
            obj.indicativePvalues = zeros(length(xmlstrct.GeneralProperty.Experiment.analysisParams.indicativePvalue.val),1);
            for k=1:length(xmlstrct.GeneralProperty.Experiment.analysisParams.indicativePvalue.val)
            obj.indicativePvalues(k) = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.indicativePvalue.val{k}.Text);
            end
            obj.visualization_bestpcatrajectories2plot = str2double(xmlstrct.GeneralProperty.Experiment.visualization.bestpcatrajectories2plot.Text);
            obj.successLabel = xmlstrct.GeneralProperty.Experiment.analysisParams.successLabel.Text;
            obj.failureLabel = xmlstrct.GeneralProperty.Experiment.analysisParams.failureLabel.Text;
            
            [obj.prevcurrlabels2cluster, obj.prevcurrlabels2clusterClrs] = extractLabels2cluster(xmlstrct.GeneralProperty.Experiment.analysisParams.prevcurrlabels2cluster);
            [obj.labels2cluster, obj.labels2clusterClrs] = extractLabels2cluster(xmlstrct.GeneralProperty.Experiment.analysisParams.labels2cluster);
            if  str2bool(xmlstrct.GeneralProperty.Experiment.analysisParams.DetermineSucFailBy.BySuc.Attributes.is_active)
                obj.DetermineSucFailBy = 'suc';
            elseif str2bool(xmlstrct.GeneralProperty.Experiment.analysisParams.DetermineSucFailBy.ByFail.Attributes.is_active)
                obj.DetermineSucFailBy = 'fail';
            elseif str2bool(xmlstrct.GeneralProperty.Experiment.analysisParams.DetermineSucFailBy.Both.Attributes.is_active)
                obj.DetermineSucFailBy = 'both';
            else
                error('Please choose one as true: 1. suc is suc and the rest are fail; 2. fail is fail and the rest is suc; 3. suc us suc, fail is fail and ignore the res.');
            end
            obj.includeOmissions = str2bool(xmlstrct.GeneralProperty.Experiment.analysisParams.includeOmissions.Attributes.is_active);
            obj.slidingWinLen = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.slidingWinLen.Text);
            obj.slidingWinHop = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.slidingWinHop.Text);
            obj.linearSVN = str2bool(xmlstrct.GeneralProperty.Experiment.analysisParams.linearSVN.Attributes.is_active);
            obj.startBehaveTime4trajectory = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.startBehaveTime4trajectory.Text);
            obj.foldsNum = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.foldsNum.Text);
            obj.endBehaveTime4trajectory = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.endBehaveTime4trajectory.Text);
            obj.time2startCountGrabs = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.time2startCountGrabs.Text);
            obj.time2endCountGrabs = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.time2endCountGrabs.Text);
            obj.visualization_time4confplotNext=str2timestamplist(xmlstrct.GeneralProperty.Experiment.visualization.visualization_time4confplotNext);
            obj.visualization_time4confplot=str2timestamplist(xmlstrct.GeneralProperty.Experiment.visualization.visualization_time4confplot);
            obj.visualization_conf_percent4acc= str2double(xmlstrct.GeneralProperty.Experiment.visualization.visualization_conf_percent4acc.Text);
            obj.visualization_viewparams1 = str2double(xmlstrct.GeneralProperty.Experiment.visualization.viewparams1.Text);
            obj.visualization_viewparams2 = str2double(xmlstrct.GeneralProperty.Experiment.visualization.viewparams2.Text);
            obj.visualization_legendLocation = xmlstrct.GeneralProperty.Experiment.visualization.legend.Attributes.Location;
            
            obj.orderActivationFileLocation = xmlstrct.GeneralProperty.Experiment.analysisParams.orderAnalysis.orderActivationFileLocation.Text;
            obj.min_points_above_baseline = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.orderAnalysis.min_points_above_baseline.Text);
            
            obj.trailsToRun = xmlstrct.GeneralProperty.Experiment.analysisParams.TrailsToRun.Text;
            obj.alignedOrderByDataAccordingToEvent_eventNum = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.orderAnalysis.AlignedOrderByDataAccordingToEvent.EventNum.Text);
            obj.alignedOrderByDataAccordingToEvent_eventName = xmlstrct.GeneralProperty.Experiment.analysisParams.orderAnalysis.AlignedOrderByDataAccordingToEvent.EventName.Text;
            obj.alignedOrderPlot_start_time = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.orderAnalysis.plot_start_time.Text);
            obj.alignedOrderPlot_end_time = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.orderAnalysis.plot_end_time.Text);
            
            obj.pearsonOnlyFromStartTime = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.orderAnalysis.PearsonOnlyFromStartTime.Text);
            obj.pearsonOnlyFromEndTime = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.orderAnalysis.PearsonOnlyFromEndTime.Text);
           
            obj.orderMethod = xmlstrct.GeneralProperty.Experiment.analysisParams.orderAnalysis.OrderMethod.Text;
            obj.centerOfMassStartTime = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.orderAnalysis.centerOfMass.startTime.Text);
            obj.centerOfMassEndTime = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.orderAnalysis.centerOfMass.endTime.Text);
        
            
            
            obj.startTimeGrabCountHis = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.startTimeGrabCountHis.Text);
            obj.endTimeGrabCountHis = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.endTimeGrabCountHis.Text);
            
            obj.min_points_above_baseline_FWHM = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.FWHMAnalysis.min_points_above_baseline.Text);
            obj.eventName_FWHM = xmlstrct.GeneralProperty.Experiment.analysisParams.FWHMAnalysis.EventName.Text;
            obj.min_points_under_FWHM = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.FWHMAnalysis.min_points_under_FWHM.Text);
            obj.data_downsamples_FWHM = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.FWHMAnalysis.data_downsamples_FWHM.Text);
            
            obj.visualization_labelsFontSize = str2double(xmlstrct.GeneralProperty.Experiment.visualization.labelsFontSize.Text);
            obj.visualization_startTime2plot=str2double(xmlstrct.GeneralProperty.Experiment.visualization.startTime2plot.Text);
            obj.name = xmlstrct.GeneralProperty.Experiment.name;
            obj.Type = xmlstrct.GeneralProperty.Experiment.Condition.Type;
            if  str2bool(xmlstrct.GeneralProperty.Experiment.Condition.Type.hand_reach.Attributes.is_active)
                obj.Type = 'hand_reach';
            elseif str2bool(xmlstrct.GeneralProperty.Experiment.Condition.Type.lick.Attributes.is_active)
                obj.Type = 'lick';
            elseif str2bool(xmlstrct.GeneralProperty.Experiment.Condition.Type.pedal.Attributes.is_active)
                obj.Type = 'pedal';
            else
                error('All experiments types are false! Please set hand reach/lick/pedal as true');
            end
            obj.Depth = str2double(xmlstrct.GeneralProperty.Experiment.Condition.Depth.Text);
            obj.ImagingSamplingRate = str2double(xmlstrct.GeneralProperty.Experiment.Condition.ImagingSamplingRate.Text);
            obj.BehavioralSamplingRate = str2double(xmlstrct.GeneralProperty.Experiment.Condition.BehavioralSamplingRate.Text);
            obj.BehavioralDelay = str2double(xmlstrct.GeneralProperty.Experiment.Condition.BehavioralDelay.Text);
            obj.ToneTime = str2double(xmlstrct.GeneralProperty.Experiment.Condition.ToneTime.Text);
            obj.Duration = str2double(xmlstrct.GeneralProperty.Experiment.Condition.Duration.Text);
            obj.Injection = xmlstrct.GeneralProperty.Experiment.Condition.Injection;
            if  str2bool(xmlstrct.GeneralProperty.Experiment.Condition.Injection.None.Attributes.is_active)
                obj.Injection = 'None';
            elseif str2bool(xmlstrct.GeneralProperty.Experiment.Condition.Injection.Saline.Attributes.is_active)
                obj.Injection = 'Saline';
            elseif str2bool(xmlstrct.GeneralProperty.Experiment.Condition.Injection.CNO.Attributes.is_active)
                obj.Injection = 'CNO';
            else
                error('All experiments Injection are false! Please set hand None/Saline/CNO as true');
            end
            % visualization of events
            obj.Events2plot={};
            if  str2bool(xmlstrct.GeneralProperty.Experiment.visualization.Events2plot.lift.Attributes.is_active)
                obj.Events2plot{end+1} = 'lift';
            end
            if str2bool(xmlstrct.GeneralProperty.Experiment.visualization.Events2plot.grab.Attributes.is_active)
                obj.Events2plot{end+1} = 'grab';
            end
            if str2bool(xmlstrct.GeneralProperty.Experiment.visualization.Events2plot.atmouth.Attributes.is_active)
                obj.Events2plot{end+1} = 'atmouth';
            end
            
            obj.behaveTimeDiff = {};
            for k = 1:length(xmlstrct.GeneralProperty.Experiment.visualization.behaveTimeDiff.Event)
                obj.behaveTimeDiff(k) = {xmlstrct.GeneralProperty.Experiment.visualization.behaveTimeDiff.Event{k}.Text};
            end
			
			%for k = 1:length(xmlstrct.GeneralProperty.Experiment.analysisParams.eventsTimeDiff.val)
             %   obj.eventsTimeDiffEvents{k} = xmlstrct.GeneralProperty.Experiment.analysisParams.eventsTimeDiff.val{k}.Text;
            %end
            
            % visualization of delay to events
            obj.Events2plotDelay={};
            obj.Events2plotDelayNumber={};
            obj.Events2plotDelayColor={};
            
            for k = 1:length(xmlstrct.GeneralProperty.Experiment.visualization.Events2plotDelay.Event)
                obj.Events2plotDelay{end+1} = xmlstrct.GeneralProperty.Experiment.visualization.Events2plotDelay.Event{k}.Name.Text;                
                obj.Events2plotDelayColor{end+1} = getColors({xmlstrct.GeneralProperty.Experiment.visualization.Events2plotDelay.Event{k}.Color.Text});
                obj.Events2plotDelayNumber{end+1} = str2double(xmlstrct.GeneralProperty.Experiment.visualization.Events2plotDelay.Event{k}.Number.Text);
            end
           
            obj.delay2events_start_time = str2double(xmlstrct.GeneralProperty.Experiment.visualization.delay2events_start_time.Text);
            obj.delay2events_end_time = str2double(xmlstrct.GeneralProperty.Experiment.visualization.delay2events_end_time.Text);
            
            if (obj.delay2events_start_time >=  obj.delay2events_end_time)
                error('Please select delay2events_start_time that is lower and not equals to delay2events_end_time');
            end
            
            if  str2bool(xmlstrct.GeneralProperty.Experiment.Condition.PelletPertubation.None.Attributes.is_active)
                obj.PelletPertubation = 'None';
            elseif str2bool(xmlstrct.GeneralProperty.Experiment.Condition.PelletPertubation.Ommisions.Attributes.is_active)
                obj.PelletPertubation = 'Ommisions';
            elseif str2bool(xmlstrct.GeneralProperty.Experiment.Condition.PelletPertubation.Taste.Attributes.is_active)
                obj.PelletPertubation = 'Taste';
            else
                error('All experiments Injection are false! Please set hand None/Saline/CNO as true');
            end
            if strcmp(obj.PelletPertubation, 'Taste')
               for k = 1:length(xmlstrct.GeneralProperty.Experiment.visualization.TastesLabels.Taste)
                   if str2bool(xmlstrct.GeneralProperty.Experiment.visualization.TastesLabels.Taste{k}.is_active.Text)
                      obj.tastesLabels{end+1} = {xmlstrct.GeneralProperty.Experiment.visualization.TastesLabels.Taste{k}.name.Text};
                      obj.tastesColors{end+1} = {getColors({xmlstrct.GeneralProperty.Experiment.visualization.TastesLabels.Taste{k}.color.Text})};
                   end
               end
            end
            
            for k = 1:length(xmlstrct.GeneralProperty.Experiment.visualization.AtogramLabels.Atogram)
               if str2bool(xmlstrct.GeneralProperty.Experiment.visualization.AtogramLabels.Atogram{k}.is_active.Text)
                  obj.atogramLabels{end+1} = xmlstrct.GeneralProperty.Experiment.visualization.AtogramLabels.Atogram{k}.name.Text;
                  obj.atogramColors{end+1} = getColors({xmlstrct.GeneralProperty.Experiment.visualization.AtogramLabels.Atogram{k}.color.Text});
               end
            end
            
            obj.atogramStartTime = str2double(xmlstrct.GeneralProperty.Experiment.visualization.atogramStartTime.Text);
            obj.atogramEndTime = str2double(xmlstrct.GeneralProperty.Experiment.visualization.atogramEndTime.Text);
            
           for k = 1:length(xmlstrct.GeneralProperty.Experiment.analysisParams.plotTraj3D.trajLabels.Traj)
               if str2bool(xmlstrct.GeneralProperty.Experiment.analysisParams.plotTraj3D.trajLabels.Traj{k}.is_active.Text)
                  obj.traj3DLabels{end+1} = xmlstrct.GeneralProperty.Experiment.analysisParams.plotTraj3D.trajLabels.Traj{k}.name.Text;
                  obj.traj3DColors{end+1} = getColors({xmlstrct.GeneralProperty.Experiment.analysisParams.plotTraj3D.trajLabels.Traj{k}.color.Text});
               end
            end
            
            obj.traj3D_startTime = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.plotTraj3D.startTime.Text);
            obj.traj3D_endTime = str2double(xmlstrct.GeneralProperty.Experiment.analysisParams.plotTraj3D.endTime.Text);
            obj.do_Plot3DTraj = str2bool(xmlstrct.GeneralProperty.Experiment.analysisParams.do_Plot3DTraj.Text);
            
            % nerons for analyis
            
            if isfield(xmlstrct.GeneralProperty.Experiment.NeuronesToPut, 'Text')
                obj.Neurons2keep = [];
            else
                if length(xmlstrct.GeneralProperty.Experiment.NeuronesToPut.Neuron) > 1
                    neurons = [xmlstrct.GeneralProperty.Experiment.NeuronesToPut.Neuron{:}];
                else
                    neurons = xmlstrct.GeneralProperty.Experiment.NeuronesToPut.Neuron;
                end
                for nr = 1:length(neurons)
                    obj.Neurons2keep(nr) = str2double(neurons(nr).name.Text);
                end
            end
            
            % neurons for plotting
            if isfield(xmlstrct.GeneralProperty.Experiment.analysisParams.NeuronesToPlot, 'Text')
                obj.Neurons2plot = [];
            else
                if length(xmlstrct.GeneralProperty.Experiment.analysisParams.NeuronesToPlot.Neuron) > 1
                    neurons = [xmlstrct.GeneralProperty.Experiment.analysisParams.NeuronesToPlot.Neuron{:}];
                else
                    neurons = xmlstrct.GeneralProperty.Experiment.analysisParams.NeuronesToPlot.Neuron;
                end
                for nr = 1:length(neurons)
                    obj.Neurons2plot(nr) = str2double(neurons(nr).name.Text);
                end
            end
            %             trials = [xmlstrct.GeneralProperty.Experiment.TrialsToPut.Trial{:}];
            %             for tr = 1:length(trials)
            %                 obj.Trials2keep(tr) = str2double(trials(tr).name.Text);
            %             end
            
            
            obj.winLenRoiCorrelation = str2num(xmlstrct.GeneralProperty.Experiment.RoiCorrelation.winLen.Text);
            obj.winHopRoiCorrelation = str2num(xmlstrct.GeneralProperty.Experiment.RoiCorrelation.winHop.Text);
            obj.corrTypeRoiCorrelation = xmlstrct.GeneralProperty.Experiment.RoiCorrelation.corrType.Text;
            
        end
        
        
    end
end



