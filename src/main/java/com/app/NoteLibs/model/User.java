package com.app.NoteLibs.model;

import com.app.NoteLibs.enums.UserRole;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "users")
@Data
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false, length = 50)
    private String username;

    @Column(unique = true, nullable = false, length = 255)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 255)
    private String passwordHash;

    @Column(name = "avatar_url", length = 500)
    private String avatarUrl;

    @Enumerated(EnumType.STRING) @Column(length = 20)
    private UserRole role;

    @Column(length = 100)
    private String nickname;

    private Integer reputation;

    @Column(name = "is_verified")
    private boolean isVerified;

    @Column(name = "is_banned")
    private boolean isBanned;

    @Column(name = "is_suspicious")
    private boolean isSuspicious;

    @Column(name = "last_login_at")
    private LocalDateTime lastLoginAt;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Rating> ratings;
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Comment> comments;
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Discussion> discussions;
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<UserBadge> userBadges;
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<UserWatchHistory> watchHistories;
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<UserFavorite> favorites;
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Notification> notifications;
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<UserToken> tokens;
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<ReputationLog> reputationLogs;


}
