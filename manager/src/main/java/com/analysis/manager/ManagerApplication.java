package com.analysis.manager;

import com.analysis.manager.modle.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;

@SpringBootApplication
public class ManagerApplication {


    public static void main(String[] args) {
        SpringApplication.run(ManagerApplication.class, args);


    }


    @Autowired
    private Environment env;


    @Autowired
    private ExperimentTypeDao experimentTypeDao;

    @Autowired
    private ExperimentInjectionsDao experimentInjectionsDao;

    @Autowired
    private PermissionsDao permissionsDao;

    @Bean
    public boolean dbInit()
    {
        LoadExperimentType();
        LoadExperimentInjections();
        LoadUsersPermissions();

        return true;
    }

    public void LoadExperimentType()
    {
        for (String type: env.getProperty("db.experiment.type").split(",")) {
            if (experimentTypeDao.getByName(type) == null)
            {
                experimentTypeDao.create(new ExperimentType(type));
            }
        }
    }

    public void LoadExperimentInjections()
    {
        for (String type: env.getProperty("db.experiment.injections").split(",")) {
            if (experimentInjectionsDao.getByName(type) == null)
            {
                experimentInjectionsDao.create(new ExperimentInjections(type));
            }
        }
    }

    public void LoadUsersPermissions()
    {
        if (permissionsDao.getByValue("Administrator") == null)
        {
            permissionsDao.create(new Permissions("Administrator"));
        }

        if (permissionsDao.getByValue("View") == null)
        {
            permissionsDao.create(new Permissions("View"));
        }


        if (permissionsDao.getByValue("Edit") == null)
        {
            permissionsDao.create(new Permissions("Edit"));
        }
    }
}
