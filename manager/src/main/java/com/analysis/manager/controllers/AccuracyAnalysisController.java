package com.analysis.manager.controllers;

import AnalysisManager.RunAnalysis;
import com.analysis.manager.Dao.AnalysisTypeDao;
import com.analysis.manager.NeuronsBean;
import com.analysis.manager.Service.AnalysisService;
import com.analysis.manager.Service.ExperimentService;
import com.analysis.manager.Service.ProjectService;
import com.analysis.manager.Service.UserService;
import com.analysis.manager.XmlCreator;
import com.analysis.manager.modle.*;
import com.mathworks.toolbox.javabuilder.MWCharArray;
import com.mathworks.toolbox.javabuilder.MWStructArray;
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

import java.io.File;
import java.util.*;

@Controller
public class AccuracyAnalysisController {
    @Autowired
    private UserService userService;

    @Autowired
    private ProjectService projectDao;

    @Autowired
    private AnalysisService analysisService;

    @Autowired
    private AnalysisService analysisDao;

    @Autowired
    private XmlCreator xmlCreator;

    @Autowired
    private NeuronsBean neuronsBean;

    @Autowired
    private AnalysisTypeDao analysisTypeDao;

    @Autowired
    private RunAnalysis runAnalysis;

    @Autowired
    private ExperimentService experimentDao;

    private static final Logger logger = LoggerFactory.getLogger(AccuracyAnalysisController.class);

    @Value("${analysis.results.location}")
    private String pathAnalysis;

    @Value("${accuracy.analysis.name}")
    private String accuracyName;

    @RequestMapping(value = "projects/{id}/analysis/accuracy/phaseA")
    public ModelAndView createAccuracyAnalysis(@PathVariable long id, Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.findUserByEmail(auth.getName());
        Project project = projectDao.findByIdAndUser(id, user);

        model.addAttribute("project", project);
        model.addAttribute("current_user", user.getName() + " " + user.getLastName());

        return new ModelAndView("createAnalysisAccuracy");
    }

    @GetMapping(value = "projects/{id}/analysis/labels")
    public ResponseEntity getLabels(@PathVariable long id, @RequestParam("trialsSelected") List<Long> trialsSelected) {
        // Check conditions of trials equals

        // get for all trails only labels common

        // TODO
        // get labels

        LinkedList<String> test = new LinkedList<>();
        test.add("success");
        test.add("fail");

        return ResponseEntity.ok(test);
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

                    if (prevCondition.getExperimentType().getId() != experimentCondition.getExperimentType().getId() ||
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
                               @RequestParam("labels") List<String> labels,  RedirectAttributes model)
    {

        if (trials == null || trials.isEmpty())
        {
            model.addFlashAttribute("error_message", "failed to create analysis, empty trials");
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

            AnalysisType analysisType = analysisTypeDao.findByName(accuracyName);

            if (analysisType == null) {
                model.addFlashAttribute("error_message", "failed to create analysis, this analysis type - accuracy does not exists");
                return new ModelAndView("redirect:/projects/" + id + "/analysis/accuracy/phaseA");
            }

            analysisTypes.add(analysisType);

            LinkedList<Trial> allTrials = new LinkedList<>();
            HashMap<Long, Experiment> experiments = new HashMap<>();

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

            if (!xmlCreator.createXml(analysis, font_size, Arrays.asList(neuronsBean.getNeurons(experiments.get(experimentId)).split(",")), new LinkedList<>(), experimentEvents, startTime2plot, 0, 0, 0, 0, 0)) {
                model.addFlashAttribute("error_message", "Error while creating Analysis Xml");
                return new ModelAndView("redirect:/projects/" + id + "/analysis/accuracy/phaseA");
            }

            if (runAnalysis == null)
            {
                model.addFlashAttribute("error_message", "Error bean name for matlab");
                return new ModelAndView("redirect:/projects/" + id + "/analysis/accuracy/phaseA");
            }

            String errors = sendToMatlab(analysis, labels);

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

    private String  sendToMatlab(Analysis analysis, List<String> labels) {
        StringBuilder errors = new StringBuilder();
//        analysis.getTrials().sort(Comparator.comparing(Trial::getName));
//
//        for (AnalysisType type : analysis.getAnalysisType())
//        {
//            Project project = analysis.getExperiment().getProject();
//            String path = pathAnalysis + File.separator + project.getUser().getName() + "_" + project.getUser().getLastName() + File.separator + project.getName() + File.separator + analysis.getName();
//            path = path.toLowerCase();
//
//            try {
//                MWCharArray xmlLocation = new MWCharArray(path + File.separator + "XmlAnalysis.xml");
//
//                MWCharArray analysisOutputFolder = new MWCharArray(path + File.separator + type.getName().toLowerCase());
//                MWStructArray BDA_TPA = new MWStructArray(1, analysis.getTrials().size(), new String[] {"BDA", "TPA"});
//
//                int count = 1;
//                for (Trial trial : analysis.getTrials())
//                {
//                    BDA_TPA.set("BDA", new int[] {1, count}, trial.getBda());
//                    BDA_TPA.set("TPA", new int[] {1, count}, trial.getTpa());
//                    count++;
//                }
//
//                MWCharArray analysisName = new MWCharArray(type.getName());
//
//                runAnalysis.runAnalysis(analysisOutputFolder, xmlLocation, BDA_TPA, analysisName);
//                runAnalysis.CloseAllFigures();
//            } catch (Exception e) {
//                logger.error(e.getMessage());
//                errors.append("Error matlab analysis failed for analysis type :").append(type.getName()).append("\n")
//                        .append(e.getMessage());
//                errors.append("\n");
//            }
//        }

        return errors.toString();
    }

    @GetMapping(value = "projects/{id}/analysis/accuracy/phaseB")
    public ModelAndView create_view(@PathVariable("id") long id,
                               @RequestParam(value = "trialsSelected") LinkedList<Long> trials,
                               @RequestParam(value = "labels") LinkedList<String> labels, RedirectAttributes m, Model model)
    {
        if (trials.isEmpty()) {
            logger.error("experiments is empty");
            m.addFlashAttribute("error_message", "failed to create analysis type in DB");
            return new ModelAndView("redirect:/projects/" + id);
        }

        try
        {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            Project project = projectDao.findByIdAndUser(id, user);

            List<Experiment> experiments = new LinkedList<>();
            for (Long ex_id : trials) {
                experiments.add(experimentDao.findByIdAndProject(ex_id, project));
            }

            model.addAttribute("labels", labels);
            model.addAttribute("project", project);
            model.addAttribute("experiments", experiments);
            model.addAttribute("current_user", user.getName() + " " + user.getLastName());
            return new ModelAndView("createAnalysis_accuracy_phaseB");
        }
        catch(Exception e)
        {

            m.addFlashAttribute("error_message", e.getMessage());
            logger.error(e.getMessage());
            return new ModelAndView("redirect:/projects/" + id + "/analysis/accuracy/phaseA");
        }

}

    @RequestMapping(value = "projects/{id}/allAnalysis")
    public ModelAndView createAllAnalysis(@PathVariable long id, Model model)
    {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.findUserByEmail(auth.getName());
        Project project = projectDao.findByIdAndUser(id, user);

        List<Analysis> analysisList = new LinkedList<>();
        for (Experiment experiment : project.getExperiments()) {

            analysisList.addAll(analysisService.findAllByExperiment(experiment));
        }

        model.addAttribute("analysis", analysisList);
//        TODO
//        model.addAttribute("labels", );

        return new ModelAndView("create_all_analysis");
    }
}
