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

    public Project(){
    }

    public Project(String name, String description, List layers, List experiments, List animals)
    {
        this.description = description;
        this.name = name;
        this.animals = animals;
        this.layers = layers;
        this.experiments = experiments;
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
