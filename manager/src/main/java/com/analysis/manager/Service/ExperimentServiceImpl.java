package com.analysis.manager.Service;

import com.analysis.manager.Dao.AnimalsDao;
import com.analysis.manager.Dao.ExperimentConditionDao;
import com.analysis.manager.Dao.ExperimentDao;
import com.analysis.manager.Dao.LayerDao;
import com.analysis.manager.modle.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service("experimentService")
@Transactional
public class ExperimentServiceImpl implements ExperimentService {
    @Autowired
    private ExperimentConditionDao experimentConditionDao;
    @Autowired
    private TrialService trialDao;

    @Autowired
    private ExperimentDao experimentDao;

    @Override
    public Experiment findByIdAndProject(long id, Project project) {
        return experimentDao.findByIdAndProject(id, project);
    }

    @Override
    public void save(Experiment experiment) {
        experimentDao.save(experiment);
    }

    @Override
    public void delete(Experiment experiment) {
        if (experiment.getTrials() != null) {
            for (Trial trial :experiment.getTrials()) {
                trialDao.deleteTrial(trial);
            }
        }

        experimentConditionDao.delete(experiment.getExperimentCondition());

        experimentDao.delete(experiment);
    }

    @Override
    public void deleteAllByAnimal(Animal animal) {
        experimentDao.deleteAllByAnimal(animal);
    }
}
