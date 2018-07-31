package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class ExperimentConditionDao extends BasicDao<ExperimentCondition>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<ExperimentCondition> getAll() {
        return entityManager.createQuery("from ExperimentCondition").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public ExperimentCondition getById(long id) {
        return entityManager.find(ExperimentCondition.class, id);
    }


} // class UserDao