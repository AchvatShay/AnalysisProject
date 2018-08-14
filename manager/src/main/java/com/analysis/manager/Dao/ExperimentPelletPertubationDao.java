package com.analysis.manager.Dao;


import com.analysis.manager.modle.ExperimentPelletPertubation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;

@Repository("experimentPelletPertubationRepository")
public interface ExperimentPelletPertubationDao extends JpaRepository<ExperimentPelletPertubation, Long> {
    ExperimentPelletPertubation findById(long id);

    boolean existsByName(String type);
}