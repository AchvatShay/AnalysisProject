package com.analysis.manager.controllers;

import com.analysis.manager.NeuronsBean;
import com.analysis.manager.modle.*;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

@Controller
public class ProjectsController {
    @Autowired
    private ProjectDao projectDao;

    @Autowired
    private AnalysisTypeDao analysisTypeDao;

    @Autowired
    private ExperimentPelletPertubationDao experimentPelletPertubationDao;

    @Autowired
    private ExperimentInjectionsDao experimentInjectionsDao;

    @Autowired
    private ExperimentTypeDao experimentTypeDao;

    @Autowired
    private ExperimentEventsDao experimentEventsDao;

    @Autowired
    private NeuronsBean neuronsBean;

    @GetMapping(value = {"", "projects"})
    public String index(Model m) {
        try {
            m.addAttribute("my_projects", projectDao.getAll());
        } catch (Exception e)
        {
            m.addAttribute("error_massage", "Error getting projects list from DB");
        }

        return "projects";
    }

    @RequestMapping(value = "projects/{id}")
    public String viewProjects(@PathVariable long id, Model m)
    {
        try {
            Project project = projectDao.getById(id);
            m.addAttribute("project", project);
            m.addAttribute("analysisTypes", analysisTypeDao.getAll());
            m.addAttribute("experiment_type", experimentTypeDao.getAll());
            m.addAttribute("experimentInjections", experimentInjectionsDao.getAll());
            m.addAttribute("experimentEvents", experimentEventsDao.getAll());
            m.addAttribute("pelletPertubations", experimentPelletPertubationDao.getAll());
            m.addAttribute("neuronsBean", neuronsBean);
            m.addAttribute("tree_trials", new JSONObject(trailsToSelect(project)));
            return "project";
        } catch (Exception e)
        {
            m.addAttribute("error_massage", "Error getting project" + id + "from DB");
            return "redirect:/projects";
        }
    }

    @PostMapping("/projects")
    public String create(@ModelAttribute Project project, Model model)
    {
        if (project.getName() == null || project.getName().equals(""))
        {
            model.addAttribute("error_massage", "The Project name is empty");
            return index(model);
        }

        if (project.getDescription() == null || project.getDescription().equals(""))
        {
            model.addAttribute("error_massage", "The Project description is empty");
            return index(model);
        }

        try {
            List<Project> projects = projectDao.getAll();

            if (projects != null) {
                for (Project p : projects) {
                    if (p.getName().equals(project.getName())) {
                        model.addAttribute("error_massage", "The Project name already exists");
                        return index(model);
                    }
                }
            }

            projectDao.create(project);
        } catch (Exception e)
        {
            model.addAttribute("error_massage", "The Project DB creation failed");
            return index(model);
        }

        return "redirect:projects/" + project.getId();
    }

    @RequestMapping(value = "projects/{id}/delete", method = RequestMethod.GET)
    public String delete(@PathVariable long id, Model m)
    {
        try {
            Project projectToDelete = projectDao.getById(id);

            if (projectToDelete != null) {
                projectDao.delete(projectToDelete);
            }
        } catch (Exception e) {
            m.addAttribute("error_massage", "Error deleting project from list in DB");
        }

        return "redirect:/projects";
    }


    public HashMap<String, LinkedList<String>> trailsToSelect(Project project)
    {
        HashMap<String, LinkedList<String>> map = new HashMap<>();

        if (project.getExperiments() != null) {
            for (Object experiment : project.getExperiments()) {
                LinkedList<String> jSonTypes = new LinkedList<>();
                for (Trial trial : ((Experiment)experiment).getTrials())
                {
                    jSonTypes.add((trial.getName()));
                }

                map.put(String.valueOf(((Experiment)experiment).getId()), jSonTypes);
            }
        }

        return map;
    }
}

