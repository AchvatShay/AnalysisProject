package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;

@Repository
@Transactional
public class PermissionsDao extends BasicDao<Permissions>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<Permissions> getAll() {
        return entityManager.createQuery("from Permissions").getResultList();
    }


    /**
     * Return the user having the passed id.
     */
    public Permissions getById(long id) {
        return entityManager.find(Permissions.class, id);
    }

    /**
     * Return the user having the passed id.
     */
    public Permissions getByValue(String value)
    {
        try {
            return (Permissions) entityManager.createQuery(
                    "from Permissions where value = :value")
                    .setParameter("value", value)
                    .getSingleResult();
        }
        catch (NoResultException e)
        {
            return null;
        }
    }

} // class UserDao