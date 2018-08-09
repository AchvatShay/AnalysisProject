package com.analysis.manager.controllers;

import com.analysis.manager.modle.Layer;
import com.analysis.manager.modle.LayerDao;
import com.analysis.manager.modle.Project;
import com.analysis.manager.modle.ProjectDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class LayersController {

    @Autowired
    private ProjectDao projectDao;

    @Autowired
    private LayerDao layerDao;

    @RequestMapping(value = "projects/{id}/layers", method = RequestMethod.POST)
    public String addLayer(@PathVariable("id") long projectId, @RequestParam("name") String name, Model model)
    {

        if (layerDao.getByName(name) != null)
        {
            model.addAttribute("error_massage", "The Layer already exists");
            return "redirect:/projects/" + projectId;
        }

        Layer layer = new Layer(name, null);

        try {
            Project project = projectDao.getById(projectId);

            layerDao.create(layer);

            project.AddLayer(layer);

            projectDao.update(project);

            return "redirect:/projects/" + projectId;
        }
        catch (Exception e)
        {
            model.addAttribute("error_massage", "error while creating layer in DB");
            return "redirect:/projects/" + projectId;
        }
    }
}
