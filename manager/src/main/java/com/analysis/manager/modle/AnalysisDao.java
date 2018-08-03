package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;

@Repository
@Transactional
public class AnalysisDao extends BasicDao<Analysis>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<Analysis> getAll() {
        return entityManager.createQuery("from Analysis").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public Analysis getById(long id) {
        return entityManager.find(Analysis.class, id);
    }

    /**
     * Return the user having the passed name.
     */
    public Analysis getByName(String name) {
        try {
            return (Analysis) entityManager.createQuery(
                    "from Analysis where name = :name")
                    .setParameter("name", name)
                    .getSingleResult();
        }
        catch (NoResultException e)
        {
            return null;
        }
    }


} // class UserDao