package com.analysis.manager;

import AnalysisManager.RunAnalysis;
import com.analysis.manager.modle.Experiment;
import com.analysis.manager.modle.Trial;
import com.mathworks.toolbox.javabuilder.MWCharArray;
import com.mathworks.toolbox.javabuilder.MWNumericArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.LinkedList;
import java.util.List;

public class NeuronsBean {
    private static final Logger logger = LoggerFactory.getLogger(NeuronsBean.class);


    @Autowired
    private RunAnalysis analysisMatlab;


    public List<String> getNeurons(Experiment experiment) {
        List<String> n = new LinkedList<>();
        try {
            List<Trial> trials = experiment.getTrials();
            if (trials != null && trials.size() > 0) {
                MWCharArray tpa = new MWCharArray(trials.get(0).getTpa().getFileLocation());

                Object[] results = analysisMatlab.getAllExperimentNeurons(1, tpa);


                if (results[0] instanceof MWNumericArray) {
                    MWNumericArray neurons_names = ((MWNumericArray) results[0]);
                    for (long[] j : (long[][]) neurons_names.toLongArray()) {
                        n.add(String.valueOf(j[0]));
                    }
                } else {
                    return n;
                }

                return n;
            }

            return n;
        } catch (Exception e) {
            logger.error(e.getMessage());
            return n;
        }
    }
}
