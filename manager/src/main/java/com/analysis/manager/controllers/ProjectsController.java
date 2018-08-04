package com.analysis.manager.controllers;

import com.analysis.manager.modle.Project;
import com.analysis.manager.modle.ProjectDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class ProjectsController {
    @Autowired
    private ProjectDao projectDao;

    private List<Project> projects;

    @GetMapping(value = {"", "projects"})
    public String index(Model m) {
        if (projects == null)
        {
            projects = projectDao.getAll();
        }

        m.addAttribute("my_projects", projects);
        return "projects";
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

        for (Project p: projects) {
            if (p.getName().equals(project.getName()))
            {
                model.addAttribute("error_massage", "The Project name already exists");
                return index(model);
            }
        }

        projects.add(project);

        try {
            projectDao.create(project);
        } catch (Exception e)
        {
            model.addAttribute("error_massage", "The Project DB creation failed");
            return index(model);
        }

        return "redirect:project/" + project.getId();
    }

    @RequestMapping(value = "projects/delete/{id}")
    public String delete(@PathVariable long id)
    {
        if (projects == null)
        {
            return "";
        }

        Project projectToDelete = null;
        for (Project project: projects) {
            if (project.getId() == id)
            {
                projectToDelete = project;
                break;
            }
        }

        if (projectToDelete != null)
        {
            projectDao.delete(projectToDelete);
            projects.remove(projectToDelete);
        }

        return "redirect:/projects";
    }
}
