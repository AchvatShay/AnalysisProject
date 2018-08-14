package com.analysis.manager.Dao;

import com.analysis.manager.modle.BDA;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository("bdaRepository")
public interface BDADao extends JpaRepository<BDA, Long> {
    boolean existsByFileLocation(String file_location);

    BDA findByFileLocation(String fileLocation);
}