package com.analysis.manager.modle;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

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

    @ManyToOne
    private Animal animal;

    @OneToOne
    private Behavioral behavioral;

    // ---------------------
    // Public Methods
    // ---------------------

    public Trial(){}

    public Trial(TPA tpa, Imaging imaging, BDA bda, Behavioral behavioral, Animal animal)
    {
        this.bda = bda;
        this.animal = animal;
        this.behavioral = behavioral;
        this.imaging = imaging;
        this.tpa = tpa;
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
