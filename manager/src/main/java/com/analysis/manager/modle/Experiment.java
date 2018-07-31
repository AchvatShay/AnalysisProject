package com.analysis.manager.modle;


import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.List;

@Entity
@Table(name = "experiment")
public class Experiment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @NotNull
    private String name;

    @NotNull
    private String description;


    @OneToOne
    private ExperimentCondition experimentCondition;

    @OneToMany(targetEntity = Trial.class)
    private List trials;

    @ManyToOne
    private Animal animal;

    public Experiment(){
    }

    public Experiment(String description, String name, ExperimentCondition experimentCondition, List<Trial> trials, Animal animal)
    {
        this.description = description;
        this.name = name;
        this.experimentCondition = experimentCondition;
        this.trials = trials;
        this.animal = animal;
    }
}
