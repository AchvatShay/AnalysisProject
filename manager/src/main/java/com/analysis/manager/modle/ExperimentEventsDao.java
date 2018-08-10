package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;

@Repository
@Transactional
public class ExperimentEventsDao extends BasicDao<ExperimentEvents>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<ExperimentEvents> getAll() {
        return entityManager.createQuery("from ExperimentEvents").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public ExperimentEvents getById(long id) {
        return entityManager.find(ExperimentEvents.class, id);
    }

    /**
     * Return the user having the passed name.
     */
    public ExperimentEvents getByName(String name) {
        try {
            return (ExperimentEvents) entityManager.createQuery(
                    "from ExperimentEvents where name = :name")
                    .setParameter("name", name)
                    .getSingleResult();
        }
        catch (NoResultException e)
        {
            return null;
        }
    }


} // class UserDao