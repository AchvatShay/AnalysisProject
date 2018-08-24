package com.analysis.manager.modle;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.LinkedList;
import java.util.List;

@Entity
@Table(name = "project")
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

    @ManyToOne
    private User user;

    public Project(){
        this.Analyzes = new LinkedList<Analysis>();
        this.animals = new LinkedList<Animal>();
        this.experiments = new LinkedList();
        this.layers = new LinkedList();
    }

    public Project(User user, String name, String description, List layers, List experiments, List animals, List Analyzes)
    {
        this.user = user;
        this.description = description;
        this.name = name;
        this.animals = animals;
        this.layers = layers;
        this.experiments = experiments;
        this.Analyzes = Analyzes;
    }

    public Project(User user, String name, String description)
    {
        super();
        this.user = user;
        this.description = description;
        this.name = name;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<Analysis> getAnalyzes() {
        return Analyzes;
    }

    public List<Animal> getAnimals() {
        return animals;
    }

    public List<Layer> getLayers() {
        return layers;
    }

    public List<Experiment> getExperiments() {
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

    public void AddAnimal(Animal animal) {
        if (this.animals == null)
        {
            this.animals = new LinkedList<Layer>();
        }

        this.animals.add(animal);
    }

    public void AddAnalysis(Analysis analysis) {
        if (this.Analyzes == null)
        {
            this.Analyzes = new LinkedList<Layer>();
        }

        this.Analyzes.add(analysis);
    }

    public void AddExperiment(Experiment experiment) {
        if (this.experiments == null)
        {
            this.experiments = new LinkedList<Layer>();
        }

        this.experiments.add(experiment);
    }

    public void deleteLayer(Layer layer) {
        if (this.getLayers() != null) {
            this.layers.remove(layer);
        }
    }

    public void deleteExperiment(Experiment experiment) {
        if (this.getExperiments() != null) {
            this.experiments.remove(experiment);
        }
    }

    public void deleteAnimal(Animal animal) {
        if (this.getAnimals() != null) {
            this.animals.remove(animal);
        }
    }

    public void deleteAnalysis(Analysis analysis) {
        if (this.getAnalyzes() != null) {
            this.Analyzes.remove(analysis);
        }
    }

    public void setAnimals(List<Animal> animallist) {
        this.animals = animallist;
    }

    public void setExperiments(List<Experiment> experimentList) {
        this.experiments = experimentList;
    }

    public void setLayers(List<Layer> layers) {
        this.layers = layers;
    }

    public void setAnalyzes(List<Analysis> analysis) {
        this.Analyzes = analysis;
    }

    public void removeExperiment(Experiment experiment) {

        if (this.experiments != null) {
            this.experiments.remove(experiment);
        }
    }
}
