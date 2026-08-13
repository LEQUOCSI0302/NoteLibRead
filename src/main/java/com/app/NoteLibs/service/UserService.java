package com.app.NoteLibs.service;

import com.app.NoteLibs.dto.RegisterRequest;
import com.app.NoteLibs.enums.UserRole;
import com.app.NoteLibs.model.User;
import com.app.NoteLibs.repository.UserRepository;
import com.app.NoteLibs.security.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class UserService implements UserDetailsService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    /**
     * Spring Security gọi hàm này khi login (formLogin dùng "username" param).
     * Cho phép nhập username hoặc email vào cùng 1 ô.
     */
    @Override
    public UserDetails loadUserByUsername(String usernameOrEmail) throws UsernameNotFoundException {
        User user = userRepository.findByUsernameOrEmail(usernameOrEmail, usernameOrEmail)
                .orElseThrow(() -> new UsernameNotFoundException(
                        "Không tìm thấy tài khoản: " + usernameOrEmail));
        return new CustomUserDetails(user);
    }
    /**
     * Tạo user mới. Không kiểm tra trùng/khớp mật khẩu ở đây —
     * việc đó nằm ở AuthController (để add lỗi vào BindingResult, hiển thị lên form).
     */
    @Transactional
    public User register(RegisterRequest request) {
        User user = new User();
        user.setUsername(request.getUsername().trim());
        user.setEmail(request.getEmail().trim().toLowerCase());
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setRole(UserRole.USER);
        user.setReputation(0);
        user.setVerified(false);
        user.setBanned(false);
        user.setSuspicious(false);
        user.setCreatedAt(LocalDateTime.now());
        return userRepository.save(user);
    }

    public boolean isUsernameTaken(String username) {
        return userRepository.existsByUsername(username);
    }

    public boolean isEmailTaken(String email) {
        return userRepository.existsByEmail(email.toLowerCase());
    }

}
