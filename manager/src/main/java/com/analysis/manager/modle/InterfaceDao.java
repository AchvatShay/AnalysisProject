package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public interface InterfaceDao<T> {

    // ------------------------
    // PUBLIC METHODS
    // ------------------------

    /**
     * Save the user in the database.
     */
    void create(T t);

    /**
     * Delete the user from the database.
     */
    void delete(T t);

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    List<T> getAll();

    /**
     * Return the user having the passed id.
     */
    T getById(long id);

    /**
     * Update the passed user in the database.
     */
    void update(T t);
}