package com.analysis.manager.Service;

import com.analysis.manager.Dao.AnimalsDao;
import com.analysis.manager.Dao.ExperimentConditionDao;
import com.analysis.manager.Dao.ExperimentDao;
import com.analysis.manager.modle.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service("animalsService")
@Transactional
public class AnimalsServiceImpl implements AnimalsService {

    @Autowired
    private AnimalsDao animalsDao;

    @Autowired
    private ExperimentService experimentService;

    private static final Logger logger = LoggerFactory.getLogger(AnimalsServiceImpl.class);

    @Override
    public Animal findByIdAndLayer(long id, Layer layer) {
        return animalsDao.findByIdAndLayer(id, layer);
    }

    @Override
    public Animal findById(long id) {
        return animalsDao.findById(id);
    }

    @Override
    public Animal findByNameAndLayer(String name, Layer layer) {
        return animalsDao.findByNameAndLayer(name, layer);
    }

    @Override
    public void save(Animal animal) {
        animalsDao.save(animal);
    }

    @Override
    public void delete(Animal animal) {
        logger.info("Delete animal from DB " + animal.getName());

        experimentService.deleteAllByAnimal(animal);
        animalsDao.delete(animal);
    }

    @Override
    public List<Animal> findAllByLayer(Layer layer) {
        return animalsDao.findAllByLayer(layer);
    }

    @Override
    public void deleteAllByLayer(Layer layer) {
        logger.info("Delete animal from DB with layer" + layer.getName());

        List<Animal> animals = animalsDao.findAllByLayer(layer);

        for (Animal animal : animals) {
            experimentService.deleteAllByAnimal(animal);
        }

        animalsDao.deleteAllByLayer(layer);
    }
}
