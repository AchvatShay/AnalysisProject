package com.analysis.manager.modle;

import javax.persistence.*;
import javax.validation.constraints.NotNull;

/**
 * Represents an User for this web application.
 */
@Entity
@Table(name = "users")
public class User {

    // ------------------------
    // PRIVATE FIELDS
    // ------------------------

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @NotNull
    private String password;

    @NotNull
    private String name;

    @ManyToOne
    private Permissions permissions;

    // ------------------------
    // PUBLIC METHODS
    // ------------------------

    public User(){}

    public User(String password, String name, Permissions permissions) {
        this.password = password;
        this.name = name;
        this.permissions = permissions;
    }

    public long getId() {
        return id;
    }

    public void setId(long value) {
        this.id = value;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public Permissions getPermissions() {
        return permissions;
    }

    public void setPermissions(Permissions permissions) {
        this.permissions = permissions;
    }

    public void setName(String value) {
        this.name = value;
    }

} // class User