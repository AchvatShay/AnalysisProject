package com.analysis.manager.controllers;

import com.analysis.manager.Service.LayerService;
import com.analysis.manager.Service.ProjectService;
import com.analysis.manager.Service.UserService;
import com.analysis.manager.modle.Layer;
import com.analysis.manager.modle.Project;
import com.analysis.manager.modle.User;
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
public class LayersController {

    @Autowired
    private ProjectService projectDao;

    @Autowired
    private LayerService layerDao;

    @Autowired
    private UserService userService;

    @RequestMapping(value = "projects/{id}/layers", method = RequestMethod.POST)
    public String addLayer(@PathVariable("id") long projectId, @RequestParam("name") String name, Model model)
    {

        if (layerDao.existsByName(name))
        {
            model.addAttribute("error_massage", "The Layer already exists");
            return "redirect:/projects/" + projectId;
        }


        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());

            Project project = projectDao.findByIdAndUser(projectId, user);
            Layer layer = new Layer(name, null, project);

            layerDao.save(layer);

            project.AddLayer(layer);

            projectDao.saveProject(project);

            return "redirect:/projects/" + projectId;
        }
        catch (Exception e)
        {
            model.addAttribute("error_massage", "error while creating layer in DB");
            return "redirect:/projects/" + projectId;
        }
    }

    @RequestMapping(value = "projects/{id}/layers/{layer_id}/delete")
    public String delete(@PathVariable("id") long projectId, @PathVariable("layer_id") long layerId, Model model)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findById(projectId);
            Layer layer = layerDao.findByIdAndProject(layerId, project);

            if (layer == null)
            {
                model.addAttribute("error_massage", "Can not find layer by id = " + layerId);
                return "redirect:/projects/" + projectId;
            }


            project.deleteLayer(layer);
            projectDao.saveProject(project);
            layerDao.delete(layer);

            return "redirect:/projects/" + projectId;
        }
        catch (Exception e)
        {
            model.addAttribute("error_massage", "error while delete layer in DB");
            return "redirect:/projects/" + projectId;
        }
    }
}
