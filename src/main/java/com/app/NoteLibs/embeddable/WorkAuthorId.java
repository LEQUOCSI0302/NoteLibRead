package com.app.NoteLibs.embeddable;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
public class WorkAuthorId implements Serializable {
    @Column(name = "work_id")
    private Long workId;

    @Column(name = "author_id")
    private Long authorId;

    @Column(name = "role")
    private String role;
}
