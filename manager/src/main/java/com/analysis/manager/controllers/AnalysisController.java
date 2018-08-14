package com.analysis.manager.controllers;

import com.analysis.manager.Dao.*;
import com.analysis.manager.Service.ExperimentService;
import com.analysis.manager.Service.ProjectService;
import com.analysis.manager.Service.UserService;
import com.analysis.manager.XmlCreator;
import com.analysis.manager.modle.*;
import com.dropbox.core.v2.DbxClientV2;
import com.mathworks.toolbox.javabuilder.MWCharArray;
import com.mathworks.toolbox.javabuilder.MWStructArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import AnalysisManager.RunAnalysis;

import java.io.File;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.TimeUnit;

import static org.awaitility.Awaitility.await;


@Controller
public class AnalysisController {
    @Autowired
    private AnalysisDao analysisDao;

    @Autowired
    private AnalysisTypeDao analysisTypeDao;

    @Autowired
    private ProjectService projectDao;

    @Autowired
    private DbxClientV2 dbxClientV2;

    @Autowired
    private Environment environment;

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

    @RequestMapping(value = "analysis", method = RequestMethod.POST)
    public String createAnalysisType(@RequestParam String name, Model model)
    {
        if (analysisTypeDao.findByName(name) == null)
        {
            try {
                analysisTypeDao.save(new AnalysisType(name));
            }
            catch (Exception e)
            {
                model.addAttribute("error_message", "failed to create analysis type in DB");
            }
        }
        else
        {
            model.addAttribute("error_message", "analysis type already exists");
        }

        return "redirect:/analysis";
    }

