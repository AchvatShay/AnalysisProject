package com.analysis.manager.Service;

import com.analysis.manager.Dao.*;
import com.analysis.manager.modle.*;
import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.IOException;
import java.util.List;

@Service("layerService")
@Transactional
public class LayerServiceImpl implements LayerService {
    @Autowired
    private AnimalsService animalsDao;

    @Autowired
    private LayerDao layerDao;

    @Override
    public boolean existsByName(String name) {
        return layerDao.existsByName(name);
    }

    @Override
    public Layer findByIdAndProject(long id, Project project) {
        return layerDao.findByIdAndProject(id, project);
    }

    @Override
    public Layer findByAnimalsContainsAndAndProject(Animal animal, Project project) {
        return layerDao.findByAnimalsContainsAndAndProject(animal, project);
    }

    @Override
    public void delete(Layer layer) {
        animalsDao.deleteAllByLayer(layer);
        layerDao.delete(layer);
    }

    @Override
    public void save(Layer layer) {
        layerDao.save(layer);
    }
}
