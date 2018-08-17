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
    private User user;

//    private String urlsResults;

    @ManyToMany
    private List<AnalysisType> analysisType;

    @ManyToMany
    private List<Trial> trials;

    @ManyToOne
    private Experiment experiment;

    public Analysis() {
    }

    public Analysis(@NotNull String name, @NotNull String description, User user, List<AnalysisType> analysisType, List<Trial> trials, Experiment experiment) {
        this.name = name;
        this.trials = trials;
        this.description = description;
        this.user = user;
        this.analysisType = analysisType;
        this.experiment = experiment;
    }

//    public String getUrlsResults() {
//        return urlsResults;
//    }
//
//    public void setUrlsResults(String urlsResults) {
//        this.urlsResults = urlsResults;
//    }

    public Experiment getExperiment() {
        return experiment;
    }

    public void setExperiment(Experiment experiment) {
        this.experiment = experiment;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
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

    @Override
    public boolean equals(Object o) {
        if (o == null) {
            return false;
        }

        /* Check if o is an instance of Complex or not
          "null instanceof [type]" also returns false */
        if (!(o instanceof Analysis)) {
            return false;
        }

        return ((Analysis)o).getId() == this.getId();
    }
}
