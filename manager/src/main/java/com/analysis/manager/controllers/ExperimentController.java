package com.analysis.manager.controllers;

import com.analysis.manager.modle.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class ExperimentController {
    @Autowired
    private ExperimentDao experimentDao;

    @Autowired
    private TPADao tpaDao;

    @Autowired
    private BDADao bdaDao;

    @Autowired
    private TrialDao trialDao;

    @RequestMapping(value = "experiments/{id}")
    public String view(@PathVariable long id, Model m) {
        Experiment experiment = experimentDao.getById(id);

        m.addAttribute("experiment", experiment);

        return "experiment";
    }

    @RequestMapping(value = "experiments/add_trails")
    public String addTrails(@PathVariable long id, @RequestParam(value = "files_location") String filesLocation)
    {
        Experiment experiment = experimentDao.getById(id);
        List<Trial> trailsListFromFolder = experiment.createTrailsListFromFolder(filesLocation);
        for (Trial trial : trailsListFromFolder) {
            tpaDao.create(trial.getTpa());
            bdaDao.create(trial.getBda());
            trialDao.create(trial);
        }

        return "experiment";
    }

    @RequestMapping(value = "experiments/add_trail")
    public String addTrail(@PathVariable long id, @RequestParam(value = "bda_location") String BDALocation, @RequestParam(value = "tpa_location") String TPALocation)
    {
        Experiment experiment = experimentDao.getById(id);
        TPA tpa = new TPA(TPALocation);
        BDA bda = new BDA(BDALocation);

        tpaDao.create(tpa);
        bdaDao.create(bda);
        trialDao.create(new Trial(tpa, null, bda, null, experiment));

        return "experiment";
    }
}
