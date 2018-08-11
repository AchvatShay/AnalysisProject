package com.analysis.manager.modle;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class ExperimentDao extends BasicDao<Experiment>{

    @Autowired
    private ExperimentConditionDao experimentConditionDao;
    @Autowired
    TrialDao trialDao;

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<Experiment> getAll() {
        return entityManager.createQuery("from Experiment").getResultList();
    }

    @Override
    public void delete(Experiment experiment) {
        if (experiment.getTrials() != null) {
            for (Trial trial :experiment.getTrials()) {
                trialDao.delete(trial);
            }
        }

        experimentConditionDao.delete(experiment.getExperimentCondition());

        super.delete(experiment);
    }

    /**
     * Return the user having the passed id.
     */
    public Experiment getById(long id) {
        return entityManager.find(Experiment.class, id);
    }
} // class UserDao