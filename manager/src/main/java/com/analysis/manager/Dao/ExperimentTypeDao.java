package com.analysis.manager.Dao;

import com.analysis.manager.modle.ExperimentType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;

@Repository("experimentTypeRepository")
public interface ExperimentTypeDao extends JpaRepository<ExperimentType, Long> {
    ExperimentType findById(long id);

    boolean existsByName(String type);
}