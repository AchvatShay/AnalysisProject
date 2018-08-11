package com.analysis.manager.controllers;

import com.analysis.manager.XmlCreator;
import com.analysis.manager.modle.*;
import com.dropbox.core.DbxException;
import com.dropbox.core.v2.DbxClientV2;
import com.dropbox.core.v2.files.GetTemporaryLinkResult;
import com.dropbox.core.v2.files.ListFolderResult;
import com.dropbox.core.v2.files.Metadata;
import com.mathworks.toolbox.javabuilder.MWCharArray;
import com.mathworks.toolbox.javabuilder.MWStructArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
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


@Controller
public class AnalysisController {
    @Autowired
    private AnalysisDao analysisDao;

    @Autowired
    private AnalysisTypeDao analysisTypeDao;

    @Autowired
    private ProjectDao projectDao;

    @Autowired
    private DbxClientV2 dbxClientV2;

    @Autowired
    private Environment environment;

    @Autowired
    private ExperimentDao experimentDao;

    @Autowired
    private XmlCreator xmlCreator;

    @Autowired
    private RunAnalysis runAnalysis;

    @Autowired
    private ExperimentEventsDao experimentEventsDao;

    @RequestMapping(value = "projects/{project_id}/analysis/{id}")
    public String view(@PathVariable long project_id, @PathVariable long id, Model m)
    {
        Analysis analysis = analysisDao.getById(id);


        ListFolderResult listFolderResult = null;

        try {

            LinkedHashMap<AnalysisType, List<String>> map = new LinkedHashMap<>();

            for (AnalysisType type: analysis.getAnalysisType()) {
                listFolderResult = dbxClientV2.files().listFolder("/" + analysis.getProject().getName() + "/" + analysis.getName() +
                        "/" + type.getName());

                LinkedList<String> tifFiles = new LinkedList<>();
                for (Metadata metadata : listFolderResult.getEntries()) {
                    if (metadata.getName().endsWith(".tif"))
                    {
                        GetTemporaryLinkResult temporaryLink = dbxClientV2.files().getTemporaryLink(metadata.getPathDisplay());
                        tifFiles.add(temporaryLink.getLink());
                    }
                }

                map.put(type, tifFiles);
            }

            m.addAttribute("tif", map);
        } catch (DbxException e) {
            m.addAttribute("error_message", "failed to load files from dropbox");
            m.addAttribute("tif", new LinkedList<String>());
        }

        m.addAttribute("analysis", analysis);

        return "analysis";
    }

    @RequestMapping(value = "projects/{id}/analysis/{analysis_id}/delete")
    public String delete(@PathVariable("id") long projectId, @PathVariable("analysis_id") long analysis_id, Model model)
    {
        try {
            Analysis analysis = analysisDao.getById(analysis_id);

            if (analysis == null)
            {
                model.addAttribute("error_massage", "Can not find analysis by id = " + analysis_id);
                return "redirect:/projects/" + projectId;
            }

            Project project = projectDao.getById(projectId);

            project.deleteAnalysis(analysis);
            projectDao.update(project);
            analysisDao.delete(analysis);

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
            model.addAttribute("tif", new LinkedList<String>());
            return "redirect:/projects/" + id;
        }

        LinkedList<AnalysisType> analysisTypes = new LinkedList<>();
        LinkedList<ExperimentEvents> experimentEvents = new LinkedList<>();

        try {
            Project project = projectDao.getById(id);

            Experiment experiment = experimentDao.getById(experiment_id);

            for (Long id_type : types) {
                AnalysisType analysisType = analysisTypeDao.getById(id_type);
                analysisTypes.add(analysisType);
            }

            for (Long id_event : events) {
                ExperimentEvents eventsDaoById = experimentEventsDao.getById(id_event);
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

            Analysis analysis = new Analysis(name, description, project, analysisTypes, allTrials, experiment);
            analysisDao.create(analysis);
            project.AddAnalysis(analysis);
            projectDao.update(project);


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
            String path = dropboxPathLocal + File.separator + analysis.getProject().getName() + File.separator + analysis.getName();

            try {
                MWCharArray xmlLocation = new MWCharArray(path + File.separator + "XmlAnalysis.xml");

                MWCharArray analysisOutputFolder = new MWCharArray(path + File.separator + type.getName());
                MWStructArray BDA_TPA = new MWStructArray(1, analysis.getTrials().size(), new String[] {"BDA", "TPA"});

                int count = 1;
                for (Trial trial : analysis.getTrials())
                {
                    BDA_TPA.set("BDA", new int[] {1, count}, trial.getBda().getFile_location());
                    BDA_TPA.set("TPA", new int[] {1, count}, trial.getTpa().getFile_location());
                    count++;
                }

                MWCharArray analysisName = new MWCharArray(type.getName());

                runAnalysis.runAnalysis(analysisOutputFolder, xmlLocation, BDA_TPA, analysisName);

            } catch (Exception e) {
                e.printStackTrace();

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
