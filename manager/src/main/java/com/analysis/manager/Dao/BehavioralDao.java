package com.analysis.manager.Dao;

import com.analysis.manager.modle.Behavioral;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository("behavioralRepository")
public interface BehavioralDao extends JpaRepository<Behavioral, Long> {

}