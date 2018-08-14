package com.analysis.manager.Dao;

import com.analysis.manager.modle.AnalysisType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;

@Repository("analysisTypeRepository")
public interface AnalysisTypeDao extends JpaRepository<AnalysisType, Long> {
    AnalysisType findById(long id);
    AnalysisType findByName(String name);
}