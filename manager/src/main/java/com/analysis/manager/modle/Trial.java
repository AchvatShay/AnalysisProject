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

    @OneToOne
    private TPA tpa;

    @OneToOne
    private Imaging imaging;

    @OneToOne
    private BDA bda;

    @OneToOne
    private Behavioral behavioral;

    @ManyToOne
    private Experiment experiment;

    // ---------------------
    // Public Methods
    // ---------------------

    public Trial(){}

    public Trial(TPA tpa, Imaging imaging, BDA bda, Behavioral behavioral, Experiment experiment)
    {
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

    public TPA getTpa() {
        return tpa;
    }

    public BDA getBda() {
        return bda;
    }

    public Behavioral getBehavioral() {
        return behavioral;
    }

    public Imaging getImaging() {
        return imaging;
    }

    public void setBda(BDA bda) {
        this.bda = bda;
    }

    public void setImaging(Imaging imaging) {
        this.imaging = imaging;
    }

    public void setBehavioral(Behavioral behavioral) {
        this.behavioral = behavioral;
    }

    public void setTpa(TPA tpa) {
        this.tpa = tpa;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getId() {
        return id;
    }
}
