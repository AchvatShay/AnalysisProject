package com.analysis.manager.controllers;

import AnalysisManager.RunAnalysis;
import com.analysis.manager.Dao.AnalysisTypeDao;
import com.analysis.manager.Dao.ExperimentEventsDao;
import com.analysis.manager.ExperimentDataBean;
import com.analysis.manager.Service.AnalysisService;
import com.analysis.manager.Service.ExperimentService;
import com.analysis.manager.Service.ProjectService;
import com.analysis.manager.Service.UserService;
import com.analysis.manager.XmlCreator;
import com.analysis.manager.modle.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

@Controller
public class AccuracyAnalysisController {
    @Autowired
    private UserService userService;

    @Autowired
    private ProjectService projectDao;

    @Autowired
    private AnalysisService analysisDao;

    @Autowired
    private XmlCreator xmlCreator;

    @Autowired
    private ExperimentDataBean experimentDataBean;

    @Autowired
    private AnalysisTypeDao analysisTypeDao;

    @Autowired
    private RunAnalysis runAnalysis;

    @Autowired
    private ExperimentService experimentDao;

    @Autowired
    private ExperimentEventsDao experimentEventsDao;

    private static final Logger logger = LoggerFactory.getLogger(AccuracyAnalysisController.class);

    @Value("${analysis.results.location}")
    private String pathAnalysis;

    @RequestMapping(value = "projects/{id}/analysis/accuracy/phaseA")
    public ModelAndView createAccuracyAnalysis(@PathVariable long id, Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.findUserByEmail(auth.getName());
        Project project = projectDao.findByIdAndUser(id, user);

        model.addAttribute("project", project);
        model.addAttribute("current_user", user.getName() + " " + user.getLastName());

        return new ModelAndView("createAnalysisAccuracy");
    }

    @PostMapping(value = "projects/{id}/analysis/accuracy/checkExperiments")
    public ResponseEntity checkExperiments(@PathVariable long id, @RequestParam("trialsSelected") List<Long> trialsSelected)
    {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.findUserByEmail(auth.getName());
        Project project = projectDao.findByIdAndUser(id, user);

        LinkedList<Experiment> experiments = new LinkedList<>();
        for (Long ex_id : trialsSelected) {
            experiments.add(experimentDao.findByIdAndProject(ex_id, project));
        }

        if (!experiments.isEmpty()) {
            Experiment prev = experiments.getFirst();
            ExperimentCondition prevCondition = prev.getExperimentCondition();
            for (Experiment experiment : experiments) {
                if (!experiment.equals(prev)) {
                    ExperimentCondition experimentCondition = experiment.getExperimentCondition();

                    if (experiment.getProject().getId() != prev.getProject().getId() ||
                            prevCondition.getExperimentType().getId() != experimentCondition.getExperimentType().getId() ||
                            prevCondition.getBehavioral_delay() != experimentCondition.getBehavioral_delay() ||
                            prevCondition.getBehavioral_sampling_rate() != experimentCondition.getBehavioral_sampling_rate() ||
                            prevCondition.getDepth() != experimentCondition.getDepth() ||
                            prevCondition.getDuration() != experimentCondition.getDuration() ||
                            prevCondition.getExperimentInjections().getId() != experimentCondition.getExperimentInjections().getId() ||
                            prevCondition.getExperimentPelletPertubation().getId() != experimentCondition.getExperimentPelletPertubation().getId() ||
                            prevCondition.getImaging_sampling_rate() != experimentCondition.getImaging_sampling_rate() ||
                            prevCondition.getTone_time() != experimentCondition.getTone_time()) {
                        return ResponseEntity.ok(false);
                    }
                }
            }

            return ResponseEntity.ok(true);
        }

        return ResponseEntity.ok(false);
    }

