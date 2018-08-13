package com.analysis.manager.modle;

public interface UserService {
    User findUserByEmail(String email);
    void saveUser(User user);
}
