package com.app.NoteLibs.config;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/images/**","/css/**","/js/**").permitAll()
                        .requestMatchers("/", "/login", "/register", "/top-works", "/top-authors",
                                "/discussions", "/genres/**", "/contribute").permitAll()
                        .requestMatchers("/api/**").permitAll()
                        .requestMatchers("/profile", "/settings").authenticated() // các trang thật sự cần login
                        .anyRequest().permitAll() // hoặc .authenticated() tuỳ ý đồ
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .defaultSuccessUrl("/", true)
                        .permitAll()
                ).logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/?logout")
                        .permitAll()
                );
        return http.build();
    }
}
