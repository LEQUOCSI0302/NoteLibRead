package com.app.NoteLibs.model;

import com.app.NoteLibs.embeddable.UserFavoriteId;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name = "user_favorites")
@Data
public class UserFavorite {
    @EmbeddedId
    private UserFavoriteId id;

    @ManyToOne
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @MapsId("workId")
    @JoinColumn(name = "work_id")
    private Work work;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
