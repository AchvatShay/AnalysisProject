package com.analysis.manager.Service;

import com.analysis.manager.modle.Experiment;
import com.analysis.manager.modle.Project;
import com.analysis.manager.modle.Trial;
import com.analysis.manager.modle.User;

import java.util.List;

public interface TrialService {
    Trial findByIdAndExperiment(long id, Experiment experiment);

    Trial findByNameAndExperiment(String name, Experiment experiment);

    void deleteTrial(Trial trial);

    void save(Trial trial);
}
