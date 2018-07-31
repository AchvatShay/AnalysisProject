package com.analysis.manager.modle;

import java.util.List;
import org.springframework.transaction.annotation.Transactional;


import org.springframework.stereotype.Repository;

@Repository
@Transactional
public class UserDao extends BasicDao<User>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<User> getAll() {
        return entityManager.createQuery("from User").getResultList();
    }

    /**
     * Return the user having the passed email.
     */
//    public User getByEmail(String email) {
//        return (User) entityManager.createQuery(
//                "from User where email = :email")
//                .setParameter("email", email)
//                .getSingleResult();
//    }

    /**
     * Return the user having the passed id.
     */
    public User getById(long id) {
        return entityManager.find(User.class, id);
    }
} // class UserDao