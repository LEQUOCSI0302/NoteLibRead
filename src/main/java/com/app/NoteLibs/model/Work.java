package com.app.NoteLibs.model;

import com.app.NoteLibs.enums.WorkStatus;
import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.JdbcType;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "work")
@Data
public class Work {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne @JoinColumn(name = "type_id", nullable = false)
    private WorkType workType;

    @Column(nullable = false, length = 500)
    private String title;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "alt_titles",columnDefinition = "JSON")
    private List<String> altTitles;

    @Column(unique = true, nullable = false, length = 500)
    private String slug;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "cover_url", length = 500)
    private String coverUrl;

    @Column(name = "release_date")
    private LocalDate releaseDate;

    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    public WorkStatus status;

    @Column(name = "total_episodes")
    private Integer totalEpisodes;

    @Column(name = "total_chapters")
    private Integer totalChapters;

    @Column(name = "view_count")
    private Long viewCount;

    @Column(name = "avg_rating", precision = 3, scale = 2)
    private BigDecimal avgRating;

    @Column(name = "rating_count")
    private Integer ratingCount;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @OneToMany(mappedBy = "work", cascade = CascadeType.ALL)
    private List<WorkImage> images;

    @OneToMany(mappedBy = "work", cascade = CascadeType.ALL)
    private List<WorkAuthor> workAuthors;

    @ManyToMany @JoinTable(name = "work_genres", joinColumns = @JoinColumn(name ="work_id"), inverseJoinColumns = @JoinColumn(name = "genre_id"))
    private List<Genre> genres;

    @OneToMany(mappedBy = "work", cascade = CascadeType.ALL)
    private List<WorkEpisode> episodes;

    @OneToMany(mappedBy = "work", cascade = CascadeType.ALL)
    private List<Rating> ratings;

    @OneToMany(mappedBy = "work", cascade = CascadeType.ALL)
    private List<Discussion> discussions;
}
