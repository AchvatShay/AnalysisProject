package com.analysis.manager.Dao;

import com.analysis.manager.modle.Animal;
import com.analysis.manager.modle.Layer;
import com.analysis.manager.modle.Project;
import com.analysis.manager.modle.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;

@Repository("layerRepository")
public interface LayerDao extends JpaRepository<Layer, Long> {
    boolean existsByName(String name);
    Layer findByIdAndProject(long id, Project project);
    Layer findByAnimalsContainsAndAndProject(Animal animal, Project project);

    boolean existsByNameAndProject(String name, Project project);
}