package com.analysis.manager.Service;

import com.analysis.manager.modle.Project;
import com.analysis.manager.modle.User;

import java.util.List;

public interface ProjectService {
    List<Project> findAllByUser(User user);
    Project findByIdAndUser(long id, User user);
    void saveProject(Project project);
    void deleteProject(Project project);
    void deleteProjectById(long id);
    Project findById(long id);
    boolean existsByName(String name);
}
