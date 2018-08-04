package com.analysis.manager.modle;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.LinkedList;
import java.util.List;

@Entity
@Table(name = "projects")
public class Project {
    // ------------------------
    // PRIVATE FIELDS
    // ------------------------

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @NotNull
    private String name;


    @NotNull
    private String description;

    @OneToMany(targetEntity = Layer.class)
    private List layers;

    @OneToMany(targetEntity = Experiment.class)
    private List experiments;

    @OneToMany(targetEntity = Animal.class)
    private List animals;


    @OneToMany(targetEntity = Analysis.class)
    private List Analyzes;

    public Project(){
        this.Analyzes = new LinkedList<Analysis>();
        this.animals = new LinkedList<Animal>();
        this.experiments = new LinkedList();
        this.layers = new LinkedList();
    }

    public Project(String name, String description, List layers, List experiments, List animals, List Analyzes)
    {
        this.description = description;
        this.name = name;
        this.animals = animals;
        this.layers = layers;
        this.experiments = experiments;
        this.Analyzes = Analyzes;
    }

    public List getAnalyzes() {
        return Analyzes;
    }

    public List getAnimals() {
        return animals;
    }

    public List getLayers() {
        return layers;
    }

    public List getExperiments() {
        return experiments;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public void AddLayer(Layer layer)
    {
        if (this.layers == null)
        {
            this.layers = new LinkedList<Layer>();
        }

        this.layers.add(layer);
    }
}
