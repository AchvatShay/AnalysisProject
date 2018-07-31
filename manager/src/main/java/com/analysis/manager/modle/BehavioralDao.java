package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;

import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class BehavioralDao extends BasicDao<Behavioral>{

    // ------------------------
    // PUBLIC METHODS
    // ------------------------

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<Behavioral> getAll() {
        return entityManager.createQuery("from Behavioral").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public Behavioral getById(long id) {
        return entityManager.find(Behavioral.class, id);
    }

} // class UserDao