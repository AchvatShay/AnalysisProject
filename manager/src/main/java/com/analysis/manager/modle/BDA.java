package com.analysis.manager.modle;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Table(name = "BDA")
public class BDA {
    // ------------------------
    // PRIVATE FIELDS
    // ------------------------

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @NotNull
    private String fileLocation;



    // ------------------------
    // PUBLIC METHODS
    // ------------------------

    public BDA(){}

    public BDA(String fileLocation) {
        this.fileLocation = fileLocation;
    }

    public long getId() {
        return id;
    }

    public String getFileLocation() {
        return fileLocation;
    }

    public void setId(long id) {
        this.id = id;
    }

    public void setFileLocation(String fileLocation) {
        this.fileLocation = fileLocation;
    }
}
