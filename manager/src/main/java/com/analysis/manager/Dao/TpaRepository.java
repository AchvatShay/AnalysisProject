package com.analysis.manager.Dao;

import com.analysis.manager.modle.TPA;
import com.analysis.manager.modle.Trial;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository("tpaRepository")
public interface TpaRepository extends JpaRepository<TPA, Long> {
    boolean existsByFileLocation(String file_location);

    TPA findByFileLocation(String fileLocation);
} // class UserDao