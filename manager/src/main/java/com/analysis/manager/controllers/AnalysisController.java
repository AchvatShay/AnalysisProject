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
import java.util.*;


@Controller
public class AnalysisController {
    @Autowired
    private AnalysisService analysisDao;

    @Autowired
    private AnalysisTypeDao analysisTypeDao;

    @Autowired
    private ProjectService projectDao;

    @Autowired
    private ExperimentService experimentDao;

    @Autowired
    private XmlCreator xmlCreator;

    @Autowired
    private RunAnalysis runAnalysis;

    @Autowired
    private ExperimentEventsDao experimentEventsDao;

    @Autowired
    private ExperimentDataBean experimentDataBean;

    @Autowired
    private UserService userService;

    private static final Logger logger = LoggerFactory.getLogger(AnalysisController.class);

    @Value("${analysis.results.location}")
    private String pathAnalysis;

    @Value("${accuracy.analysis.name}")
    private String accuracyName;

    @RequestMapping(value = "analysis", method = RequestMethod.POST)
    public ModelAndView createAnalysisType(@RequestParam String name, RedirectAttributes model)
    {
        if (analysisTypeDao.findByName(name) == null)
        {
            try {
                analysisTypeDao.save(new AnalysisType(name));
            }
            catch (Exception e)
            {
                logger.error(e.getMessage());
                model.addFlashAttribute("error_message", "failed to create analysis type in DB");
            }
        }
        else
        {
            model.addFlashAttribute("error_message", "analysis type already exists");
        }

        return new ModelAndView("redirect:/analysis");
    }

    @RequestMapping(value = "analysis/{id}/delete")
    public ModelAndView deleteAnalysisTypes(@PathVariable long id, RedirectAttributes model)
    {
        AnalysisType type = analysisTypeDao.findById(id);
        if (type != null)
        {
            try {
                analysisTypeDao.delete(type);
            }
            catch (Exception e)
            {
                logger.error(e.getMessage());
                model.addFlashAttribute("error_message", "failed to delete analysis type in DB");
            }
        }
        else
        {
            model.addFlashAttribute("error_message", "analysis type does not exist");
        }

        return new ModelAndView("redirect:/analysis");
    }

