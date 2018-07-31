package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;
import java.util.List;

@Repository
@Transactional
public class TPADao extends BasicDao<TPA>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<TPA> getAll() {
        return entityManager.createQuery("from TPA").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public TPA getById(long id) {
        return entityManager.find(TPA.class, id);
    }

} // class UserDao