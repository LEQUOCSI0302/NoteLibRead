package com.app.NoteLibs.controller;

import com.app.NoteLibs.dto.RegisterRequest;
import com.app.NoteLibs.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
@RequiredArgsConstructor
public class AuthController {
    private final UserService userService;

    @GetMapping("/login")
    public String login() {
        return "auth/login";
    }

    @GetMapping("/register")
    public String register(Model model) {
        model.addAttribute("user", new RegisterRequest());
        return "auth/register";
    }

    @PostMapping("/register")
    public String doRegister(@ModelAttribute("user") @Valid RegisterRequest request,
                             BindingResult result, Model model) {
        // Lỗi validate cơ bản (@NotBlank, @Email, @Size...) -> quay lại form, hiện lỗi field
        if (result.hasErrors()) {
            return "auth/register";
        }
        // Mật khẩu và nhập lại mật khẩu phải khớp
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            result.addError(new FieldError("user", "confirmPassword", "Mật khẩu nhập lại không khớp"));
            return "auth/register";
        }
        // Username / email đã tồn tại chưa
        if (userService.isUsernameTaken(request.getUsername())) {
            result.addError(new FieldError("user", "username", "Tên đăng nhập đã được sử dụng"));
            return "auth/register";
        }
        if (userService.isEmailTaken(request.getEmail())) {
            result.addError(new FieldError("user", "email", "Email đã được sử dụng"));
            return "auth/register";
        }
        // Tạo user, mã hoá mật khẩu, lưu DB
        userService.register(request);
        return "redirect:/login";
    }
}
