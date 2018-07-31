package com.analysis.manager.modle;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Table(name = "permissions")
public class Permissions {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @NotNull
    private String value;

    public Permissions(){}

    public Permissions(String value)
    {
        this.value = value;
    }
}
