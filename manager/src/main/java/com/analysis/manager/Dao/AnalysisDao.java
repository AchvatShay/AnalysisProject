package com.analysis.manager.Dao;

import com.analysis.manager.modle.Analysis;
import com.analysis.manager.modle.Experiment;
import com.analysis.manager.modle.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository("analysisRepository")
public interface AnalysisDao extends JpaRepository<Analysis, Long> {
    Analysis findByIdAndUser(long id, User user);
    List<Analysis> findAllByUser(User user);

    boolean existsByNameAndUser(String name, User user);

    List<Analysis> findAllByExperiment(Experiment experiment);

    List<Analysis> findAll();

    List<Analysis> findAllByExperimentNotLike(Experiment experiment);
} // class UserDao