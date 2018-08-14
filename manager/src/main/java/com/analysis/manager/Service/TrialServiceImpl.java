package com.analysis.manager.Service;

import com.analysis.manager.Dao.*;
import com.analysis.manager.modle.*;
import org.apache.tomcat.util.http.fileupload.FileUtils;
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

    @Qualifier("tpaRepository")
    @Autowired
    private TpaRepository tpaDao;
    @Qualifier("bdaRepository")
    @Autowired
    private BDADao bdaDao;
    @Autowired
    private ImagingDao imagingDao;
    @Autowired
    private BehavioralDao behavioralDao;

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
        if (trial.getTpa() != null) {
            tpaDao.delete(trial.getTpa());
        }

        if (trial.getBda() != null) {
            bdaDao.delete(trial.getBda());
        }
        if (trial.getBehavioral() != null) {
            behavioralDao.delete(trial.getBehavioral());
        }
        if (trial.getImaging() != null) {
            imagingDao.delete(trial.getImaging());
        }

        trialDao.delete(trial);
    }

    @Override
    public void save(Trial trial) {
        trialDao.save(trial);
    }
}
