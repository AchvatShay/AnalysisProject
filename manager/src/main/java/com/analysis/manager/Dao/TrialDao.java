package com.analysis.manager.Dao;

import com.analysis.manager.modle.Experiment;
import com.analysis.manager.modle.Trial;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;


@Repository("trialRepository")
public interface TrialDao extends JpaRepository<Trial, Long> {
    Trial findByIdAndExperiment(long id, Experiment experiment);

    Trial findByNameAndExperiment(String name, Experiment experiment);

} // class UserDao