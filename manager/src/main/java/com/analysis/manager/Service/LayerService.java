package com.analysis.manager.Service;

import com.analysis.manager.modle.Animal;
import com.analysis.manager.modle.Layer;
import com.analysis.manager.modle.Project;
import com.analysis.manager.modle.User;

import java.util.List;

public interface LayerService {
    boolean existsByName(String name);
    Layer findByIdAndProject(long id, Project project);
    Layer findByAnimalsContainsAndAndProject(Animal animal, Project project);
    void delete(Layer layer);
    void save(Layer layer);
}
