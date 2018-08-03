package com.analysis.manager.modle;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.List;

@Entity
@Table(name = "animals")
public class Animal {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @NotNull
    private String name;

    @NotNull
    private String description;

    @OneToMany(targetEntity = Experiment.class)
    private List experiment;

    @ManyToOne
    private Layer layer;

    public Animal(){}

    public Animal(String name, String description, List<Experiment> experiment, Layer layer)
    {
        this.description = description;
        this.experiment = experiment;
        this.layer = layer;
        this.name = name;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
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

    public List getExperiment() {
        return experiment;
    }

    public void setExperiment(List experiment) {
        this.experiment = experiment;
    }

    public Layer getLayer() {
        return layer;
    }

    public void setLayer(Layer layer) {
        this.layer = layer;
    }
}
