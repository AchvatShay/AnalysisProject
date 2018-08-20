package com.analysis.manager.Service;

import com.analysis.manager.modle.*;

import java.util.List;

public interface AnalysisService {
    Analysis findByIdAndUser(long id, User user);
    List<Analysis> findAllByUser(User user);

    boolean existsByNameAndUser(String name, User user);
    void save(Analysis analysis);
    void delete(Analysis analysis);

    void deleteByExperiment(Experiment experiment);

    List<Analysis> findAllByExperimentNotLike(Experiment experiment);
}
