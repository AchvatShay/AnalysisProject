package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class LayerDao extends BasicDao<Layer>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<Layer> getAll() {
        return entityManager.createQuery("from Layer").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public Layer getById(long id) {
        return entityManager.find(Layer.class, id);
    }
} // class UserDao