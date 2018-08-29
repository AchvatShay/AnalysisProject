package com.analysis.manager;

import AnalysisManager.RunAnalysis;
import com.analysis.manager.modle.Experiment;
import com.analysis.manager.modle.Trial;
import com.mathworks.toolbox.javabuilder.MWCharArray;
import com.mathworks.toolbox.javabuilder.MWNumericArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

public class ExperimentDataBean {
    private static final Logger logger = LoggerFactory.getLogger(ExperimentDataBean.class);


    @Autowired
    private RunAnalysis analysisMatlab;


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
            List<Trial> trials = experiment.getTrials();
            if (trials != null && trials.size() > 0) {
                MWCharArray tpa = new MWCharArray(trials.get(0).getBda());

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
}
