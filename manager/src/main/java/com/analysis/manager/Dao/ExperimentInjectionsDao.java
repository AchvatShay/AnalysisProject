package com.analysis.manager.Dao;

import com.analysis.manager.modle.ExperimentInjections;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;

@Repository("experimentInjectionsRepository")
public interface ExperimentInjectionsDao extends JpaRepository<ExperimentInjections, Long> {
    ExperimentInjections findById(long id);

    boolean existsByName(String type);
}