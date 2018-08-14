package com.analysis.manager.Dao;

import com.analysis.manager.modle.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository("roleRepository")
public interface RoleDao extends JpaRepository<Role, Long>{
    Role findByRole(String role);
}
