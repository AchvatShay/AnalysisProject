package com.analysis.manager.Service;

import com.analysis.manager.Dao.AnalysisDao;
import com.analysis.manager.modle.Analysis;
import com.analysis.manager.modle.User;
import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.IOException;
import java.util.List;

@Service("analysisService")
@Transactional
public class AnalysisServiceImpl implements AnalysisService {
    @Autowired
    private AnalysisDao analysisDao;

    @Autowired
    private Environment environment;

    @Override
    public Analysis findByIdAndUser(long id, User user) {
        return analysisDao.findByIdAndUser(id,user);
    }

    @Override
    public List<Analysis> findAllByUser(User user) {
        return analysisDao.findAllByUser(user);
    }

    @Override
    public boolean existsByNameAndUser(String name, User user) {
        return analysisDao.existsByNameAndUser(name, user);
    }

    @Override
    public void save(Analysis analysis) {
        analysisDao.save(analysis);
    }

    @Override
    public void delete(Analysis analysis) {
        // delete from dropbox
        String dropboxPathLocal = environment.getProperty("dropbox.local.location");
        String path = dropboxPathLocal + File.separator + analysis.getExperiment().getProject().getName() + File.separator + analysis.getName();

        try {
            FileUtils.deleteDirectory(new File(path));
        } catch (IOException e) {
            // TODO
            // logging
        }

        analysisDao.delete(analysis);
    }
}
