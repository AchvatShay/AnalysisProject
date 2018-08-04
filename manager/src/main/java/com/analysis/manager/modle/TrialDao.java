package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Repository
@Transactional
public class TrialDao extends BasicDao<Trial>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<Trial> getAll() {
        return entityManager.createQuery("from Trial").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public Trial getById(long id) {
        return entityManager.find(Trial.class, id);
    }



} // class UserDao