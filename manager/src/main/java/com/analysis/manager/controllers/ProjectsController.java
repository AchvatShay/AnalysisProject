package com.analysis.manager.controllers;

import com.analysis.manager.Dao.*;
import com.analysis.manager.NeuronsBean;
import com.analysis.manager.Service.ProjectService;
import com.analysis.manager.Service.UserService;
import com.analysis.manager.modle.*;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;

@Controller
public class ProjectsController {
    @Autowired
    private ProjectService projectDao;

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

    @Autowired
    private UserService userService;

    @GetMapping(value = {"", "projects"})
    public String index(Model m) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            m.addAttribute("my_projects", projectDao.findAllByUser(user));
        } catch (Exception e)
        {
            m.addAttribute("error_message", "Error getting projects list from DB");
        }

        return "projects";
    }

    @RequestMapping(value = "projects/{id}")
    public String viewProject(@PathVariable long id, Model m)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(id, user);
            m.addAttribute("project", project);
            m.addAttribute("analysisTypes", analysisTypeDao.findAll());
            m.addAttribute("experiment_type", experimentTypeDao.findAll());
            m.addAttribute("experimentInjections", experimentInjectionsDao.findAll());
            m.addAttribute("experimentEvents", experimentEventsDao.findAll());
            m.addAttribute("pelletPertubations", experimentPelletPertubationDao.findAll());
            m.addAttribute("neuronsBean", neuronsBean);
            m.addAttribute("tree_trials", new JSONObject(trailsToSelect(project)));
            return "project";
        } catch (Exception e)
        {
            m.addAttribute("error_message", "Error getting project" + id + "from DB");
            return index(m);
        }
    }

    @PostMapping("/projects")
    public String create(@RequestParam String name, @RequestParam String description, Model model)
    {

        if (name == null || name.equals(""))
        {
            model.addAttribute("error_message", "The Project name is empty");
            return index(model);
        }

        if (description == null || description.equals(""))
        {
            model.addAttribute("error_message", "The Project description is empty");
            return index(model);
        }

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());

            if (projectDao.existsByName(name))
            {
                model.addAttribute("error_message", "The Project name already exists");
                return index(model);
            } else {
                Project project = new Project(user, name, description);
                projectDao.saveProject(project);

                return viewProject(project.getId(), model);
            }
        } catch (Exception e)
        {
            model.addAttribute("error_message", "The Project DB creation failed");
            return index(model);
        }
    }

    @RequestMapping(value = "projects/{id}/delete", method = RequestMethod.GET)
    public String delete(@PathVariable long id, Model m)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());

            Project projectToDelete = projectDao.findByIdAndUser(id, user);

            if (projectToDelete != null) {
                projectDao.deleteProject(projectToDelete);
            }
        } catch (Exception e) {
            m.addAttribute("error_message", "Error deleting project from list in DB");
        }

        return index(m);
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

