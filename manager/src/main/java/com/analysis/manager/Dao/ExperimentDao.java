package com.analysis.manager.Dao;

import com.analysis.manager.modle.Animal;
import com.analysis.manager.modle.Experiment;
import com.analysis.manager.modle.Project;
import com.analysis.manager.modle.Trial;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository("experimentRepository")
public interface ExperimentDao extends JpaRepository<Experiment, Long> {
    Experiment findByIdAndProject(long id, Project project);
    void deleteAllByAnimal(Animal animal);
}