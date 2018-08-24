package com.analysis.manager.modle;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.File;
import java.io.FilenameFilter;
import java.util.LinkedList;
import java.util.List;

@Entity
@Table(name = "trail")
public class Trial {

    // ------------------------
    // PRIVATE FIELDS
    // ------------------------

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private String name;

    @NotNull
    private String tpa;

    @NotNull
    private String imaging;

    @NotNull
    private String bda;

    @NotNull
    private String behavioral;

    @ManyToOne
    private Experiment experiment;

    // ---------------------
    // Public Methods
    // ---------------------

    public Trial(){}

    public Trial(String name, String tpa, String imaging, String bda, String behavioral, Experiment experiment)
    {
        this.name = name;
        this.bda = bda;
        this.behavioral = behavioral;
        this.imaging = imaging;
        this.tpa = tpa;
        this.experiment = experiment;
    }

    public Experiment getExperiment() {
        return experiment;
    }

    public void setExperiment(Experiment experiment) {
        this.experiment = experiment;
    }

    public String getTpa() {
        return tpa;
    }

    public void setTpa(String tpa) {
        this.tpa = tpa;
    }

    public String getImaging() {
        return imaging;
    }

    public void setImaging(String imaging) {
        this.imaging = imaging;
    }

    public String getBda() {
        return bda;
    }

    public void setBda(String bda) {
        this.bda = bda;
    }

    public String getBehavioral() {
        return behavioral;
    }

    public void setBehavioral(String behavioral) {
        this.behavioral = behavioral;
    }

    public void setId(long id) {
        this.id = id;
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

    @Override
    public boolean equals(Object other) {
        if (other == null) return false;
        if (other == this) return true;
        if (other instanceof Trial)
        {
            return this.getId() == ((Trial)other).getId();
        } else if (other instanceof Long)
        {
            return this.getId() == (Long)other;
        }

        return false;
    }
}
