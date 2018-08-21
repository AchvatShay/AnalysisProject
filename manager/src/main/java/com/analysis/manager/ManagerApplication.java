package com.analysis.manager;

import com.analysis.manager.Dao.*;
import com.analysis.manager.modle.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.core.env.Environment;

@SpringBootApplication
public class ManagerApplication  extends SpringBootServletInitializer {

    private static final Logger logger = LoggerFactory.getLogger(ManagerApplication.class);

    public static void main(String[] args) {
        try {
            SpringApplicationBuilder builder = new SpringApplicationBuilder(ManagerApplication.class);
            builder.headless(false).run(args);
            logger.info("Start Analysis Manager Application");
        }
        catch (Exception e) {
            logger.error(e.getMessage());
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
        logger.info("Start Init of Db Static Values from application.property file");
        LoadExperimentType();
        LoadExperimentInjections();
        LoadUsersPermissions();
        LoadExperimentPelletPertubation();
        LoadExperimentEvents();

        return true;
    }

    private void LoadExperimentEvents() {
        for (String type: env.getProperty("db.experiment.events").split(",")) {
            if (!experimentEventsDao.existsByName(type))
            {
                experimentEventsDao.save(new ExperimentEvents(type));
            }
        }
    }

    private void LoadExperimentType()
    {
        for (String type: env.getProperty("db.experiment.type").split(",")) {
            if (!experimentTypeDao.existsByName(type))
            {
                experimentTypeDao.save(new ExperimentType(type));
            }
        }
    }

    private void LoadExperimentInjections()
    {
        for (String type: env.getProperty("db.experiment.injections").split(",")) {
            if (!experimentInjectionsDao.existsByName(type))
            {
                experimentInjectionsDao.save(new ExperimentInjections(type));
            }
        }
    }

    private void LoadExperimentPelletPertubation()
    {
        for (String type: env.getProperty("db.experiment.pelletPertubation").split(",")) {
            if (!experimentPelletPertubationDao.existsByName(type))
            {
                experimentPelletPertubationDao.save(new ExperimentPelletPertubation(type));
            }
        }
    }

    private void LoadUsersPermissions() {
        if (roleDao.findByRole("ADMIN") == null) {
            Role role = new Role();
            role.setRole("ADMIN");
            roleDao.save(role);
        }

        if (roleDao.findByRole("REGULAR") == null) {
            Role role = new Role();
            role.setRole("REGULAR");
            roleDao.save(role);
        }

        if (roleDao.findByRole("WAITING") == null) {
            Role role = new Role();
            role.setRole("WAITING");
            roleDao.save(role);

        }
    }
}
