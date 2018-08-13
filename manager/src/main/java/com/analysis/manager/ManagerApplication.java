package com.analysis.manager;

import com.analysis.manager.modle.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;

@SpringBootApplication
public class ManagerApplication  extends SpringBootServletInitializer {

    public static void main(String[] args) {
        try {
            SpringApplicationBuilder builder = new SpringApplicationBuilder(ManagerApplication.class);
            builder.headless(false).run(args);
        }
        catch (Exception e) {
            System.out.println("Your Message : " + e.getMessage());
        }

    }


    @Autowired
    private Environment env;


    @Autowired
    private ExperimentTypeDao experimentTypeDao;

    @Autowired
    private ExperimentInjectionsDao experimentInjectionsDao;


    @Autowired
    private ExperimentPelletPertubationDao experimentPelletPertubationDao;

    @Autowired
    private RoleDao roleDao;

    @Autowired
    private ExperimentEventsDao experimentEventsDao;

    @Bean
    public boolean dbInit()
    {
        LoadExperimentType();
        LoadExperimentInjections();
        LoadUsersPermissions();
        LoadExperimentPelletPertubation();
        LoadExperimentEvents();

        return true;
    }

    private void LoadExperimentEvents() {
        for (String type: env.getProperty("db.experiment.events").split(",")) {
            if (experimentEventsDao.getByName(type) == null)
            {
                experimentEventsDao.create(new ExperimentEvents(type));
            }
        }
    }

    private void LoadExperimentType()
    {
        for (String type: env.getProperty("db.experiment.type").split(",")) {
            if (experimentTypeDao.getByName(type) == null)
            {
                experimentTypeDao.create(new ExperimentType(type));
            }
        }
    }

    private void LoadExperimentInjections()
    {
        for (String type: env.getProperty("db.experiment.injections").split(",")) {
            if (experimentInjectionsDao.getByName(type) == null)
            {
                experimentInjectionsDao.create(new ExperimentInjections(type));
            }
        }
    }

    private void LoadExperimentPelletPertubation()
    {
        for (String type: env.getProperty("db.experiment.pelletPertubation").split(",")) {
            if (experimentPelletPertubationDao.getByName(type) == null)
            {
                experimentPelletPertubationDao.create(new ExperimentPelletPertubation(type));
            }
        }
    }

    private void LoadUsersPermissions()
    {
        if (roleDao.findByRole("ADMIN") == null)
        {
            Role role = new Role();
            role.setRole("ADMIN");
            roleDao.save(role);
        }
    }
}
