package com.analysis.manager.Service;

import com.analysis.manager.Dao.*;
import com.analysis.manager.modle.*;
import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.IOException;
import java.util.LinkedList;
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

    @Value("${analysis.results.location}")
    private String pathAnalysis;

    private static final Logger logger = LoggerFactory.getLogger(ProjectServiceImpl.class);

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
            experimentDao.deleteAll(new LinkedList<>(project.getExperiments()));
            project.setExperiments(null);
        }

        if (project.getAnimals() != null) {
            for (Animal animal : project.getAnimals())
            {
                animalsDao.delete(animal);
            }

            project.setAnimals(null);
        }

        if (project.getLayers() != null) {
            for (Layer layer : project.getLayers())
            {
                layerDao.delete(layer);
            }

            project.setLayers(null);
        }

        if (project.getAnalyzes() != null) {
            for (Analysis analysis : project.getAnalyzes())
            {
                analysisDao.delete(analysis);
            }

            project.setAnalyzes(null);
        }

        String path = pathAnalysis + File.separator + project.getUser().getName() + "_" + project.getUser().getLastName() + File.separator + project.getName();

        try {
            FileUtils.deleteDirectory(new File(path.toLowerCase()));
        } catch (IOException e) {
            logger.error(e.getMessage());
        }

        logger.info("Delete project " + project.getName() + " from DB");
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
