package com.analysis.manager.modle;

import javax.persistence.*;

@Entity
@Table(name = "experiment_condition")
public class ExperimentCondition {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;


    @ManyToOne
    private ExperimentType experimentType;

    @ManyToOne
    private ExperimentInjections experimentInjections;

    @ManyToOne
    private ExperimentPelletPertubation experimentPelletPertubation;


    private int depth;
    private int imaging_sampling_rate;
    private int behavioral_sampling_rate;
    private long tone_time;
    private long duration;
    private long behavioral_delay;

    public ExperimentCondition() {}

    public ExperimentCondition(int behavioral_sampling_rate, int depth, long duration, int imaging_sampling_rate, long tone_time, ExperimentType experimentType, ExperimentInjections experimentInjections)
    {
        this.behavioral_sampling_rate = behavioral_sampling_rate;
        this.depth = depth;
        this.duration = duration;
        this.experimentInjections = experimentInjections;
        this.experimentType = experimentType;
        this.imaging_sampling_rate = imaging_sampling_rate;
        this.tone_time = tone_time;
    }
}
