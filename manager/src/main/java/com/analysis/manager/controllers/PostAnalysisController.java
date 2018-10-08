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
import com.mathworks.toolbox.javabuilder.MWCellArray;
import com.mathworks.toolbox.javabuilder.MWCharArray;
import com.mathworks.toolbox.javabuilder.MWStructArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
public class PostAnalysisController {
    @Autowired
    private AnalysisService analysisDao;

    @Autowired
    private AnalysisTypeDao analysisTypeDao;

    @Autowired
    private ProjectService projectDao;

    @Autowired
    private RunAnalysis runAnalysis;

    @Autowired
    private ExperimentEventsDao experimentEventsDao;

    @Autowired
    private XmlCreator xmlCreator;

    @Autowired
    private ExperimentDataBean experimentDataBean;

    @Autowired
    private UserService userService;

    private static final Logger logger = LoggerFactory.getLogger(PostAnalysisController.class);

    @Value("${analysis.results.location}")
    private String pathAnalysis;


    @RequestMapping(value = "projects/{project_id}/analysis/postAnalysis")
    public ModelAndView view(@PathVariable long project_id, RedirectAttributes m, Model model)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());

            Project project = projectDao.findByIdAndUser(project_id, user);

            List<String> labels = new LinkedList<>();

            for (Experiment experiment : project.getExperiments()) {
                List<String> split = Arrays.asList(experiment.getLabelsName().split(","));

                if (labels.isEmpty()) {
                    labels.addAll(split);
                } else {
                    labels.retainAll(split);
                }
            }

            model.addAttribute("labels", labels);
            model.addAttribute("analysisTypes", analysisTypeDao.findAll());
            model.addAttribute("experimentEvents", experimentEventsDao.findAll());
            model.addAttribute("current_user", user.getName() + " " + user.getLastName());
            model.addAttribute("project", project);

            return new ModelAndView("createPostAnalysis");
        } catch (Exception e) {
            m.addFlashAttribute("error_message", "Error show page for creation");
            return new ModelAndView("redirect:/projects/" + project_id);
        }
    }

    @PostMapping(value = "projects/{id}/analysis/postAnalysis/types")
    public boolean checkTypes(List<Analysis> analysisList, List<AnalysisType> types) {
        for (Analysis analysis : analysisList) {
            if (analysis != null) {
                if (!analysis.getAnalysisType().containsAll(types)) {
                    return false;
                }
            }
        }


        return true;
    }

    private boolean checkExperiments(List<Analysis> analysisLinkedList)
    {
        if (!analysisLinkedList.isEmpty()) {
            Experiment prev = analysisLinkedList.get(0).getExperiment();
            ExperimentCondition prevCondition = prev.getExperimentCondition();
            for (Analysis an : analysisLinkedList) {
                if (!an.getExperiment().equals(prev)) {
                    ExperimentCondition experimentCondition = an.getExperiment().getExperimentCondition();

                    if (an.getExperiment().getProject().getId() != prev.getProject().getId() ||
                            prevCondition.getExperimentType().getId() != experimentCondition.getExperimentType().getId() ||
                            prevCondition.getBehavioral_delay() != experimentCondition.getBehavioral_delay() ||
                            prevCondition.getBehavioral_sampling_rate() != experimentCondition.getBehavioral_sampling_rate() ||
                            prevCondition.getDepth() != experimentCondition.getDepth() ||
                            prevCondition.getDuration() != experimentCondition.getDuration() ||
                            prevCondition.getExperimentInjections().getId() != experimentCondition.getExperimentInjections().getId() ||
                            prevCondition.getExperimentPelletPertubation().getId() != experimentCondition.getExperimentPelletPertubation().getId() ||
                            prevCondition.getImaging_sampling_rate() != experimentCondition.getImaging_sampling_rate() ||
                            prevCondition.getTone_time() != experimentCondition.getTone_time()) {
                        return false;
                    }
                }
            }

            return true;
        }

        return false;
    }

    @RequestMapping(value = "projects/{projects_id}/analysis/postAnalysis/create", method = RequestMethod.POST)
    public ModelAndView create(@PathVariable("projects_id") long id,
                         @RequestParam("name") String name, @RequestParam("description") String description,
                         @RequestParam(value = "types") LinkedList<Long> types,
                       @RequestParam("font_size") double font_size,
                       @RequestParam("linearSVN") String linearSVN,
                       @RequestParam("time4confplot") double time4confplot,
                       @RequestParam("time4confplotNext") double time4confplotNext,
                       @RequestParam("startTime2plot") double startTime2plot,
                       @RequestParam("foldsNum") double foldsNum,
                         @RequestParam(value = "labels", required = false) List<String> labels,
                               @RequestParam("includeO") String includeO,
                               @RequestParam("DetermineSucFailBy") String DetermineSucFailBy,
                               @RequestParam(value = "events", required = false) LinkedList<Long> events,
                         @RequestParam(value = "analysisList") LinkedList<Long> analysis_list,  RedirectAttributes model)
    {

        if (analysis_list == null || analysis_list.isEmpty())
        {
            model.addFlashAttribute("error_message", "failed to create analysis, empty analysis");
            model.addAttribute("tif", new LinkedList<String>());
            return new ModelAndView("redirect:/projects/" + id + "/analysis/postAnalysis/");
        }

        if (types == null || types.isEmpty())
        {
            model.addFlashAttribute("error_message", "failed to create analysis, empty types for analysis");
            model.addAttribute("tif", new LinkedList<String>());
            return new ModelAndView("redirect:/projects/" + id + "/analysis/postAnalysis/");
        }


        if (labels == null || labels.isEmpty() || labels.size() != 2)
        {
            model.addFlashAttribute("error_message", "failed to create analysis, must has 2 labels");
            model.addAttribute("tif", new LinkedList<String>());
            return new ModelAndView("redirect:/projects/" + id + "/analysis/postAnalysis/");
        }

        LinkedList<AnalysisType> analysisTypes = new LinkedList<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());

            Project project = projectDao.findByIdAndUser(id, user);


            if (analysisDao.existsByNameAndUser(name, user)) {
                model.addFlashAttribute("error_message", "failed to create analysis, this analysis name already exists");
                return new ModelAndView("redirect:/projects/" + id + "/analysis/postAnalysis/");
            }

            List<Analysis> analysisList = new LinkedList<>();
            for (Long idA : analysis_list) {
                analysisList.add(analysisDao.findByIdAndUser(idA, user));
            }

            if (!checkExperiments(analysisList))
            {
                model.addFlashAttribute("error_message", "failed to create post analysis, analysis experiments must be with the same conditions");
                return new ModelAndView("redirect:/projects/" + id + "/analysis/postAnalysis/");
            }

            for (long id_type : types) {
                AnalysisType analysisType = analysisTypeDao.findById(id_type);
                analysisTypes.add(analysisType);
            }

            if (!checkTypes(analysisList, analysisTypes))
            {
                model.addFlashAttribute("error_message", "failed to create post analysis, analysis types do not exists in analysis selected");
                return new ModelAndView("redirect:/projects/" + id + "/analysis/postAnalysis/");
            }

            LinkedList<ExperimentEvents> experimentEvents = new LinkedList<>();

            if (events != null) {
                for (long id_event : events) {
                    ExperimentEvents eventsDaoById = experimentEventsDao.findById(id_event);
                    experimentEvents.add(eventsDaoById);
                }

            }

            Analysis analysis = new Analysis(name, description, user, analysisTypes, new LinkedList<>(), analysisList.get(0).getExperiment());
            analysisDao.save(analysis);
            project.AddAnalysis(analysis);
            projectDao.saveProject(project);

            // create files location
            if (!xmlCreator.createXml(analysis, font_size, Arrays.asList(experimentDataBean.getNeurons(analysis.getExperiment()).split(",")), new LinkedList<>(), experimentEvents, startTime2plot, 0, 0, 0, 0, foldsNum, linearSVN, 0, 0, 0, time4confplot, time4confplotNext, includeO, DetermineSucFailBy, labels, 0)) {
                model.addFlashAttribute("error_message", "Error while creating Analysis Xml");
                return new ModelAndView("redirect:/projects/" + id + "/analysis/postAnalysis");
            }

            if (runAnalysis == null)
            {
                model.addFlashAttribute("error_message", "Error bean name for matlab");
                return new ModelAndView("redirect:/projects/" + id + "/analysis/postAnalysis/");
            }

            String errors = sendToMatlab(analysisList, analysis);

            if (!errors.isEmpty()) {
                model.addFlashAttribute("error_message", errors);
                return new ModelAndView("redirect:/projects/" + id + "/analysis/" + analysis.getId());
            }

            return new ModelAndView("redirect:/projects/" + id + "/analysis/" + analysis.getId());

        } catch (Exception e)
        {
            logger.error(e.getMessage());
            model.addFlashAttribute("error_message", "Error while creating Analysis in DB");
            return new ModelAndView("redirect:/projects/" + id + "//analysis/postAnalysis/");
        }
    }

    private String  sendToMatlab(List<Analysis> analysisList, Analysis analysis) {
        StringBuilder errors = new StringBuilder();

        for (AnalysisType type : analysis.getAnalysisType())
        {
            Project project = analysis.getExperiment().getProject();
            String path = pathAnalysis + File.separator + project.getUser().getName() + "_" + project.getUser().getLastName() + File.separator + project.getName() + File.separator + analysis.getName();
            path = path.toLowerCase();

            try {
                MWCharArray xmlLocation = new MWCharArray(path + File.separator + "XmlAnalysis.xml");

                MWCharArray analysisOutputFolder = new MWCharArray(path + File.separator + type.getName().toLowerCase());
                MWCellArray matFile = new MWCellArray(1, analysisList.size());

                int count = 1;
                for (Analysis an : analysisList)
                {
                    String location = pathAnalysis + File.separator + project.getUser().getName() + "_" + project.getUser().getLastName() + File.separator + project.getName() + File.separator + an.getName() + File.separator + type.getName();
                    File fileLocation = new File(location.toLowerCase());

                    if (fileLocation.isDirectory()) {
                        File[] files = fileLocation.listFiles((dir, name) -> name.endsWith(".mat") && !name.contains("PrevCurr"));
                        if ((files != null ? files.length : 0) == 1) {
                            matFile.set(count, files[0].getAbsolutePath());
                            count++;
                        }
                    }
                }

                MWStructArray BDA_TPA = new MWStructArray(1, analysis.getExperiment().getTrials().size(), new String[] {"BDA", "TPA"});

                count = 1;
                for (Trial trial : analysis.getExperiment().getTrials())
                {
                    BDA_TPA.set("BDA", new int[] {1, count}, trial.getBda());
                    BDA_TPA.set("TPA", new int[] {1, count}, trial.getTpa());
                    count++;
                }


                MWCharArray analysisName = new MWCharArray(type.getName());

                runAnalysis.runAverageAnalysis(analysisOutputFolder, xmlLocation, BDA_TPA, matFile, analysisName);
                runAnalysis.CloseAllFigures();
            } catch (Exception e) {
                logger.error(e.getMessage());
                errors.append("Error matlab analysis failed for analysis type :").append(type.getName()).append("\n")
                        .append(e.getMessage());
                errors.append("\n");
            }
        }

        return errors.toString();
    }
}
