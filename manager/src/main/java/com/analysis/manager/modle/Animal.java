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
}
