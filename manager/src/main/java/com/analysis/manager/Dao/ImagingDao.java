package com.analysis.manager.Dao;

import com.analysis.manager.modle.Imaging;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository("imagingRepository")
public interface ImagingDao extends JpaRepository<Imaging, Long> {
} // class UserDao