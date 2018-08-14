package com.analysis.manager.Service;

import com.analysis.manager.modle.Animal;
import com.analysis.manager.modle.Experiment;
import com.analysis.manager.modle.Layer;
import com.analysis.manager.modle.Project;

import java.util.List;

public interface AnimalsService {
    Animal findByIdAndLayer(long id, Layer layer);
    Animal findById(long id);
    Animal findByNameAndLayer(String name, Layer layer);
    void save(Animal animal);
    void delete(Animal animal);
    List<Animal> findAllByLayer(Layer layer);
    void deleteAllByLayer(Layer layer);
}
