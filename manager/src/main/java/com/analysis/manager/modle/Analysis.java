package com.analysis.manager.modle;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.File;
import java.io.FilenameFilter;
import java.util.LinkedList;
import java.util.List;

@Entity
@Table(name = "analysis")
public class Analysis {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @NotNull
    private String name;

    @NotNull
    private String description;

    @ManyToOne
    private Project project;

    @ManyToMany
    private List<AnalysisType> analysisType;

    @ManyToMany
    private List<Trial> trials;

    @ManyToOne
    private Experiment experiment;

    public Analysis() {
    }

    public Analysis(@NotNull String name, @NotNull String description, Project project, List<AnalysisType> analysisType, List<Trial> trials, Experiment experiment) {
        this.name = name;
        this.trials = trials;
        this.description = description;
        this.project = project;
        this.analysisType = analysisType;
        this.experiment = experiment;
    }

    public Experiment getExperiment() {
        return experiment;
    }

    public void setExperiment(Experiment experiment) {
        this.experiment = experiment;
    }

    public Project getProject() {
        return project;
    }

    public void setProject(Project project) {
        this.project = project;
    }

    public List<Trial> getTrials() {
        return trials;
    }

    public void setTrials(List<Trial> trials) {
        this.trials = trials;
    }

    public List<AnalysisType> getAnalysisType() {
        return analysisType;
    }

    public void setAnalysisType(List<AnalysisType> analysisType) {
        this.analysisType = analysisType;
    }

    public long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
