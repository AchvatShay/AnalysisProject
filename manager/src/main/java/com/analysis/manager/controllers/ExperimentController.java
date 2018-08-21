package com.analysis.manager.controllers;

import com.analysis.manager.Dao.*;
import com.analysis.manager.NeuronsBean;
import com.analysis.manager.Service.*;
import com.analysis.manager.modle.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.util.LinkedList;
import java.util.List;

@Controller
public class ExperimentController {
    @Autowired
    private ExperimentService experimentDao;

    @Qualifier("tpaRepository")
    @Autowired
    private TpaRepository tpaRepository;

    @Qualifier("bdaRepository")
    @Autowired
    private BDADao bdaDao;

    @Autowired
    private AnalysisTypeDao analysisTypeDao;

    @Autowired
    private ExperimentEventsDao experimentEventsDao;

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

    @Autowired
    private NeuronsBean neuronsBean;

    private static final Logger logger = LoggerFactory.getLogger(ExperimentController.class);

    @RequestMapping(value = "projects/{projectID}/experiments/{id}")
    public ModelAndView view(@PathVariable long id, @PathVariable("projectID") long project_id, Model m) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(project_id, user);

            Experiment experiment = experimentDao.findByIdAndProject(id, project);

            m.addAttribute("experiment", experiment);
            m.addAttribute("current_user", user.getName() + " " + user.getLastName());
            return new ModelAndView("experiment");
        } catch (Exception e) {
            logger.error(e.getMessage());
            return new ModelAndView("redirect:/projects/" + project_id);
        }
    }

    @RequestMapping(value = "projects/{projectID}/experiments/{id}/createAnalysis")
    public ModelAndView viewCreateAnalysis(@PathVariable long id, @PathVariable("projectID") long project_id, Model m) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(project_id, user);

            Experiment experiment = experimentDao.findByIdAndProject(id, project);
            m.addAttribute("analysisTypes", analysisTypeDao.findAll());
            m.addAttribute("experimentEvents", experimentEventsDao.findAll());
            m.addAttribute("experiment", experiment);
            m.addAttribute("neurons", experiment.getNeuronsName().split(","));
            m.addAttribute("trials", experiment.getTrials());
            m.addAttribute("current_user", user.getName() + " " + user.getLastName());
            return new ModelAndView("createAnalysis");
        } catch (Exception e) {
            logger.error(e.getMessage());
            return new ModelAndView("redirect:/projects/" + project_id);
        }
    }

    @RequestMapping(value = "projects/{id}/experiments" , method = RequestMethod.POST)
    public ModelAndView create(@PathVariable("id") long id, @RequestParam("name") String name, @RequestParam("description") String description,
                         @RequestParam("experiment_animal") long animal_id, @RequestParam("experiment_type") long experiment_type,
                         @RequestParam("experiment_injection") long experiment_injection,
                         @RequestParam("experiment_pelletPertubation") long experiment_pelletPertubation,
                         @RequestParam("behavioral_delay") long behavioral_delay, @RequestParam("duration") long duration,
                         @RequestParam("tone_time") long tone_time, @RequestParam("behavioral_sampling_rate") int behavioral_sampling_rate,
                         @RequestParam("imaging_sampling_rate") int imaging_sampling_rate, @RequestParam("depth") int depth, RedirectAttributes model)

    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(id, user);

            Animal animal = animalsDao.findById(animal_id);

            if (animal.getLayer().getProject().getId() != project.getId()) {
                model.addFlashAttribute("error_message", "The animal selected do not belong to this user");
                return new ModelAndView("redirect:/projects/" + id);
            }

            ExperimentInjections experimentInjections = experimentInjectionsDao.findById(experiment_injection);
            ExperimentType experimentType = experimentTypeDao.findById(experiment_type);
            ExperimentPelletPertubation experimentPelletPertubation = experimentPelletPertubationDao.findById(experiment_pelletPertubation);

            ExperimentCondition experimentCondition = new ExperimentCondition(behavioral_sampling_rate, depth, duration, imaging_sampling_rate,
                    tone_time, behavioral_delay, experimentType, experimentInjections, experimentPelletPertubation);

            experimentConditionDao.save(experimentCondition);

            Experiment experiment = new Experiment(description, name, experimentCondition, new LinkedList<Trial>(), animal, project, "");
            experimentDao.save(experiment);

            project.AddExperiment(experiment);
            projectDao.saveProject(project);

            return new ModelAndView("redirect:/projects/" + id + "/experiments/" + experiment.getId());
        } catch (Exception e)
        {
            logger.error(e.getMessage());
            model.addFlashAttribute("error_message", "Error while creating Experiment in DB");
            return new ModelAndView("redirect:/projects/" + id);
        }

    }

    @RequestMapping(value = "projects/{id}/experiments/{experiment_id}/delete")
    public ModelAndView delete(@PathVariable("id") long projectId, @PathVariable("experiment_id") long experiment_id, RedirectAttributes model)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(projectId, user);

            Experiment experiment = experimentDao.findByIdAndProject(experiment_id, project);

            if (experiment == null)
            {
                model.addFlashAttribute("error_message", "Can not find experiment by id = " + experiment_id);
                return new ModelAndView("redirect:/projects/" + projectId);
            }


            project.deleteExperiment(experiment);
            projectDao.saveProject(project);

            experimentDao.delete(experiment);

            return new ModelAndView("redirect:/projects/" + projectId);
        }
        catch (Exception e)
        {
            logger.error(e.getMessage());
            model.addFlashAttribute("error_message", "error while delete experiment in DB");
            return new ModelAndView("redirect:/projects/" + projectId);
        }
    }

    @RequestMapping(value = "projects/{id}/experiments/{experiment_id}/delete/trial/{trial_id}")
    public ModelAndView deleteTrial(@PathVariable("id") long projectId, @PathVariable("experiment_id") long experiment_id, @PathVariable("trial_id") long trial_id, RedirectAttributes model)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(projectId, user);

            Experiment experiment = experimentDao.findByIdAndProject(experiment_id, project);


            if (experiment == null)
            {
                model.addFlashAttribute("error_message", "Can not find experiment by id = " + experiment_id);
                return new ModelAndView("redirect:/projects/" + projectId + "/experiments/" + experiment_id);
            }

            Trial trial = trialDao.findByIdAndExperiment(trial_id, experiment);

            experiment.deleteTrial(trial);

            if (experiment.getTrials().isEmpty()) {
                experiment.setNeuronsName("");
            }

            experimentDao.save(experiment);
            trialDao.deleteTrial(trial);

            return new ModelAndView("redirect:/projects/" + projectId + "/experiments/" + experiment_id);
        }
        catch (Exception e)
        {
            logger.error(e.getMessage());
            model.addFlashAttribute("error_message", "error while delete trial in DB");
            return new ModelAndView("redirect:/projects/" + projectId + "/experiments/" + experiment_id);
        }
    }

    @RequestMapping(value = "projects/{id}/experiments/{experiment_id}/delete/trials")
    public ModelAndView deleteTrials(@PathVariable("id") long projectId, @PathVariable("experiment_id") long experiment_id, RedirectAttributes model)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(projectId, user);

            Experiment experiment = experimentDao.findByIdAndProject(experiment_id, project);


            if (experiment == null)
            {
                model.addFlashAttribute("error_message", "Can not find experiment by id = " + experiment_id);
                return new ModelAndView("redirect:/projects/" + projectId + "/experiments/" + experiment_id);
            }



            experiment.setTrials(new LinkedList());
            experiment.setNeuronsName("");
            experimentDao.save(experiment);
            trialDao.deleteAllByExperiment(experiment);

            return new ModelAndView("redirect:/projects/" + projectId + "/experiments/" + experiment_id);
        }
        catch (Exception e)
        {
            logger.error(e.getMessage());
            model.addFlashAttribute("error_message", "error while delete trial in DB");
            return new ModelAndView("redirect:/projects/" + projectId + "/experiments/" + experiment_id);
        }
    }


    @RequestMapping(value = "projects/{projectID}/experiments/{id}/add_trails")
    public ModelAndView addTrails(@PathVariable long id, @PathVariable("projectID") long projectId, @RequestParam(value = "files_location") String filesLocation, RedirectAttributes model)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(projectId, user);

            Experiment experiment = experimentDao.findByIdAndProject(id, project);

            List<Trial> trailsListFromFolder = experiment.createTrailsListFromFolder(filesLocation);

            if (trailsListFromFolder.isEmpty()) {
                model.addFlashAttribute("error_message", "The folder does not have trails");
                return new ModelAndView("redirect:/projects/" + projectId + "/experiments/" + id);
            }

            StringBuilder stringBuilder = new StringBuilder();
            for (Trial trial : trailsListFromFolder) {

                if (trialDao.findByNameAndExperiment(trial.getName(), experiment) == null)
                {
                    TPA tpa = tpaRepository.findByFileLocation(trial.getTpa().getFileLocation());
                    if (tpa == null) {
                        tpaRepository.save(trial.getTpa());
                    } else {
                        model.addFlashAttribute("error_message", "The trial already exists");
                        return new ModelAndView("redirect:/projects/" + projectId + "/experiments/" + id);
                    }

                    BDA bda = bdaDao.findByFileLocation(trial.getBda().getFileLocation());
                    if (bda == null) {
                        bdaDao.save(trial.getBda());
                    } else {
                        model.addFlashAttribute("error_message", "The trial already exists");
                        return new ModelAndView("redirect:/projects/" + projectId + "/experiments/" + id);
                    }

                    trialDao.save(trial);
                    experiment.AddTrial(trial);
                } else {
                    stringBuilder.append("The trial already exists").append(trial.getName()).append("\n");
                }
            }

            if (!stringBuilder.toString().isEmpty()) {
                model.addFlashAttribute("error_message", stringBuilder.toString());
            }

            if (experiment.getNeuronsName() == null || experiment.getNeuronsName().isEmpty()) {
                experiment.setNeuronsName(neuronsBean.getNeurons(experiment));
            }

            experimentDao.save(experiment);
        }
        catch (Exception e) {
            logger.error(e.getMessage());
            model.addFlashAttribute("error_message", "Error while Adding trials to DB");
        }

        return new ModelAndView("redirect:/projects/" + projectId + "/experiments/" + id);
    }


    @RequestMapping(value = "projects/{projectID}/experiments/{id}/add_trail")
    public ModelAndView addTrail(@PathVariable("projectID") long projectId, @PathVariable long id, @RequestParam(value = "bda_location") String BDALocation,
                           @RequestParam(value = "tpa_location") String TPALocation, RedirectAttributes model)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(projectId, user);

            Experiment experiment = experimentDao.findByIdAndProject(id, project);

            if (!BDALocation.endsWith(".mat") || !BDALocation.contains("BDA"))
            {
                model.addFlashAttribute("error_message", "The BDA location is incorrect");
            } else if (!TPALocation.endsWith(".mat") || !TPALocation.contains("TPA")) {
                model.addFlashAttribute("error_message", "The TPA location is incorrect");
            } else {
                File fileBDA = new File(BDALocation);
                File fileTPA = new File(TPALocation);

                if (!fileBDA.exists() || fileBDA.isDirectory()) {
                    model.addFlashAttribute("error_message", "The BDA location does not exist or the location is directory");
                } else if (!fileTPA.exists() || fileTPA.isDirectory()) {
                    model.addFlashAttribute("error_message", "The TPA location does not exist or the location is directory");
                } else {
                    TPA tpa = new TPA(TPALocation);
                    BDA bda = new BDA(BDALocation);

                    String trialName = fileTPA.getName().replace("TPA", "");

                    if (trialDao.findByNameAndExperiment(trialName, experiment) == null)
                    {
                        TPA tpaDB = tpaRepository.findByFileLocation(tpa.getFileLocation());
                        if (tpaDB == null) {
                            tpaRepository.save(tpa);
                        } else {
                            model.addFlashAttribute("error_message", "The trial already exists");
                            return new ModelAndView("redirect:/projects/" + projectId + "/experiments/" + id);
                        }

                        BDA bdaDB = bdaDao.findByFileLocation(bda.getFileLocation());
                        if (bdaDB == null) {
                            bdaDao.save(bda);
                        } else {
                            model.addFlashAttribute("error_message", "The trial already exists");
                            return new ModelAndView("redirect:/projects/" + projectId + "/experiments/" + id);
                        }

                        Trial trial = new Trial(trialName, tpa, null, bda, null, experiment);
                        trialDao.save(trial);
                        experiment.AddTrial(trial);

                        if (experiment.getNeuronsName() == null || experiment.getNeuronsName().isEmpty()) {
                            experiment.setNeuronsName(neuronsBean.getNeurons(experiment));
                        }

                        experimentDao.save(experiment);
                    } else {
                        model.addFlashAttribute("error_message", "The trial already exists" + trialName + "\n");
                    }
                }
            }
        }catch (Exception e) {
            logger.error(e.getMessage());
            model.addFlashAttribute("error_message", "Error while Adding trial to DB");
        }

        return new ModelAndView("redirect:/projects/" + projectId + "/experiments/" + id);
    }
}
