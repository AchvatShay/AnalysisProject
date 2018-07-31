package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class ExperimentDao extends BasicDao<Experiment>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<Experiment> getAll() {
        return entityManager.createQuery("from experiment").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public Experiment getById(long id) {
        return entityManager.find(Experiment.class, id);
    }


} // class UserDao