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

    public ExperimentCondition(int behavioral_sampling_rate, int depth, long duration, int imaging_sampling_rate, long tone_time, long behavioral_delay, ExperimentType experimentType, ExperimentInjections experimentInjections, ExperimentPelletPertubation experimentPelletPertubation)
    {
        this.behavioral_sampling_rate = behavioral_sampling_rate;
        this.depth = depth;
        this.duration = duration;
        this.behavioral_delay = behavioral_delay;
        this.experimentPelletPertubation = experimentPelletPertubation;
        this.experimentInjections = experimentInjections;
        this.experimentType = experimentType;
        this.imaging_sampling_rate = imaging_sampling_rate;
        this.tone_time = tone_time;
    }

    public long getId() {
        return id;
    }

    public ExperimentType getExperimentType() {
        return experimentType;
    }

    public void setExperimentType(ExperimentType experimentType) {
        this.experimentType = experimentType;
    }

    public ExperimentInjections getExperimentInjections() {
        return experimentInjections;
    }

    public void setExperimentInjections(ExperimentInjections experimentInjections) {
        this.experimentInjections = experimentInjections;
    }

    public ExperimentPelletPertubation getExperimentPelletPertubation() {
        return experimentPelletPertubation;
    }

    public void setExperimentPelletPertubation(ExperimentPelletPertubation experimentPelletPertubation) {
        this.experimentPelletPertubation = experimentPelletPertubation;
    }

    public int getDepth() {
        return depth;
    }

    public void setDepth(int depth) {
        this.depth = depth;
    }

    public int getImaging_sampling_rate() {
        return imaging_sampling_rate;
    }

    public void setImaging_sampling_rate(int imaging_sampling_rate) {
        this.imaging_sampling_rate = imaging_sampling_rate;
    }

    public int getBehavioral_sampling_rate() {
        return behavioral_sampling_rate;
    }

    public void setBehavioral_sampling_rate(int behavioral_sampling_rate) {
        this.behavioral_sampling_rate = behavioral_sampling_rate;
    }

    public long getTone_time() {
        return tone_time;
    }

    public void setTone_time(long tone_time) {
        this.tone_time = tone_time;
    }

    public long getDuration() {
        return duration;
    }

    public void setDuration(long duration) {
        this.duration = duration;
    }

    public long getBehavioral_delay() {
        return behavioral_delay;
    }

    public void setBehavioral_delay(long behavioral_delay) {
        this.behavioral_delay = behavioral_delay;
    }
}
