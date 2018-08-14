package com.analysis.manager.controllers;

import com.analysis.manager.Service.AnimalsService;
import com.analysis.manager.Service.LayerService;
import com.analysis.manager.Service.ProjectService;
import com.analysis.manager.Service.UserService;
import com.analysis.manager.modle.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AnimalsController {

    @Autowired
    private ProjectService projectDao;

    @Autowired
    private LayerService layerDao;

    @Autowired
    private AnimalsService animalsDao;

    @Autowired
    private UserService userService;

    @RequestMapping(value = "projects/{id}/animals", method = RequestMethod.POST)
    public String createAnimalForProject(@PathVariable("id") long project_id, @RequestParam("name") String name,
                                         @RequestParam("description") String description, @RequestParam("animal_layer") long layer_id,
                                         Model model)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(project_id, user);
            Layer layer = layerDao.findByIdAndProject(layer_id, project);

            if (animalsDao.findByNameAndLayer(name, layer) == null) {
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
                animalsDao.save(animal);
                projectDao.saveProject(project);
            } else {
                model.addAttribute("error_massage", "Animal with this name already exists");
            }

            return "redirect:/projects/" + project_id;
        }
        catch (Exception e)
        {
            model.addAttribute("error_massage", "Error while creating Animal in DB");
            return "redirect:/projects/" + project_id;
        }
    }

    @RequestMapping(value = "projects/{id}/animals/{animal_id}/delete")
    public String delete(@PathVariable("id") long projectId, @PathVariable("animal_id") long animal_id, Model model)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(projectId, user);

            Animal animal = animalsDao.findById(animal_id);

            if (animal == null)
            {
                model.addAttribute("error_massage", "Can not find animal with id = " + animal_id);
                return "redirect:/projects/" + projectId;
            }
            else {
                if (project.getLayers().contains(animal.getLayer())){
                    project.deleteAnimal(animal);
                    projectDao.saveProject(project);
                    animalsDao.delete(animal);
                } else {
                    model.addAttribute("error_massage", "Can not delete animal that belong to other user");
                }
            }

            return "redirect:/projects/" + projectId;
        }
        catch (Exception e)
        {
            model.addAttribute("error_massage", "error while delete animal in DB");
            return "redirect:/projects/" + projectId;
        }
    }
}
