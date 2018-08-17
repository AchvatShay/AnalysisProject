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
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
    public ModelAndView createAnimalForProject(@PathVariable("id") long project_id, @RequestParam("name") String name,
                                               @RequestParam("description") String description, @RequestParam("animal_layer") long layer_id,
                                               RedirectAttributes model)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(project_id, user);
            Layer layer = layerDao.findByIdAndProject(layer_id, project);

            if (animalsDao.findByNameAndLayer(name, layer) == null) {
                Animal animal = new Animal(name, description, null, layer);
                project.AddAnimal(animal);
                animalsDao.save(animal);
                projectDao.saveProject(project);
            } else {
                model.addFlashAttribute("error_message", "Animal with this name already exists");
            }

            return new ModelAndView("redirect:/projects/" + project_id);
        }
        catch (Exception e)
        {
            model.addFlashAttribute("error_message", "Error while creating Animal in DB");
            return new ModelAndView("redirect:/projects/" + project_id);
        }
    }

    @RequestMapping(value = "projects/{id}/animals/{animal_id}/delete")
    public ModelAndView delete(@PathVariable("id") long projectId, @PathVariable("animal_id") long animal_id, RedirectAttributes model)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(projectId, user);

            Animal animal = animalsDao.findById(animal_id);

            if (animal == null)
            {
                model.addFlashAttribute("error_message", "Can not find animal with id = " + animal_id);
                return new ModelAndView("redirect:/projects/" + projectId);
            }
            else {
                if (project.getLayers().contains(animal.getLayer())){
                    project.deleteAnimal(animal);
                    projectDao.saveProject(project);
                    animalsDao.delete(animal);
                } else {
                    model.addFlashAttribute("error_message", "Can not delete animal that belong to other user");
                }
            }

            return new ModelAndView("redirect:/projects/" + projectId);
        }
        catch (Exception e)
        {
            model.addFlashAttribute("error_message", "error while delete animal in DB");
            return new ModelAndView("redirect:/projects/" + projectId);
        }
    }
}
