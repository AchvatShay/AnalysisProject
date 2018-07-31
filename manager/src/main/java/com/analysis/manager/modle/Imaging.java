package com.analysis.manager.modle;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

@Entity
@Table(name = "imaging")
public class Imaging {
    // ------------------------
    // PRIVATE FIELDS
    // ------------------------

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @NotNull
    private String file_location;



    // ------------------------
    // PUBLIC METHODS
    // ------------------------

    public Imaging(){}

    public Imaging(String file_location) {
        this.file_location = file_location;
    }

    public long getId() {
        return id;
    }

    public String getFile_location() {
        return file_location;
    }

    public void setId(long id) {
        this.id = id;
    }

    public void setFile_location(String file_location) {
        this.file_location = file_location;
    }
}
