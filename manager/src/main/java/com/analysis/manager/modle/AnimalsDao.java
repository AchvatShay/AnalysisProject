package com.analysis.manager.modle;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class AnimalsDao extends BasicDao<Animal>{

    @Autowired
    private ExperimentDao experimentDao;
    // ------------------------
    // PUBLIC METHODS
    // ------------------------

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<Animal> getAll() {
        return entityManager.createQuery("from Animal").getResultList();
    }

    @Override
    public void delete(Animal animal) {
        List<Experiment> experiments =  experimentDao.getAll();

        if (experiments != null) {
            for (Experiment experiment : experiments) {
                if (experiment.getAnimal().getId() == animal.getId()) {
                    experimentDao.delete(experiment);
                }
            }
        }

        super.delete(animal);
    }

    /**
     * Return the user having the passed id.
     */
    public Animal getById(long id) {
        return entityManager.find(Animal.class, id);
    }
} // class UserDao