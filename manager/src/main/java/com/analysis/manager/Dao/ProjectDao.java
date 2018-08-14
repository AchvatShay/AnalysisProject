package com.analysis.manager.Dao;

import com.analysis.manager.modle.*;
import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.IOException;
import java.util.List;

@Repository("projectRepository")
public interface ProjectDao extends JpaRepository<Project, Long> {

    List<Project> findAllByUser(User user);
    Project findByIdAndUser(long id, User user);
    Project findById(long id);
    boolean existsByName(String name);


} // class UserDao