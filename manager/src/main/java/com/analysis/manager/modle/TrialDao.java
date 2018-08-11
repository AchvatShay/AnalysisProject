package com.analysis.manager.modle;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Repository
@Transactional
public class TrialDao extends BasicDao<Trial>{

    @Autowired
    private TPADao tpaDao;
    @Autowired
    private BDADao bdaDao;
    @Autowired
    private ImagingDao imagingDao;
    @Autowired
    private BehavioralDao behavioralDao;

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<Trial> getAll() {
        return entityManager.createQuery("from Trial").getResultList();
    }


    @Override
    public void delete(Trial trial) {
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

        super.delete(trial);
    }

    /**
     * Return the user having the passed id.
     */
    public Trial getById(long id) {
        return entityManager.find(Trial.class, id);
    }



} // class UserDao