package com.analysis.manager.modle;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.NoResultException;
import java.util.List;

@Repository
@Transactional
public class LayerDao extends BasicDao<Layer>{

    @Autowired
    private AnimalsDao animalsDao;

    /**
     * Return all the users stored in the database.
     */
    @SuppressWarnings("unchecked")
    public List<Layer> getAll() {
        return entityManager.createQuery("from Layer").getResultList();
    }

    @Override
    public void delete(Layer layer) {
        List<Animal> animals = animalsDao.getAll();

        if (animals != null) {
            for (Animal animal : animals) {
                if (animal.getLayer().getId() == layer.getId()) {
                    animalsDao.delete(animal);
                }
            }
        }

        super.delete(layer);
    }

    /**
     * Return the user having the passed id.
     */
    public Layer getById(long id) {
        return entityManager.find(Layer.class, id);
    }

    public Layer getByName(String name)
    {
        try {
            return (Layer) entityManager.createQuery(
                    "from Layer where name = :name")
                    .setParameter("name", name)
                    .getSingleResult();
        }
        catch (NoResultException e)
        {
            return null;
        }
    }
} // class UserDao