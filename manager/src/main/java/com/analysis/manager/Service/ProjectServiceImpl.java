package com.analysis.manager.Service;

import com.analysis.manager.Dao.*;
import com.analysis.manager.modle.*;
import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.IOException;
import java.util.List;

@Service("projectService")
@Transactional
public class ProjectServiceImpl implements ProjectService {
    @Autowired
    private ProjectDao projectDao;

    @Autowired
    private ExperimentService experimentDao;

    @Autowired
    private AnimalsService animalsDao;

    @Autowired
    private LayerService layerDao;

    @Autowired
    private AnalysisService analysisDao;

    @Autowired
    private Environment environment;

    @Override
    public List<Project> findAllByUser(User user) {
        return projectDao.findAllByUser(user);
    }

    @Override
    public Project findByIdAndUser(long id, User user) {
        return projectDao.findByIdAndUser(id, user);
    }

    @Override
    public void saveProject(Project project) {
        projectDao.save(project);
    }

    @Override
    public void deleteProject(Project project) {
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

        projectDao.delete(project);
    }

    @Override
    public void deleteProjectById(long id) {
        projectDao.deleteById(id);
    }

    @Override
    public Project findById(long id) {
        return projectDao.findById(id);
    }

    @Override
    public boolean existsByName(String name) {
        return projectDao.existsByName(name);
    }
}
