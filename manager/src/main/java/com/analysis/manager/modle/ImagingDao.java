package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class ImagingDao extends BasicDao<Imaging>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<Imaging> getAll() {
        return entityManager.createQuery("from Imaging").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public Imaging getById(long id) {
        return entityManager.find(Imaging.class, id);
    }

} // class UserDao