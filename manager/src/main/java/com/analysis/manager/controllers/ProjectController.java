package com.analysis.manager.controllers;

import com.analysis.manager.modle.Project;
import com.analysis.manager.modle.ProjectDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ProjectController {
    @Autowired
    private ProjectDao projectDao;

    @RequestMapping(value = "project/{id}")
    public String view(@PathVariable long id, Model m)
    {
        Project project = projectDao.getById(id);
        m.addAttribute("project", project);

        return "project";
    }
}
