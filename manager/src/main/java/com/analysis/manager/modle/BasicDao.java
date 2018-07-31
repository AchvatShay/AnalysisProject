package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.springframework.transaction.annotation.Transactional;


public abstract class BasicDao<T>   implements InterfaceDao<T>{

    // ------------------------
    // PUBLIC METHODS
    // ------------------------

    /**
     * Save the user in the database.
     */
    public void create(T t) {
        entityManager.persist(t);
        return;
    }

    /**
     * Delete the user from the database.
     */
    public void delete(T t) {
        if (entityManager.contains(t))
            entityManager.remove(t);
        else
            entityManager.remove(entityManager.merge(t));
        return;
    }

    /**
     * Update the passed user in the database.
     */
    public void update(T t) {
        entityManager.merge(t);
        return;
    }

    // ------------------------
    // PRIVATE FIELDS
    // ------------------------

    // An EntityManager will be automatically injected from entityManagerFactory
    // setup on DatabaseConfig class.
    @PersistenceContext
    public EntityManager entityManager;

} // class UserDao