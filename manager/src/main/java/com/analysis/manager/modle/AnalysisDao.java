package com.analysis.manager.modle;

import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.io.File;
import java.io.IOException;
import java.util.List;

@Repository
@Transactional
public class AnalysisDao extends BasicDao<Analysis>{
    @Autowired
    private Environment environment;

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

    @Override
    public void delete(Analysis analysis) {
        // delete from dropbox
        String dropboxPathLocal = environment.getProperty("dropbox.local.location");
        String path = dropboxPathLocal + File.separator + analysis.getProject().getName() + File.separator + analysis.getName();

        try {
            FileUtils.deleteDirectory(new File(path));
        } catch (IOException e) {
            // TODO
            // logging
        }

        super.delete(analysis);
    }
} // class UserDao