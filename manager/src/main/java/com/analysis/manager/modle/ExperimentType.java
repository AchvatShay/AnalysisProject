package com.analysis.manager.modle;


import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Table(name = "experiment_type")
public class ExperimentType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @NotNull
    private String name;

    public ExperimentType(){}

    public ExperimentType(String name) {
        this.name = name;
    }

    public long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setId(long id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }
}
