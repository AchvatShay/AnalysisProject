package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;

@Repository
@Transactional
public class AnalysisTypeDao extends BasicDao<AnalysisType>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<AnalysisType> getAll() {
        return entityManager.createQuery("from AnalysisType").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public AnalysisType getById(long id) {
        return entityManager.find(AnalysisType.class, id);
    }

    /**
     * Return the user having the passed name.
     */
    public AnalysisType getByName(String name) {
        try {
            return (AnalysisType) entityManager.createQuery(
                    "from AnalysisType where name = :name")
                    .setParameter("name", name)
                    .getSingleResult();
        }
        catch (NoResultException e)
        {
            return null;
        }
    }


} // class UserDao