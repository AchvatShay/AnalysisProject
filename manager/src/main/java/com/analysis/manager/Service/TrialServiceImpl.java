package com.analysis.manager.Service;

import com.analysis.manager.Dao.*;
import com.analysis.manager.modle.*;
import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.IOException;
import java.util.List;

@Service("trialService")
@Transactional
public class TrialServiceImpl implements TrialService {
   @Autowired
   private TrialDao trialDao;

    private static final Logger logger = LoggerFactory.getLogger(TrialServiceImpl.class);

    @Override
    public Trial findByIdAndExperiment(long id, Experiment experiment) {
        return trialDao.findByIdAndExperiment(id, experiment);
    }

    @Override
    public Trial findByNameAndExperiment(String name, Experiment experiment) {
        return trialDao.findByNameAndExperiment(name, experiment);
    }

    @Override
    public void deleteTrial(Trial trial) {
        logger.info("Delete Trial and the TPA BDA for this trial from DB");
        trialDao.delete(trial);
    }

    @Override
    public void save(Trial trial) {
        trialDao.save(trial);
    }

    @Override
    public void deleteAllByExperiment(Experiment experiment) {
        List<Trial> allByExperiment = trialDao.findAllByExperiment(experiment);

        for(Trial trial : allByExperiment) {
            deleteTrial(trial);
        }
    }
}
