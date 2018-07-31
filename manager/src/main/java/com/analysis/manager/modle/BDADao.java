package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class BDADao extends BasicDao<BDA>{

    // ------------------------
    // PUBLIC METHODS
    // ------------------------

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<BDA> getAll() {
        return entityManager.createQuery("from BDA").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public BDA getById(long id) {
        return entityManager.find(BDA.class, id);
    }
} // class UserDao