package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class AnimalsDao extends BasicDao<Animal>{

    // ------------------------
    // PUBLIC METHODS
    // ------------------------

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<Animal> getAll() {
        return entityManager.createQuery("from Animal").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public Animal getById(long id) {
        return entityManager.find(Animal.class, id);
    }
} // class UserDao