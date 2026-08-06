package com.app.NoteLibs.model;

import com.app.NoteLibs.embeddable.WorkAuthorId;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "work_authors")
@Data
public class WorkAuthor {
    @EmbeddedId
    private WorkAuthorId id;

    @ManyToOne
    @MapsId("workId")
    @JoinColumn(name = "work_id")
    private Work work;

    @ManyToOne
    @MapsId("authorId")
    @JoinColumn(name = "author_id")
    private Author author;
}
