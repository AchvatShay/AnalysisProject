package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;

@Repository
@Transactional
public class ExperimentTypeDao extends BasicDao<ExperimentType>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<ExperimentType> getAll() {
        return entityManager.createQuery("from ExperimentType").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public ExperimentType getById(long id) {
        return entityManager.find(ExperimentType.class, id);
    }

    /**
     * Return the user having the passed name.
     */
    public ExperimentType getByName(String name) {
        try {
            return (ExperimentType) entityManager.createQuery(
                    "from ExperimentType where name = :name")
                    .setParameter("name", name)
                    .getSingleResult();
        }
        catch (NoResultException e)
        {
            return null;
        }
    }

} // class UserDao