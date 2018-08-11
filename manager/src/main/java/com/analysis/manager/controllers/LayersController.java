package com.analysis.manager.controllers;

import com.analysis.manager.modle.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.LinkedList;
import java.util.List;

@Controller
public class LayersController {

    @Autowired
    private ProjectDao projectDao;

    @Autowired
    private LayerDao layerDao;

    @Autowired
    private AnimalsDao animalsDao;

    @Autowired
    private ExperimentDao experimentDao;

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

    @RequestMapping(value = "projects/{id}/layers/{layer_id}/delete")
    public String delete(@PathVariable("id") long projectId, @PathVariable("layer_id") long layerId, Model model)
    {
        try {
            Layer layer = layerDao.getById(layerId);

            if (layer == null)
            {
                model.addAttribute("error_massage", "Can not find layer by id = " + layerId);
                return "redirect:/projects/" + projectId;
            }

            Project project = projectDao.getById(projectId);
            project.deleteLayer(layer);
            projectDao.update(project);
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
