package com.analysis.manager.Dao;

import com.analysis.manager.modle.Animal;
import com.analysis.manager.modle.Experiment;
import com.analysis.manager.modle.Layer;
import com.analysis.manager.modle.Project;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository("animalRepository")
public interface AnimalsDao extends JpaRepository<Animal, Long> {
    Animal findByIdAndLayer(long id, Layer layer);
    Animal findById(long id);
    Animal findByNameAndLayer(String name, Layer layer);
    void deleteAllByLayer(Layer layer);
    List<Animal> findAllByLayer(Layer layer);
}