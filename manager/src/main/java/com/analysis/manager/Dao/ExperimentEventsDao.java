package com.analysis.manager.Dao;

import com.analysis.manager.modle.ExperimentEvents;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;

@Repository("experimentEventsRepository")
public interface ExperimentEventsDao extends JpaRepository<ExperimentEvents, Long> {
    ExperimentEvents findById(long id);

    boolean existsByName(String type);
}