    @RequestMapping(value = "analysis", method = RequestMethod.GET)
    public ModelAndView viewAll(RedirectAttributes model, Model m)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            m.addAttribute("analysisTypes", analysisTypeDao.findAll());
            m.addAttribute("analysisList", analysisDao.findAll());
            m.addAttribute("current_user", user.getName() + " " + user.getLastName());
        }catch (Exception e)
        {
            logger.error(e.getMessage());
            model.addFlashAttribute("error_message", "Error getting analysis types from DB");
            return new ModelAndView("redirect:/projects");
        }

        return new ModelAndView("allAnalysis");
    }

    @RequestMapping(value = "projects/{project_id}/analysis/{id}")
    public ModelAndView view(@PathVariable long project_id, @PathVariable long id, RedirectAttributes m, Model model)
    {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.findUserByEmail(auth.getName());

        Analysis analysis = analysisDao.findByIdAndUser(id, user);

        if (analysis == null) {
            m.addFlashAttribute("error_message", "can not find analysis with this id");
        } else if (analysis.getExperiment().getProject().getId() != project_id) {
            m.addFlashAttribute("error_message", "analysis do not belong to project");
        } else {
            try {
                LinkedHashMap<AnalysisType, List<FilesManager>> map = new LinkedHashMap<>();

                for (AnalysisType type : analysis.getAnalysisType()) {
                    Project project = analysis.getExperiment().getProject();
                    String path = pathAnalysis + File.separator + project.getUser().getName() + "_" + project.getUser().getLastName() + File.separator + project.getName() + File.separator + analysis.getName()+ File.separator + type.getName();
                    File file = new File(path.toLowerCase());
                    File[] files = file.listFiles((dir, name) -> name.endsWith(".tif"));

                    List<FilesManager> resourceLocation = new LinkedList<>();

                    if (files != null) {
                        for (File currentFile : files) {
                            String file_name = currentFile.getName().replace(".tif", "");
                            FilesManager filesManager = new FilesManager(file_name, analysis.getName().toLowerCase(), type.getName().toLowerCase(), project.getName().toLowerCase(), project.getUser().getName().toLowerCase() + "_" + project.getUser().getLastName().toLowerCase(), ".tif");
                            resourceLocation.add(filesManager);
                        }
                    }

                    map.put(type, resourceLocation);
                }

                model.addAttribute("tif", map);
                model.addAttribute("analysis", analysis);
                model.addAttribute("current_user", user.getName() + " " + user.getLastName());
                return new ModelAndView("analysis");
            } catch (Exception e) {
                logger.error(e.getMessage());
                m.addFlashAttribute("error_message", "failed to load files from dropbox");
            }
        }

        return new ModelAndView("redirect:/projects/" + project_id);
    }

    @RequestMapping(value = "projects/{project_id}/analysis/{id}/download/{user_name}/{project_name}/{analysis_name}/{analysis_type}/{file_name}")
    public @ResponseBody void download(@PathVariable long project_id, @PathVariable long id, @PathVariable String project_name, @PathVariable String analysis_name, @PathVariable String user_name, @PathVariable String analysis_type, @PathVariable String file_name, RedirectAttributes model, HttpServletResponse response)
    {
        String path = pathAnalysis + File.separator + user_name + File.separator + project_name + File.separator + analysis_name + File.separator + analysis_type;

        File f = new File(path);

        if (!f.exists() || !f.isDirectory()) {
            model.addFlashAttribute("error_message", "error while downloading the fig file");
        } else {
            File[] files = f.listFiles((dir, f_name) -> f_name.endsWith(".fig"));
            if (files != null) {
                for (File c_f : files) {
                    if (c_f.getName().contains(file_name)) {
                        try {
                            InputStream in = new FileInputStream(c_f);

                            response.setContentType("application/fig");
                            response.setHeader("Content-Disposition", "attachment; filename=" + c_f.getName());
                            response.setHeader("Content-Length", String.valueOf(c_f.length()));
                            FileCopyUtils.copy(in, response.getOutputStream());

                        } catch (IOException ex) {
                            logger.error(ex.getMessage());
                            model.addFlashAttribute("error_message", "error while downloading the fig file");
                        }

                    }
                }
            }
        }
    }

    @RequestMapping(value = "projects/{id}/analysis/{analysis_id}/delete")
    public ModelAndView delete(@PathVariable("id") long projectId, @PathVariable("analysis_id") long analysis_id, RedirectAttributes model)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());

            Analysis analysis = analysisDao.findByIdAndUser(analysis_id, user);
            Project project = projectDao.findByIdAndUser(projectId, user);

            if (analysis == null) {
                model.addFlashAttribute("error_message", "can not find analysis with this id");
            } else if (analysis.getExperiment().getProject().getId() != projectId) {
                model.addFlashAttribute("error_message", "analysis do not belong to project");
            } else {
                project.deleteAnalysis(analysis);
                projectDao.saveProject(project);
                analysisDao.delete(analysis);
            }

            return new ModelAndView("redirect:/projects/" + projectId);
        }
        catch (Exception e)
        {
            logger.error(e.getMessage());
            model.addFlashAttribute("error_message", "error while delete analysis in DB");
            return new ModelAndView("redirect:/projects/" + projectId);
        }
    }

    @RequestMapping(value = "projects/{projects_id}/analysis", method = RequestMethod.POST)
    public ModelAndView create(@PathVariable("projects_id") long id,
                         @RequestParam("name") String name, @RequestParam("description") String description,
                         @RequestParam(value = "types") LinkedList<Long> types,
                         @RequestParam(value = "neurons_toPlot", required = false) LinkedList<String> neurons_toPlot,
                         @RequestParam(value = "neurons_forAnalysis") LinkedList<String> neurons_forAnalysis,
                         @RequestParam("startTime2plot") double startTime2plot,
                         @RequestParam("time2startCountGrabs") double time2startCountGrabs,
                         @RequestParam("time2endCountGrabs") double time2endCountGrabs,
                         @RequestParam("startBehaveTime4trajectory") double startBehaveTime4trajectory,
                         @RequestParam("endBehaveTime4trajectory") double endBehaveTime4trajectory,
                         @RequestParam("foldsNum") double foldsNum,
                         @RequestParam(value = "events", required = false) LinkedList<Long> events,
                         @RequestParam("experiment_id") long experiment_id,
                         @RequestParam("font_size") double font_size,
                         @RequestParam("linearSVN") String linearSVN,
                         @RequestParam("slidingWinLen") double slidingWinLen,
                         @RequestParam("slidingWinHop") double slidingWinHop,
                         @RequestParam("conf_percent4acc") double conf_percent4acc,
                         @RequestParam("time4confplot") double time4confplot,
                         @RequestParam("time4confplotNext") double time4confplotNext,
                         @RequestParam("bestpcatrajectories2plot") double bestpcatrajectories2plot,
                         @RequestParam("includeO") String includeO,
                         @RequestParam("DetermineSucFailBy") String DetermineSucFailBy,
                         @RequestParam(value = "trialsSelected") LinkedList<String> trials,
                         @RequestParam(value = "labels", required = false) List<String> labels,  RedirectAttributes model)
    {

        if (trials == null || trials.isEmpty())
        {
            model.addFlashAttribute("error_message", "failed to create analysis, empty trials");
            model.addAttribute("tif", new LinkedList<String>());
            return new ModelAndView("redirect:/projects/" + id + "/experiments/" + experiment_id + "/createAnalysis");
        }

        if (labels == null || labels.isEmpty() || labels.size() != 2)
        {
            model.addFlashAttribute("error_message", "failed to create analysis, must has 2 labels");
            model.addAttribute("tif", new LinkedList<String>());
            return new ModelAndView("redirect:/projects/" + id + "/experiments/" + experiment_id + "/createAnalysis");
        }

        if (neurons_forAnalysis == null || neurons_forAnalysis.isEmpty())
        {
            model.addFlashAttribute("error_message", "failed to create analysis, empty neurons for analysis");
            model.addAttribute("tif", new LinkedList<String>());
            return new ModelAndView("redirect:/projects/" + id + "/experiments/" + experiment_id + "/createAnalysis");
        }

        if (types == null || types.isEmpty())
        {
            model.addFlashAttribute("error_message", "failed to create analysis, empty analysis types");
            return new ModelAndView("redirect:/projects/" + id + "/experiments/" + experiment_id + "/createAnalysis");
        }

        LinkedList<AnalysisType> analysisTypes = new LinkedList<>();
        LinkedList<ExperimentEvents> experimentEvents = new LinkedList<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());

            Project project = projectDao.findByIdAndUser(id, user);


            if (analysisDao.existsByNameAndUser(name, user)) {
                model.addFlashAttribute("error_message", "failed to create analysis, this analysis name already exists");
                return new ModelAndView("redirect:/projects/" + id + "/experiments/" + experiment_id + "/createAnalysis");
            }

            Experiment experiment = experimentDao.findByIdAndProject(experiment_id, project);

            for (long id_type : types) {
                AnalysisType analysisType = analysisTypeDao.findById(id_type);
                analysisTypes.add(analysisType);
            }

            if (events != null) {
                for (long id_event : events) {
                    ExperimentEvents eventsDaoById = experimentEventsDao.findById(id_event);
                    experimentEvents.add(eventsDaoById);
                }

            }

           if (neurons_toPlot == null) {
                neurons_toPlot = new LinkedList<>();
           }

            // check that all neurons to plot exists in neurons to analysis\
            if (!neurons_forAnalysis.containsAll(neurons_toPlot)) {
                model.addFlashAttribute("error_message", "Error, you must select neurons to plot that includes in the analysis neurons selected");
                return new ModelAndView("redirect:/projects/" + id + "/experiments/" + experiment_id + "/createAnalysis");
            }

            LinkedList<Trial> allTrials = new LinkedList<>();
            for (String str : trials)
            {
                long trialId = Long.parseLong(str);

                for (Trial trial: experiment.getTrials())
                {
                    if (trial.getId() == trialId)
                    {
                        allTrials.add(trial);
                    }
                }
            }

            Analysis analysis = new Analysis(name, description, user, analysisTypes, allTrials, experiment);
            analysisDao.save(analysis);
            project.AddAnalysis(analysis);
            projectDao.saveProject(project);


            if (!xmlCreator.createXml(analysis, font_size, neurons_forAnalysis, neurons_toPlot, experimentEvents, startTime2plot, time2startCountGrabs, time2endCountGrabs, startBehaveTime4trajectory, endBehaveTime4trajectory, foldsNum, linearSVN, slidingWinLen, slidingWinHop, conf_percent4acc, time4confplot, time4confplotNext, includeO, DetermineSucFailBy, labels, bestpcatrajectories2plot)) {
                model.addFlashAttribute("error_message", "Error while creating Analysis Xml");
                return new ModelAndView("redirect:/projects/" + id + "/experiments/" + experiment_id + "/createAnalysis");
            }

            if (runAnalysis == null)
            {
                model.addFlashAttribute("error_message", "Error bean name for matlab");
                return new ModelAndView("redirect:/projects/" + id + "/experiments/" + experiment_id + "/createAnalysis");
            }

            String errors = experimentDataBean.sendToMatlab(analysis);

            if (!errors.isEmpty()) {
                model.addFlashAttribute("error_message", errors);
                return new ModelAndView("redirect:/projects/" + id + "/analysis/" + analysis.getId());
            }

            return new ModelAndView("redirect:/projects/" + id + "/analysis/" + analysis.getId());

        } catch (Exception e)
        {
            logger.error(e.getMessage());
            model.addFlashAttribute("error_message", "Error while creating Analysis in DB");
            return new ModelAndView("redirect:/projects/" + id + "/experiments/" + experiment_id + "/createAnalysis");
        }
    }
}
