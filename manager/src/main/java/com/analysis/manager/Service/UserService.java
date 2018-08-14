package com.analysis.manager.Service;

import com.analysis.manager.modle.User;

public interface UserService {
    User findUserByEmail(String email);
    void saveUser(User user);
}
