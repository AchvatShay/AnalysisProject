
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
        Injection = 'None'; %'saline' 'cno';
        PelletPertubation = 'None';
        Neurons2keep = 0;
        Trials2keep = 0;
        analysis_pca_thEffDim=0.01;
        visualization_legendLocation = 'Best';
        visualization_labelsFontSize = 14;
    end
    methods
        function obj = Experiment(xmlfile)
            xmlstrct = xml2struct(xmlfile);
            
            obj.visualization_legendLocation = xmlstrct.GeneralProperty.Experiment.visualization.legend.Attributes.Location;
            obj.visualization_labelsFontSize = str2double(xmlstrct.GeneralProperty.Experiment.visualization.labelsFontSize.Text);
        
            obj.name = xmlstrct.GeneralProperty.Experiment.name;
            obj.Type = xmlstrct.GeneralProperty.Experiment.Condition.Type;
            if  strcmp(xmlstrct.GeneralProperty.Experiment.Condition.Type.hand_reach.Attributes.is_active, 'True')
                obj.Type = 'hand_reach';
            elseif strcmp(xmlstrct.GeneralProperty.Experiment.Condition.Type.lick.Attributes.is_active, 'True')
                obj.Type = 'lick';
            elseif strcmp(xmlstrct.GeneralProperty.Experiment.Condition.Type.pedal.Attributes.is_active, 'True')
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
            if  strcmp(xmlstrct.GeneralProperty.Experiment.Condition.Injection.None.Attributes.is_active, 'True')
                obj.Injection = 'None';
            elseif strcmp(xmlstrct.GeneralProperty.Experiment.Condition.Injection.Saline.Attributes.is_active, 'True')
                obj.Injection = 'Saline';
            elseif strcmp(xmlstrct.GeneralProperty.Experiment.Condition.Injection.CNO.Attributes.is_active, 'True')
                obj.Injection = 'CNO';
            else
                error('All experiments Injection are false! Please set hand None/Saline/CNO as true');
            end
            
            if  strcmp(xmlstrct.GeneralProperty.Experiment.Condition.PelletPertubation.None.Attributes.is_active, 'True')
                obj.PelletPertubation = 'None';
            elseif strcmp(xmlstrct.GeneralProperty.Experiment.Condition.PelletPertubation.Ommisions.Attributes.is_active, 'True')
                obj.PelletPertubation = 'Ommisions';
            elseif strcmp(xmlstrct.GeneralProperty.Experiment.Condition.PelletPertubation.Taste.Attributes.is_active, 'True')
                obj.PelletPertubation = 'Taste';
            else
                error('All experiments Injection are false! Please set hand None/Saline/CNO as true');
            end
            
            
            neurons = [xmlstrct.GeneralProperty.Experiment.NeuronesToPut.Neuron{:}];
            for nr = 1:length(neurons)
                obj.Neurons2keep(nr) = str2double(neurons(nr).name.Text);
            end
            trials = [xmlstrct.GeneralProperty.Experiment.TrialsToPut.Trial{:}];
            for tr = 1:length(trials)
                obj.Trials2keep(tr) = str2double(trials(tr).name.Text);
            end
            
        end
        
        
    end
end



