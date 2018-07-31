package com.analysis.manager.modle;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.util.List;

@Entity
@Table(name = "layers")
public class Layer {
    // ------------------------
    // PRIVATE FIELDS
    // ------------------------

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @OneToMany(targetEntity = Animal.class)
    private List animals;

    @NotNull
    private String name;

    public Layer(){}

    public Layer(String name, List<Animal> animals)
    {
        this.animals = animals;
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
}
