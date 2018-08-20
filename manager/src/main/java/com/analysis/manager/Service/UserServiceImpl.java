package com.analysis.manager.Service;

import com.analysis.manager.Dao.RoleDao;
import com.analysis.manager.Dao.UserDao;
import com.analysis.manager.ManagerApplication;
import com.analysis.manager.modle.Project;
import com.analysis.manager.modle.Role;
import com.analysis.manager.modle.User;
import org.apache.tomcat.util.http.fileupload.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;

@Service("userService")
@Transactional
public class UserServiceImpl implements UserService {
    @Autowired
    private UserDao userRepository;
    @Autowired
    private RoleDao roleRepository;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);

    @Value("${analysis.results.location}")
    private String pathAnalysis;

    @Override
    public User findUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public void saveUser(User user) {
        user.setPassword(bCryptPasswordEncoder.encode(user.getPassword()));
        user.setActive(1);
        Role userRole = roleRepository.findByRole("REGULAR");
        user.setRoles(new HashSet<>(Arrays.asList(userRole)));
        userRepository.save(user);

        logger.info("Save user " + user.getName() + "in DB");
    }

    @Override
    public User findById(long id) {
        return userRepository.findById(id);
    }

    @Override
    public void delete(User user) {
        List<Project> projects = projectService.findAllByUser(user);

        for (Project project : projects) {
            projectService.deleteProject(project);
        }

        String path = pathAnalysis + File.separator + user.getName();


        logger.info("Delete user " + user.getName() + " from DB");

        try {
            FileUtils.deleteDirectory(new File(path));
        } catch (IOException e) {
            logger.error(e.getMessage());
        }

        userRepository.delete(user);
    }

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }
}
