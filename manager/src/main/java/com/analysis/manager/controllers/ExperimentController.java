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
public class ExperimentController {
    @Autowired
    private ExperimentDao experimentDao;

    @Autowired
    private TPADao tpaDao;

    @Autowired
    private BDADao bdaDao;

    @Autowired
    private TrialDao trialDao;

    @Autowired
    private ProjectDao projectDao;

    @Autowired
    private AnimalsDao animalsDao;

    @Autowired
    private ExperimentPelletPertubationDao experimentPelletPertubationDao;

    @Autowired
    private ExperimentInjectionsDao experimentInjectionsDao;

    @Autowired
    private ExperimentTypeDao experimentTypeDao;

    @Autowired
    private ExperimentConditionDao experimentConditionDao;

    @RequestMapping(value = "projects/{projectID}/experiments/{id}")
    public String view(@PathVariable long id, @PathVariable("projectID") long project_id,  Model m) {
        try {
            Experiment experiment = experimentDao.getById(id);

            m.addAttribute("experiment", experiment);

            return "experiment";
        } catch (Exception e) {
            return "redirect:projects/" + project_id;
        }
    }

    @RequestMapping(value = "projects/{id}/experiments" , method = RequestMethod.POST)
    public String create(@PathVariable("id") long id, @RequestParam("name") String name, @RequestParam("description") String description,
                         @RequestParam("experiment_animal") long animal_id, @RequestParam("experiment_type") long experiment_type,
                         @RequestParam("experiment_injection") long experiment_injection,
                         @RequestParam("experiment_pelletPertubation") long experiment_pelletPertubation,
                         @RequestParam("behavioral_delay") long behavioral_delay, @RequestParam("duration") long duration,
                         @RequestParam("tone_time") long tone_time, @RequestParam("behavioral_sampling_rate") int behavioral_sampling_rate,
                         @RequestParam("imaging_sampling_rate") int imaging_sampling_rate, @RequestParam("depth") int depth, Model model)

    {
        try {
            Project project = projectDao.getById(id);
            Animal animal = animalsDao.getById(animal_id);
            ExperimentInjections experimentInjections = experimentInjectionsDao.getById(experiment_injection);
            ExperimentType experimentType = experimentTypeDao.getById(experiment_type);
            ExperimentPelletPertubation experimentPelletPertubation = experimentPelletPertubationDao.getById(experiment_pelletPertubation);

            ExperimentCondition experimentCondition = new ExperimentCondition(behavioral_sampling_rate, depth, duration, imaging_sampling_rate,
                    tone_time, behavioral_delay, experimentType, experimentInjections, experimentPelletPertubation);

            experimentConditionDao.create(experimentCondition);

            Experiment experiment = new Experiment(description, name, experimentCondition, new LinkedList<Trial>(), animal, project);
            experimentDao.create(experiment);

            project.AddExperiment(experiment);
            projectDao.update(project);

            return "redirect:/projects/" + id + "/experiments/" + experiment.getId();
        } catch (Exception e)
        {
            model.addAttribute("error_massage", "Error while creating Experiment in DB");
            return "redirect:/projects/" + id;
        }

    }

    @RequestMapping(value = "projects/{id}/experiments/{experiment_id}/delete")
    public String delete(@PathVariable("id") long projectId, @PathVariable("experiment_id") long experiment_id, Model model)
    {
        try {
            Experiment experiment = experimentDao.getById(experiment_id);

            if (experiment == null)
            {
                model.addAttribute("error_massage", "Can not find experiment by id = " + experiment_id);
                return "redirect:/projects/" + projectId;
            }

            Project project = projectDao.getById(projectId);

            project.deleteExperiment(experiment);
            projectDao.update(project);

            experimentDao.delete(experiment);

            return "redirect:/projects/" + projectId;
        }
        catch (Exception e)
        {
            model.addAttribute("error_massage", "error while delete experiment in DB");
            return "redirect:/projects/" + projectId;
        }
    }

    @RequestMapping(value = "projects/{id}/experiments/{experiment_id}/delete/trial/{trial_id}")
    public String deleteTrial(@PathVariable("id") long projectId, @PathVariable("experiment_id") long experiment_id, @PathVariable("trial_id") long trial_id, Model model)
    {
        try {
            Experiment experiment = experimentDao.getById(experiment_id);

            if (experiment == null)
            {
                model.addAttribute("error_massage", "Can not find experiment by id = " + experiment_id);
                return "redirect:/projects/" + projectId;
            }

            Trial trial = trialDao.getById(trial_id);

            experiment.deleteTrial(trial);
            experimentDao.update(experiment);
            trialDao.delete(trial);

            return "redirect:/projects/" + projectId;
        }
        catch (Exception e)
        {
            model.addAttribute("error_massage", "error while delete trial in DB");
            return "redirect:/projects/" + projectId;
        }
    }


    @RequestMapping(value = "projects/{projectID}/experiments/{id}/add_trails")
    public String addTrails(@PathVariable long id, @PathVariable("projectID") long projectId, @RequestParam(value = "files_location") String filesLocation, Model model)
    {
        try {
            Experiment experiment = experimentDao.getById(id);
            List<Trial> trailsListFromFolder = experiment.createTrailsListFromFolder(filesLocation);
            for (Trial trial : trailsListFromFolder) {
                tpaDao.create(trial.getTpa());
                bdaDao.create(trial.getBda());
                trialDao.create(trial);
            }

            experiment.AddTrials(trailsListFromFolder);

            experimentDao.update(experiment);

        }
        catch (Exception e) {
            model.addAttribute("error_massage", "Error while Adding trials to DB");
        }

        return "redirect:/projects/" + projectId + "/experiments/" + id;
    }


    @RequestMapping(value = "projects/{projectID}/experiments/{id}/add_trail")
    public String addTrail(@PathVariable("projectID") long projectId, @PathVariable long id, @RequestParam(value = "bda_location") String BDALocation,
                           @RequestParam(value = "tpa_location") String TPALocation, Model model)
    {
        try {
            Experiment experiment = experimentDao.getById(id);
            TPA tpa = new TPA(TPALocation);
            BDA bda = new BDA(BDALocation);

            tpaDao.create(tpa);
            bdaDao.create(bda);
            Trial trial = new Trial(TPALocation.replace("TPA", "") ,tpa, null, bda, null, experiment);
            trialDao.create(trial);
            experiment.AddTrial(trial);

            experimentDao.update(experiment);
        }catch (Exception e) {
            model.addAttribute("error_massage", "Error while Adding trial to DB");
        }

        return "redirect:/projects/" + projectId + "/experiments/" + id;
    }
}
