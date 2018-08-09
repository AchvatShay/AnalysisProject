package com.analysis.manager.controllers;

import com.analysis.manager.modle.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AnimalsController {

    @Autowired
    private ProjectDao projectDao;

    @Autowired
    private LayerDao layerDao;

    @Autowired
    private AnimalsDao animalsDao;

    @RequestMapping(value = "projects/{id}/animals", method = RequestMethod.POST)
    public String createAnimalForProject(@PathVariable("id") long project_id, @RequestParam("name") String name,
                                         @RequestParam("description") String description, @RequestParam("animal_layer") long layer_id,
                                         Model model)
    {
        try {
            Project project = projectDao.getById(project_id);
            Layer layer = layerDao.getById(layer_id);

            for (Object animal: project.getAnimals())
            {
                if (((Animal)animal).getName().equals(name) && ((Animal)animal).getLayer().getId() == layer.getId())
                {
                    model.addAttribute("error_massage", "Error, animal already exists in this project");
                    return "redirect:/projects/" + project_id;
                }
            }

            Animal animal = new Animal(name, description, null, layer);
            project.AddAnimal(animal);
            animalsDao.create(animal);
            projectDao.update(project);

            return "redirect:/projects/" + project_id;
        }
        catch (Exception e)
        {
            model.addAttribute("error_massage", "Error while creating Animal in DB");
            return "redirect:/projects/" + project_id;
        }
    }
}
