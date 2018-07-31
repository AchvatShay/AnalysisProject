package com.analysis.manager.modle;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class ProjectDao extends BasicDao<Project>{

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<Project> getAll() {
        return entityManager.createQuery("from Project").getResultList();
    }

    public void deleteByID(long id)
    {
        Project project = entityManager.find(Project.class, id);
        if (project != null)
        {
            entityManager.remove(project);
        }
    }

    /**
     * Return the user having the passed id.
     */
    public Project getById(long id) {
        return entityManager.find(Project.class, id);
    }

} // class UserDao