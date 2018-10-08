package com.analysis.manager;

import AnalysisManager.RunAnalysis;
import com.analysis.manager.modle.*;
import com.mathworks.toolbox.javabuilder.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;

import java.io.File;
import java.util.Comparator;
import java.util.List;

public class ExperimentDataBean {
    private static final Logger logger = LoggerFactory.getLogger(ExperimentDataBean.class);


    @Autowired
    private RunAnalysis analysisMatlab;

    @Value("${analysis.results.location}")
    private String pathAnalysis;

    public String getNeurons(Experiment experiment) {
        StringBuilder n = new StringBuilder();
        try {
            List<Trial> trials = experiment.getTrials();
            if (trials != null && trials.size() > 0) {
                MWCharArray tpa = new MWCharArray(trials.get(0).getTpa());

                Object[] results = analysisMatlab.getAllExperimentNeurons(1, tpa);


                if (results[0] instanceof MWNumericArray) {
                    MWNumericArray neurons_names = ((MWNumericArray) results[0]);
                    for (long[] j : (long[][]) neurons_names.toLongArray()) {
                        n.append(String.valueOf(j[0])).append(',');
                    }
                } else {
                    return "";
                }

                n.deleteCharAt(n.lastIndexOf(","));
                return n.toString();
            }

            return "";
        } catch (Exception e) {
            logger.error(e.getMessage());
            return "";
        }
    }

    public String getLabels(Experiment experiment) {
        StringBuilder n = new StringBuilder();
        try {
            MWCellArray bdaFiles = new MWCellArray(1, experiment.getTrials().size());
            int currentIndex = 1;
            for (Trial trial : experiment.getTrials())
            {
                bdaFiles.set(currentIndex, trial.getBda());
                currentIndex++;
            }

            Object[] results = analysisMatlab.getAllExperimentLabels(1, bdaFiles);

            if (results[0] instanceof MWCellArray) {
                MWCellArray neurons_names = ((MWCellArray) results[0]);
                for (MWArray j :  neurons_names.asList()) {

                    n.append(j.toString()).append(',');
                }
            } else {
                return "";
            }

            n.deleteCharAt(n.lastIndexOf(","));
            return n.toString();
        } catch (Exception e) {
            logger.error(e.getMessage());
            return "";
        }
    }

    public String  sendToMatlab(Analysis analysis) {
        StringBuilder errors = new StringBuilder();
        analysis.getTrials().sort(Comparator.comparing(Trial::getName));

        for (AnalysisType type : analysis.getAnalysisType())
        {
            Project project = analysis.getExperiment().getProject();
            String path = pathAnalysis + File.separator + project.getUser().getName() + "_" + project.getUser().getLastName() + File.separator + project.getName() + File.separator + analysis.getName();
            path = path.toLowerCase();

            try {
                MWCharArray xmlLocation = new MWCharArray(path + File.separator + "XmlAnalysis.xml");

                MWCharArray analysisOutputFolder = new MWCharArray(path + File.separator + type.getName().toLowerCase());
                MWStructArray BDA_TPA = new MWStructArray(1, analysis.getTrials().size(), new String[] {"BDA", "TPA"});

                int count = 1;
                for (Trial trial : analysis.getTrials())
                {
                    BDA_TPA.set("BDA", new int[] {1, count}, trial.getBda());
                    BDA_TPA.set("TPA", new int[] {1, count}, trial.getTpa());
                    count++;
                }

                MWCharArray analysisName = new MWCharArray(type.getName());

                analysisMatlab.runAnalysis(analysisOutputFolder, xmlLocation, BDA_TPA, analysisName);
                analysisMatlab.CloseAllFigures();
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
