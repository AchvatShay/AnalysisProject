package com.analysis.manager.Dao;

import com.analysis.manager.modle.ExperimentCondition;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface ExperimentConditionDao extends JpaRepository<ExperimentCondition, Long> {
}