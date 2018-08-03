package com.analysis.manager.modle;


import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;

@Repository
@Transactional
public class ExperimentPelletPertubationDao extends BasicDao<ExperimentPelletPertubation>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<ExperimentPelletPertubation> getAll() {
        return entityManager.createQuery("from ExperimentPelletPertubation").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public ExperimentPelletPertubation getById(long id) {
        return entityManager.find(ExperimentPelletPertubation.class, id);
    }

    /**
     * Return the user having the passed name.
     */
    public ExperimentPelletPertubation getByName(String name) {
        try {
            return (ExperimentPelletPertubation) entityManager.createQuery(
                    "from ExperimentPelletPertubation where name = :name")
                    .setParameter("name", name)
                    .getSingleResult();
        }
        catch (NoResultException e)
        {
            return null;
        }
    }


} // class UserDao