    @RequestMapping(value = "analysis", method = RequestMethod.GET)
    public String viewAll(Model model)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());
            model.addAttribute("analysisTypes", analysisTypeDao.findAll());
            model.addAttribute("analysisList", analysisDao.findAllByUser(user));
        }catch (Exception e)
        {
            model.addAttribute("error_massage", "Error getting analysis types from DB");
            return "redirect:/projects";
        }

        return "allAnalysis";
    }

    @RequestMapping(value = "projects/{project_id}/analysis/{id}")
    public String view(@PathVariable long project_id, @PathVariable long id, Model m)
    {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        User user = userService.findUserByEmail(auth.getName());

        Analysis analysis = analysisDao.findByIdAndUser(id, user);
        Project project = projectDao.findByIdAndUser(project_id, user);

        if (analysis == null) {
            m.addAttribute("error_message", "can not find analysis with this id");
        } else if (analysis.getExperiment().getProject().getId() != project_id) {
            m.addAttribute("error_message", "analysis do not belong to project");
        } else {
            try {
                LinkedHashMap<AnalysisType, List<String>> map = new LinkedHashMap<>();

                for (AnalysisType type : analysis.getAnalysisType()) {

                    List<String> linksList = xmlCreator.getLinksList(project.getName() + File.separator + analysis.getName() + File.separator + type.getName());
                    map.put(type, linksList);
                }

                m.addAttribute("tif", map);
                m.addAttribute("analysis", analysis);
                return "analysis";
            } catch (Exception e) {
                m.addAttribute("error_message", "failed to load files from dropbox");
            }
        }

        return "redirect:/projects/" + project_id;
    }

    @RequestMapping(value = "projects/{id}/analysis/{analysis_id}/delete")
    public String delete(@PathVariable("id") long projectId, @PathVariable("analysis_id") long analysis_id, Model model)
    {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());

            Analysis analysis = analysisDao.findByIdAndUser(analysis_id, user);
            Project project = projectDao.findByIdAndUser(projectId, user);

            if (analysis == null) {
                model.addAttribute("error_message", "can not find analysis with this id");
            } else if (analysis.getExperiment().getProject().getId() != projectId) {
                model.addAttribute("error_message", "analysis do not belong to project");
            } else {
                project.deleteAnalysis(analysis);
                projectDao.saveProject(project);
                analysisDao.delete(analysis);
            }

            return "redirect:/projects/" + projectId;
        }
        catch (Exception e)
        {
            model.addAttribute("error_massage", "error while delete analysis in DB");
            return "redirect:/projects/" + projectId;
        }
    }

    @RequestMapping(value = "projects/{projects_id}/analysis", method = RequestMethod.POST)
    public String create(@PathVariable("projects_id") long id,
                         @RequestParam("name") String name, @RequestParam("description") String description,
                         @RequestParam("types") LinkedList<Long> types,
                         @RequestParam("neurons_toPlot") LinkedList<String> neurons_toPlot,
                         @RequestParam("neurons_forAnalysis") LinkedList<String> neurons_forAnalysis,
                         @RequestParam("startTime2plot") double startTime2plot,
                         @RequestParam("time2startCountGrabs") double time2startCountGrabs,
                         @RequestParam("time2endCountGrabs") double time2endCountGrabs,
                         @RequestParam("events") LinkedList<Long> events,
                         @RequestParam("experiment_id") long experiment_id,
                         @RequestParam("font_size") double font_size,
                         @RequestParam("trialsSelected") LinkedList<String> trials,  Model model)
    {

        if (trials == null || trials.isEmpty())
        {
            model.addAttribute("error_message", "failed to create analysis, empty trials");
            model.addAttribute("tif", new LinkedList<String>());
            return "redirect:/projects/" + id;
        }


        if (types == null || types.isEmpty())
        {
            model.addAttribute("error_message", "failed to create analysis, empty types");
            return "redirect:/projects/" + id;
        }

        LinkedList<AnalysisType> analysisTypes = new LinkedList<>();
        LinkedList<ExperimentEvents> experimentEvents = new LinkedList<>();

        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            User user = userService.findUserByEmail(auth.getName());

            Project project = projectDao.findByIdAndUser(id, user);


            if (analysisDao.existsByNameAndUser(name, user)) {
                model.addAttribute("error_message", "failed to create analysis, this analysis name already exists");
                return "redirect:/projects/" + id;
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
                model.addAttribute("error_massage", "Error can not select trials from different experiments");
                return "redirect:/projects/" + id;
            }

            LinkedList<Trial> allTrials = new LinkedList<>();
            for (String str : trials)
            {
                String[] split = str.split("_");
                long trialId = Long.parseLong(split[1]);
                long experimentId = Long.parseLong(split[0]);

                if (experimentId != experiment_id)
                {
                    model.addAttribute("error_massage", "Error can not select trials from different experiments");
                    return "redirect:/projects/" + id;
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


            if (!xmlCreator.createXml(analysis, font_size, neuronsAnalysis, neuronsPlot, experimentEvents, startTime2plot, time2startCountGrabs, time2endCountGrabs)) {
                model.addAttribute("error_massage", "Error while creating Analysis Xml");
                return "redirect:/projects/" + id;
            }

            if (runAnalysis == null)
            {
                model.addAttribute("error_massage", "Error bean name for matlab");
                return "redirect:/projects/" + id;
            }

            sendToMatlab(analysis, model);

            return "redirect:/projects/" + id + "/analysis/" + analysis.getId();

        } catch (Exception e)
        {
            model.addAttribute("error_massage", "Error while creating Analysis in DB");
            return "redirect:/projects/" + id;
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

    private void sendToMatlab(Analysis analysis, Model model) {
        String dropboxPathLocal = environment.getProperty("dropbox.local.location");
        List<String > errors = null;
        for (AnalysisType type : analysis.getAnalysisType())
        {
            Project project = analysis.getExperiment().getProject();
            String path = dropboxPathLocal + File.separator + project.getName() + File.separator + analysis.getName();

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

                String pathType = "/" + project.getName() + "/" + analysis.getName() +
                        "/" + type.getName();

                File dir = new File(path + File.separator + type.getName());
                if (dir.exists() && dir.isDirectory()) {
                    File[] files = dir.listFiles();
                    await().atMost(10, TimeUnit.MINUTES).until(() -> ((files != null ? files.length : 0) == dbxClientV2.files().listFolder(pathType).getEntries().size()));

                    LinkedList<String> links = new LinkedList<>();
                    for (File f : files != null ? files : new File[0])
                    {
                        if (f.getName().endsWith(".tif")) {
                            links.add(dbxClientV2.sharing().createSharedLinkWithSettings("/" + project.getName() + "/" + analysis.getName() +
                                    "/" + type.getName() + "/" + f.getName()).getUrl().replace("dl=0", "raw=1"));
                        }
                    }

                    xmlCreator.createLinksXML(links, project.getName() + File.separator + analysis.getName() + File.separator + type.getName());
                }
            } catch (Exception e) {
               // e.printStackTrace();

                if (errors == null)
                {
                    errors = new LinkedList<>();
                }

                errors.add("Error matlab analysis failed for analysis type :" + type.getName());
            }
        }

        if (errors != null)
        {
            model.addAttribute("error_massage", errors);
        }
    }
}