    @RequestMapping(value = "projects/{projects_id}/analysis/accuracy/create", method = RequestMethod.POST)
    public ModelAndView create(@PathVariable("projects_id") long id,
                               @RequestParam("name") String name, @RequestParam("description") String description,
                               @RequestParam("startTime2plot") double startTime2plot,
                               @RequestParam("font_size") double font_size,
                               @RequestParam(value = "trialsSelected") LinkedList<String> trials,
                               @RequestParam(value = "types") LinkedList<Long> types,
                               @RequestParam(value = "labels", required = false) List<String> labels,
                               @RequestParam("foldsNum") double foldsNum,
                               @RequestParam(value = "events", required = false) LinkedList<Long> events,
                               @RequestParam("linearSVN") String linearSVN,
                               @RequestParam("slidingWinLen") double slidingWinLen,
                               @RequestParam("slidingWinHop") double slidingWinHop,
                               @RequestParam("conf_percent4acc") double conf_percent4acc,
                               @RequestParam("time4confplot") double time4confplot,
                               @RequestParam("includeO") String includeO,
                               @RequestParam("DetermineSucFailBy") String DetermineSucFailBy,
                               @RequestParam("time4confplotNext") double time4confplotNext,
                               @RequestParam("bestpcatrajectories2plot") double bestpcatrajectories2plot,
                               RedirectAttributes model)
    {

        if (trials == null || trials.isEmpty())
        {
            model.addFlashAttribute("error_message", "failed to create analysis, empty trials");
            model.addAttribute("tif", new LinkedList<String>());
            return new ModelAndView("redirect:/projects/" + id + "/analysis/accuracy/phaseA");
        }

        if (labels == null || labels.isEmpty() || labels.size() != 2)
        {
            model.addFlashAttribute("error_message", "failed to create analysis, must has 2 labels");
            model.addAttribute("tif", new LinkedList<String>());
            return new ModelAndView("redirect:/projects/" + id + "/analysis/accuracy/phaseA");
        }

        LinkedList<AnalysisType> analysisTypes = new LinkedList<>();
        try {
            LinkedList<ExperimentEvents> experimentEvents = new LinkedList<>();

            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());

            Project project = projectDao.findByIdAndUser(id, user);


            if (analysisDao.existsByNameAndUser(name, user)) {
                model.addFlashAttribute("error_message", "failed to create analysis, this analysis name already exists");
                return new ModelAndView("redirect:/projects/" + id + "/analysis/accuracy/phaseA");
            }

            for (long id_type : types) {
                AnalysisType analysisType = analysisTypeDao.findById(id_type);
                analysisTypes.add(analysisType);
            }

            LinkedList<Trial> allTrials = new LinkedList<>();
            HashMap<Long, Experiment> experiments = new HashMap<>();

            if (events != null) {
                for (long id_event : events) {
                    ExperimentEvents eventsDaoById = experimentEventsDao.findById(id_event);
                    experimentEvents.add(eventsDaoById);
                }

            }

            long experimentId = 0;
            for (String str : trials)
            {
                String[] split = str.split("_");

                long trialId = Long.parseLong(split[1]);
                experimentId = Long.parseLong(split[0]);

                if (!experiments.containsKey(experimentId)) {
                    experiments.put(experimentId, experimentDao.findByIdAndProject(experimentId, project));
                }

                for (Trial trial: experiments.get(experimentId).getTrials())
                {
                    if (trial.getId() == trialId)
                    {
                        allTrials.add(trial);
                    }
                }
            }

            Analysis analysis = new Analysis(name, description, user, analysisTypes, allTrials, experiments.get(experimentId));
            analysisDao.save(analysis);
            project.AddAnalysis(analysis);
            projectDao.saveProject(project);

            if (!xmlCreator.createXml(analysis, font_size, Arrays.asList(experimentDataBean.getNeurons(experiments.get(experimentId)).split(",")), new LinkedList<>(), experimentEvents, startTime2plot, 0, 0, 0, 0, foldsNum, linearSVN, slidingWinLen, slidingWinHop, conf_percent4acc, time4confplot, time4confplotNext, includeO, DetermineSucFailBy, labels, bestpcatrajectories2plot)) {
                model.addFlashAttribute("error_message", "Error while creating Analysis Xml");
                return new ModelAndView("redirect:/projects/" + id + "/analysis/accuracy/phaseA");
            }

            if (runAnalysis == null)
            {
                model.addFlashAttribute("error_message", "Error bean name for matlab");
                return new ModelAndView("redirect:/projects/" + id + "/analysis/accuracy/phaseA");
            }

            String errors = experimentDataBean.sendToMatlab(analysis);

            if (!errors.isEmpty()) {
                model.addFlashAttribute("error_message", errors);
                return new ModelAndView("redirect:/projects/" + id + "/analysis/accuracy/phaseA");
            }

            return new ModelAndView("redirect:/projects/" + id + "/analysis/" + analysis.getId());

        } catch (Exception e)
        {
            logger.error(e.getMessage());
            model.addFlashAttribute("error_message", "Error while creating Analysis in DB");
            return new ModelAndView("redirect:/projects/" + id + "/analysis/accuracy/phaseA");
        }
    }

    @GetMapping(value = "projects/{id}/analysis/accuracy/phaseB")
    public ModelAndView create_view(@PathVariable("id") long id,
                               @RequestParam(value = "trialsSelected") LinkedList<Long> trials, RedirectAttributes m, Model model) {
        if (trials.isEmpty()) {
            logger.error("experiments is empty");
            m.addFlashAttribute("error_message", "failed to create analysis type in DB");
            return new ModelAndView("redirect:/projects/" + id);
        }

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(id, user);

            List<Experiment> experiments = new LinkedList<>();
            List<String> labels = new LinkedList<>();

            for (Long ex_id : trials) {
                Experiment experiment = experimentDao.findByIdAndProject(ex_id, project);
                List<String> split = Arrays.asList(experiment.getLabelsName().split(","));

                if (labels.isEmpty()) {
                    labels.addAll(split);
                } else {
                    labels.retainAll(split);
                }

                experiments.add(experiment);
            }

            model.addAttribute("labels", labels);
            model.addAttribute("project", project);
            model.addAttribute("experiments", experiments);
            model.addAttribute("analysisTypes", analysisTypeDao.findAll());
            model.addAttribute("experimentEvents", experimentEventsDao.findAll());
            model.addAttribute("current_user", user.getName() + " " + user.getLastName());
            return new ModelAndView("createAnalysis_accuracy_phaseB");
        } catch (Exception e) {
            m.addFlashAttribute("error_message", e.getMessage());
            logger.error(e.getMessage());
            return new ModelAndView("redirect:/projects/" + id + "/analysis/accuracy/phaseA");
        }
    }
}
