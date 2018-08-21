package com.analysis.manager.Service;

import com.analysis.manager.modle.User;

import java.util.List;

public interface UserService {
    User findUserByEmail(String email);
    void saveUser(User user);

    User findById(long id);
    void delete(User user);

    List<User> findAll();

    void changeRole(User user);
}
