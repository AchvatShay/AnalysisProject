package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;

@Repository
@Transactional
public class ExperimentInjectionsDao extends BasicDao<ExperimentInjections>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<ExperimentInjections> getAll() {
        return entityManager.createQuery("from experiment_injections").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public ExperimentInjections getById(long id) {
        return entityManager.find(ExperimentInjections.class, id);
    }

    /**
     * Return the user having the passed name.
     */
    public ExperimentInjections getByName(String name) {
        try {
            return (ExperimentInjections) entityManager.createQuery(
                    "from ExperimentInjections where name = :name")
                    .setParameter("name", name)
                    .getSingleResult();
        }
        catch (NoResultException e)
        {
            return null;
        }
    }


} // class UserDao