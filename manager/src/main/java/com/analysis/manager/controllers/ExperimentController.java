package com.analysis.manager.controllers;

import com.analysis.manager.modle.Experiment;
import com.analysis.manager.modle.ExperimentDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ExperimentController {
    @Autowired
    private ExperimentDao experimentDao;

    @RequestMapping(value = "experiments/{id}")
    public String view(@PathVariable long id, Model m) {
        Experiment experiment = experimentDao.getById(id);

        m.addAttribute("experiment", experiment);

        return "experiment";
    }
}
