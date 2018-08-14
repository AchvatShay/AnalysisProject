package com.analysis.manager.Service;

import com.analysis.manager.modle.Analysis;
import com.analysis.manager.modle.Animal;
import com.analysis.manager.modle.Layer;
import com.analysis.manager.modle.User;

import java.util.List;

public interface AnalysisService {
    Analysis findByIdAndUser(long id, User user);
    List<Analysis> findAllByUser(User user);

    boolean existsByNameAndUser(String name, User user);
    void save(Analysis analysis);
    void delete(Analysis analysis);
}
