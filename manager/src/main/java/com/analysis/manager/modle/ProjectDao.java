package com.analysis.manager.modle;

import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.IOException;
import java.util.List;

@Repository
@Transactional
public class ProjectDao extends BasicDao<Project>{

    @Autowired
    private ExperimentDao experimentDao;
    @Autowired
    private LayerDao layerDao;
    @Autowired
    private AnimalsDao animalsDao;
    @Autowired
    private AnalysisDao analysisDao;
    @Autowired
    private Environment environment;


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

    @Override
    public void delete(Project project) {
        if (project.getExperiments() != null) {
            for (Experiment experiment : project.getExperiments())
            {
                experimentDao.delete(experiment);
            }
        }

        if (project.getAnimals() != null) {
            for (Animal animal : project.getAnimals())
            {
                animalsDao.delete(animal);
            }
        }

        if (project.getLayers() != null) {
            for (Layer layer : project.getLayers())
            {
                layerDao.delete(layer);
            }
        }

        if (project.getAnalyzes() != null) {
            for (Analysis analysis : project.getAnalyzes())
            {
                analysisDao.delete(analysis);
            }
        }

        // delete from dropbox
        String dropboxPathLocal = environment.getProperty("dropbox.local.location");
        String path = dropboxPathLocal + File.separator + project.getName();

        try {
            FileUtils.deleteDirectory(new File(path));
        } catch (IOException e) {
            // TODO
            // logging
        }

        super.delete(project);
    }

    /**
     * Return the user having the passed id.
     */
    public Project getById(long id) {
        return entityManager.find(Project.class, id);
    }

} // class UserDao