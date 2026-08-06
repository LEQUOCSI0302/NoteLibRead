package com.app.NoteLibs.model;

import com.app.NoteLibs.enums.WatchStatus;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_watch_history")
@Data
public class UserWatchHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "work_id")
    private Work work;

    @Column(name = "custom_title", length = 500)
    private String customTitle;

    @Column(name = "source_url", columnDefinition = "TEXT")
    private String sourceUrl;

    @Enumerated(EnumType.STRING)
    private WatchStatus status;

    @Column(name = "progress_note", length = 100)
    private String progressNote;

    @Column(name = "personal_note", columnDefinition = "TEXT")
    private String personalNote;

    @Column(name = "personal_rating")
    private Integer personalRating;

    @Column(name = "started_at")
    private LocalDate startedAt;

    @Column(name = "finished_at")
    private LocalDate finishedAt;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
