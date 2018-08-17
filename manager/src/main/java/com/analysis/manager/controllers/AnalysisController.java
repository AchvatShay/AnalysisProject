package com.analysis.manager.controllers;

import AnalysisManager.RunAnalysis;
import com.analysis.manager.Dao.AnalysisDao;
import com.analysis.manager.Dao.AnalysisTypeDao;
import com.analysis.manager.Dao.ExperimentEventsDao;
import com.analysis.manager.Service.ExperimentService;
import com.analysis.manager.Service.ProjectService;
import com.analysis.manager.Service.UserService;
import com.analysis.manager.XmlCreator;
import com.analysis.manager.modle.*;
import com.mathworks.toolbox.javabuilder.MWCharArray;
import com.mathworks.toolbox.javabuilder.MWStructArray;
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
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;


@Controller
public class AnalysisController {
    @Autowired
    private AnalysisDao analysisDao;

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
    private UserService userService;

    @Value("${analysis.results.location}")
    private String pathAnalysis;

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
                model.addFlashAttribute("error_message", "failed to create analysis type in DB");
            }
        }
        else
        {
            model.addFlashAttribute("error_message", "analysis type already exists");
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
            m.addAttribute("analysisList", analysisDao.findAllByUser(user));
        }catch (Exception e)
        {
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
                    File file = new File(pathAnalysis + File.separator + project.getUser().getName() + File.separator + project.getName() + File.separator + analysis.getName()+ File.separator + type.getName());
                    File[] files = file.listFiles((dir, name) -> name.endsWith(".tif"));

                    List<FilesManager> resourceLocation = new LinkedList<>();

                    if (files != null) {
                        for (File currentFile : files) {
                            String file_name = currentFile.getName().replace(".tif", "");
                            FilesManager filesManager = new FilesManager(file_name, analysis.getName(), type.getName(), project.getName(), project.getUser().getName(), ".tif");
                            resourceLocation.add(filesManager);
                        }
                    }

                    map.put(type, resourceLocation);
                }

                model.addAttribute("tif", map);
                model.addAttribute("analysis", analysis);
                return new ModelAndView("analysis");
            } catch (Exception e) {
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
//                                log.info("Error writing file to output stream. Filename was '{}'", fileName, ex);
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
            model.addFlashAttribute("error_message", "error while delete analysis in DB");
            return new ModelAndView("redirect:/projects/" + projectId);
        }
    }

    @RequestMapping(value = "projects/{projects_id}/analysis", method = RequestMethod.POST)
    public ModelAndView create(@PathVariable("projects_id") long id,
                         @RequestParam("name") String name, @RequestParam("description") String description,
                         @RequestParam("types") LinkedList<Long> types,
                         @RequestParam("neurons_toPlot") LinkedList<String> neurons_toPlot,
                         @RequestParam("neurons_forAnalysis") LinkedList<String> neurons_forAnalysis,
                         @RequestParam("startTime2plot") double startTime2plot,
                         @RequestParam("time2startCountGrabs") double time2startCountGrabs,
                         @RequestParam("time2endCountGrabs") double time2endCountGrabs,
                         @RequestParam("startBehaveTime4trajectory") double startBehaveTime4trajectory,
                         @RequestParam("endBehaveTime4trajectory") double endBehaveTime4trajectory,
                         @RequestParam("foldsNum") double foldsNum,
                         @RequestParam("events") LinkedList<Long> events,
                         @RequestParam("experiment_id") long experiment_id,
                         @RequestParam("font_size") double font_size,
                         @RequestParam("trialsSelected") LinkedList<String> trials,  RedirectAttributes model)
    {

        if (trials == null || trials.isEmpty())
        {
            model.addFlashAttribute("error_message", "failed to create analysis, empty trials");
            model.addAttribute("tif", new LinkedList<String>());
            return new ModelAndView("redirect:/projects/" + id);
        }


        if (types == null || types.isEmpty())
        {
            model.addFlashAttribute("error_message", "failed to create analysis, empty types");
            return new ModelAndView("redirect:/projects/" + id);
        }

        LinkedList<AnalysisType> analysisTypes = new LinkedList<>();
        LinkedList<ExperimentEvents> experimentEvents = new LinkedList<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());

            Project project = projectDao.findByIdAndUser(id, user);


            if (analysisDao.existsByNameAndUser(name, user)) {
                model.addFlashAttribute("error_message", "failed to create analysis, this analysis name already exists");
                return new ModelAndView("redirect:/projects/" + id);
            }

            Experiment experiment = experimentDao.findByIdAndProject(experiment_id, project);

            for (long id_type : types) {
                AnalysisType analysisType = analysisTypeDao.findById(id_type);
                analysisTypes.add(analysisType);
            }

            for (long id_event : events) {
                ExperimentEvents eventsDaoById = experimentEventsDao.findById(id_event);
                experimentEvents.add(eventsDaoById);
            }

            List<String> neuronsPlot = getNeuronsList(neurons_toPlot, experiment_id);
            List<String> neuronsAnalysis = getNeuronsList(neurons_forAnalysis, experiment_id);

            if (neuronsPlot == null || neuronsAnalysis == null) {
                model.addFlashAttribute("error_message", "Error can not select trials from different experiments");
                return new ModelAndView("redirect:/projects/" + id);
            }

            LinkedList<Trial> allTrials = new LinkedList<>();
            for (String str : trials)
            {
                String[] split = str.split("_");
                long trialId = Long.parseLong(split[1]);
                long experimentId = Long.parseLong(split[0]);

                if (experimentId != experiment_id)
                {
                    model.addFlashAttribute("error_message", "Error can not select trials from different experiments");
                    return new ModelAndView("redirect:/projects/" + id);
                }

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


            if (!xmlCreator.createXml(analysis, font_size, neuronsAnalysis, neuronsPlot, experimentEvents, startTime2plot, time2startCountGrabs, time2endCountGrabs, startBehaveTime4trajectory, endBehaveTime4trajectory, foldsNum)) {
                model.addFlashAttribute("error_message", "Error while creating Analysis Xml");
                return new ModelAndView("redirect:/projects/" + id );
            }

            if (runAnalysis == null)
            {
                model.addFlashAttribute("error_message", "Error bean name for matlab");
                return new ModelAndView("redirect:/projects/" + id);
            }

            String errors = sendToMatlab(analysis);

            if (errors!= null && !errors.isEmpty()) {
                model.addFlashAttribute("error_message", errors);
                return new ModelAndView("redirect:/projects/" + id);
            }

            return new ModelAndView("redirect:/projects/" + id + "/analysis/" + analysis.getId());

        } catch (Exception e)
        {
            model.addFlashAttribute("error_message", "Error while creating Analysis in DB");
            return new ModelAndView("redirect:/projects/" + id);
        }
    }

    private List<String> getNeuronsList(LinkedList<String> neuronsWithID,long experiment_id) {
        LinkedList<String> neurons = new LinkedList<>();

        String[] splitF = neuronsWithID.get(0).split("_");
        long experimentIdF = Long.parseLong(splitF[0]);

        if (neuronsWithID.contains(experimentIdF + "_00"))
        {
            if (neuronsWithID.size() > 1) {
                neuronsWithID.remove(experimentIdF + "_00");
            } else {
                neurons.add("0");
                return neurons;
            }
        }

        for (String str : neuronsWithID)
        {
            String[] split = str.split("_");
            String neuronName = split[1];
            long experimentId = Long.parseLong(split[0]);

            if (experimentId != experiment_id)
            {
                return null;
            }

            neurons.add(neuronName);
        }
        return neurons;
    }

    private String  sendToMatlab(Analysis analysis) {
        StringBuilder errors = new StringBuilder();
        for (AnalysisType type : analysis.getAnalysisType())
        {
            Project project = analysis.getExperiment().getProject();
            String path = pathAnalysis + File.separator + project.getUser().getName() + File.separator + project.getName() + File.separator + analysis.getName();

            try {
                MWCharArray xmlLocation = new MWCharArray(path + File.separator + "XmlAnalysis.xml");

                MWCharArray analysisOutputFolder = new MWCharArray(path + File.separator + type.getName());
                MWStructArray BDA_TPA = new MWStructArray(1, analysis.getTrials().size(), new String[] {"BDA", "TPA"});

                int count = 1;
                for (Trial trial : analysis.getTrials())
                {
                    BDA_TPA.set("BDA", new int[] {1, count}, trial.getBda().getFileLocation());
                    BDA_TPA.set("TPA", new int[] {1, count}, trial.getTpa().getFileLocation());
                    count++;
                }

                MWCharArray analysisName = new MWCharArray(type.getName());

                runAnalysis.runAnalysis(analysisOutputFolder, xmlLocation, BDA_TPA, analysisName);
            } catch (Exception e) {
               // e.printStackTrace();
                errors.append("Error matlab analysis failed for analysis type :").append(type.getName());
                errors.append("\n");
            }
        }

        return errors.toString();
    }
}
