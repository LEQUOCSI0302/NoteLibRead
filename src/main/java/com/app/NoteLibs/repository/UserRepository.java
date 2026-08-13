package com.app.NoteLibs.repository;

import com.app.NoteLibs.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    boolean existsByUsername(String username);
    boolean existsByEmail(String name);

    // Dùng cho login cho phép đăng nhập = username hoặc email
    Optional<User> findByUsernameOrEmail(String username, String email);
}
