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

    @RequestMapping(value = {"", "projects"})
    public String index(Model m) {
        if (projects == null)
        {
            projects = projectDao.getAll();
        }

        m.addAttribute("my_projects", projects);
        return "projects";
    }

    @RequestMapping("/projects/create")
    public String create(String name, String Description)
    {
        Project project = new Project(name, Description, null, null, null);
        projects.add(project);
        projectDao.create(project);
        return "projects";
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

        return "redirect:projects";
    }


    @RequestMapping(value = "projects/edit/{id}")
    public String edit(@PathVariable long id)
    {
        return "project/" + id;
    }
}
