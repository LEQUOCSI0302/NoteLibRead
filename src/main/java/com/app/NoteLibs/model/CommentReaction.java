package com.app.NoteLibs.model;

import com.app.NoteLibs.embeddable.CommentReactionId;
import com.app.NoteLibs.enums.ReactionType;
import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Entity
@Table(name = "comment_reactions")
@Data
public class CommentReaction {
    @EmbeddedId
    private CommentReactionId id;

    @ManyToOne
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @MapsId("commentId")
    @JoinColumn(name = "comment_id")
    private Comment comment;

    @Enumerated(EnumType.STRING)
    private ReactionType type;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
}
