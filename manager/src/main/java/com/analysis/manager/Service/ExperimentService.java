package com.analysis.manager.Service;

import com.analysis.manager.modle.Animal;
import com.analysis.manager.modle.Experiment;
import com.analysis.manager.modle.Layer;
import com.analysis.manager.modle.Project;

public interface ExperimentService {
    Experiment findByIdAndProject(long id, Project project);
    void save(Experiment experiment);
    void delete(Experiment experiment);
    void deleteAllByAnimal(Animal animal);
}
