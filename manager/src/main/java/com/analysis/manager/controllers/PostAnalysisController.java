package com.analysis.manager.controllers;

import AnalysisManager.RunAnalysis;
import com.analysis.manager.Dao.AnalysisTypeDao;
import com.analysis.manager.Dao.ExperimentEventsDao;
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
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;


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
            model.addAttribute("analysisTypes", analysisTypeDao.findAll());
            model.addAttribute("current_user", user.getName() + " " + user.getLastName());
            model.addAttribute("project", project);

            return new ModelAndView("createPostAnalysis");
        } catch (Exception e) {
            m.addFlashAttribute("error_message", "Error show page for creation");
            return new ModelAndView("redirect:/projects/" + project_id);
        }
    }

    @PostMapping(value = "projects/{id}/analysis/postAnalysis/types")
    public ResponseEntity checkTypes(@PathVariable long id, @RequestParam("analysisList") List<Long> analysisList, @RequestParam("types") List<Long> types) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.findUserByEmail(auth.getName());

        LinkedList<AnalysisType> typesSelected = new LinkedList<>();

        for (Long t_id : types) {
            typesSelected.add(analysisTypeDao.findById((long)t_id));
        }

        for (Long ex_id : analysisList) {
            Analysis analysis = analysisDao.findByIdAndUser(ex_id, user);

            if (analysis != null) {
                if (!analysis.getAnalysisType().containsAll(typesSelected)) {
                    return ResponseEntity.ok(false);
                }
            }
        }


        return ResponseEntity.ok(true);
    }

    @PostMapping(value = "projects/{id}/analysis/postAnalysis/checkExperiments")
    public ResponseEntity checkExperiments(@PathVariable long id, @RequestParam("analysisList") List<Long> analysisList)
    {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.findUserByEmail(auth.getName());

        LinkedList<Analysis> analysisLinkedList = new LinkedList<>();
        for (Long ex_id : analysisList) {
            analysisLinkedList.add(analysisDao.findByIdAndUser(ex_id, user));
        }

        if (!analysisLinkedList.isEmpty()) {
            Experiment prev = analysisLinkedList.getFirst().getExperiment();
            ExperimentCondition prevCondition = prev.getExperimentCondition();
            for (Analysis an : analysisLinkedList) {
                if (!an.getExperiment().equals(prev)) {
                    ExperimentCondition experimentCondition = an.getExperiment().getExperimentCondition();

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

    @RequestMapping(value = "projects/{projects_id}/analysis/postAnalysis/create", method = RequestMethod.POST)
    public ModelAndView create(@PathVariable("projects_id") long id,
                         @RequestParam("name") String name, @RequestParam("description") String description,
                         @RequestParam(value = "types") LinkedList<Long> types,
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


            for (long id_type : types) {
                AnalysisType analysisType = analysisTypeDao.findById(id_type);
                analysisTypes.add(analysisType);
            }


            Analysis analysis = new Analysis(name, description, user, analysisTypes, new LinkedList<>(), analysisList.get(0).getExperiment());
            analysisDao.save(analysis);
            project.AddAnalysis(analysis);
            projectDao.saveProject(project);

            // create files location

            for (AnalysisType type : analysis.getAnalysisType()) {
                String path = pathAnalysis + File.separator + project.getUser().getName() + "_" + project.getUser().getLastName() + File.separator + project.getName() + File.separator + analysis.getName();

                path = path.toLowerCase();

                File type_folder = new File(path + File.separator + type.getName().toLowerCase());
                if (!type_folder.exists()) {
                    if (!type_folder.mkdirs()) {
                        logger.error("Failed to create folder for analysis type " + analysis.getName() + "/" + type.getName());
                        model.addFlashAttribute("error_message", "Failed to create folder for analysis type" +analysis.getName() + "/" + type.getName());
                        return new ModelAndView("redirect:/projects/" + id + "/analysis/postAnalysis/");

                    }
                }
            }

            if (runAnalysis == null)
            {
                model.addFlashAttribute("error_message", "Error bean name for matlab");
                return new ModelAndView("redirect:/projects/" + id + "/analysis/postAnalysis/");
            }

            String errors = sendToMatlab(analysisList);

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

    private String  sendToMatlab(List<Analysis> analysis) {
        return "";
    }
}
