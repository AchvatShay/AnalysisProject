package com.analysis.manager.Service;

import com.analysis.manager.Dao.AnalysisDao;
import com.analysis.manager.modle.Analysis;
import com.analysis.manager.modle.Experiment;
import com.analysis.manager.modle.Project;
import com.analysis.manager.modle.User;
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

@Service("analysisService")
@Transactional
public class AnalysisServiceImpl implements AnalysisService {
    @Autowired
    private AnalysisDao analysisDao;

    private static final Logger logger = LoggerFactory.getLogger(AnimalsServiceImpl.class);

    @Value("${analysis.results.location}")
    private String pathAnalysis;

    @Override
    public Analysis findByIdAndUser(long id, User user) {
        return analysisDao.findByIdAndUser(id,user);
    }

    @Override
    public List<Analysis> findAllByUser(User user) {
        return analysisDao.findAllByUser(user);
    }

    @Override
    public boolean existsByNameAndUser(String name, User user) {
        return analysisDao.existsByNameAndUser(name, user);
    }

    @Override
    public void save(Analysis analysis) {
        analysisDao.save(analysis);
    }

    @Override
    public void delete(Analysis analysis) {
        Project project = analysis.getExperiment().getProject();
        String path = pathAnalysis + File.separator + project.getUser().getName() + File.separator + project.getName() + File.separator + analysis.getName();

        try {
            FileUtils.deleteDirectory(new File(path));
        } catch (IOException e) {
            logger.error(e.getMessage());
        }

        analysisDao.delete(analysis);
    }

    @Override
    public void deleteByExperiment(Experiment experiment) {
        logger.info("Delete analysis with experiment from DB " + experiment.getName());
        List<Analysis> analyses = analysisDao.findAllByExperiment(experiment);

        for (Analysis analysis : analyses) {
            delete(analysis);
        }
    }

    @Override
    public List<Analysis> findAllByExperimentNotLike(Experiment experiment) {
        return analysisDao.findAllByExperimentNotLike(experiment);
    }
}
