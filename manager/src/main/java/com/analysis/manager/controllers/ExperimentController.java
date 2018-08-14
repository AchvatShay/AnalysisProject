package com.analysis.manager.controllers;

import com.analysis.manager.Dao.*;
import com.analysis.manager.Service.AnimalsService;
import com.analysis.manager.Service.ProjectService;
import com.analysis.manager.Service.TrialService;
import com.analysis.manager.Service.UserService;
import com.analysis.manager.modle.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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

    @Qualifier("tpaRepository")
    @Autowired
    private TpaRepository tpaRepository;

    @Qualifier("bdaRepository")
    @Autowired
    private BDADao bdaDao;

    @Autowired
    private TrialService trialDao;

    @Autowired
    private ProjectService projectDao;

    @Autowired
    private AnimalsService animalsDao;

    @Autowired
    private ExperimentPelletPertubationDao experimentPelletPertubationDao;

    @Autowired
    private ExperimentInjectionsDao experimentInjectionsDao;

    @Autowired
    private ExperimentTypeDao experimentTypeDao;

    @Autowired
    private ExperimentConditionDao experimentConditionDao;

    @Autowired
    private UserService userService;

    @RequestMapping(value = "projects/{projectID}/experiments/{id}")
    public String view(@PathVariable long id, @PathVariable("projectID") long project_id,  Model m) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(project_id, user);

            Experiment experiment = experimentDao.findByIdAndProject(id, project);

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
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(id, user);

            Animal animal = animalsDao.findById(animal_id);
            ExperimentInjections experimentInjections = experimentInjectionsDao.findById(experiment_injection);
            ExperimentType experimentType = experimentTypeDao.findById(experiment_type);
            ExperimentPelletPertubation experimentPelletPertubation = experimentPelletPertubationDao.findById(experiment_pelletPertubation);

            ExperimentCondition experimentCondition = new ExperimentCondition(behavioral_sampling_rate, depth, duration, imaging_sampling_rate,
                    tone_time, behavioral_delay, experimentType, experimentInjections, experimentPelletPertubation);

            experimentConditionDao.save(experimentCondition);

            Experiment experiment = new Experiment(description, name, experimentCondition, new LinkedList<Trial>(), animal, project);
            experimentDao.save(experiment);

            project.AddExperiment(experiment);
            projectDao.saveProject(project);

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
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(projectId, user);

            Experiment experiment = experimentDao.findByIdAndProject(experiment_id, project);

            if (experiment == null)
            {
                model.addAttribute("error_massage", "Can not find experiment by id = " + experiment_id);
                return "redirect:/projects/" + projectId;
            }


            project.deleteExperiment(experiment);
            projectDao.saveProject(project);

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
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(projectId, user);

            Experiment experiment = experimentDao.findByIdAndProject(experiment_id, project);


            if (experiment == null)
            {
                model.addAttribute("error_massage", "Can not find experiment by id = " + experiment_id);
                return "redirect:/projects/" + projectId;
            }

            Trial trial = trialDao.findByIdAndExperiment(trial_id, experiment);

            experiment.deleteTrial(trial);
            experimentDao.save(experiment);
            trialDao.deleteTrial(trial);

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
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(projectId, user);

            Experiment experiment = experimentDao.findByIdAndProject(id, project);

            List<Trial> trailsListFromFolder = experiment.createTrailsListFromFolder(filesLocation);
            for (Trial trial : trailsListFromFolder) {

                if (trialDao.findByNameAndExperiment(trial.getName(), experiment) == null)
                {
                    TPA tpa = tpaRepository.findByFileLocation(trial.getTpa().getFileLocation());
                    if (tpa == null) {
                        tpaRepository.save(trial.getTpa());
                    } else {
                        trial.setTpa(tpa);
                    }

                    BDA bda = bdaDao.findByFileLocation(trial.getBda().getFileLocation());
                    if (bda == null) {
                        bdaDao.save(trial.getBda());
                    } else {
                        trial.setBda(bda);
                    }

                    trialDao.save(trial);
                    experiment.AddTrial(trial);
                }
            }

            experimentDao.save(experiment);
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
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(projectId, user);

            Experiment experiment = experimentDao.findByIdAndProject(id, project);
            TPA tpa = new TPA(TPALocation);
            BDA bda = new BDA(BDALocation);

            String trialName = TPALocation.replace("TPA", "");

            if (trialDao.findByNameAndExperiment(trialName, experiment) == null)
            {
                if (!tpaRepository.existsByFileLocation(tpa.getFileLocation())) {
                    tpaRepository.save(tpa);
                }

                if (!bdaDao.existsByFileLocation(bda.getFileLocation())) {
                    bdaDao.save(bda);
                }
                Trial trial = new Trial(trialName, tpa, null, bda, null, experiment);
                trialDao.save(trial);
                experiment.AddTrial(trial);
                experimentDao.save(experiment);
            }
        }catch (Exception e) {
            model.addAttribute("error_massage", "Error while Adding trial to DB");
        }

        return "redirect:/projects/" + projectId + "/experiments/" + id;
    }
}
