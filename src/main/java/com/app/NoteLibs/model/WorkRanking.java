package com.app.NoteLibs.model;

import com.app.NoteLibs.enums.RankingScope;
import jakarta.persistence.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "work_rankings")
@Data
public class WorkRanking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "work_id", nullable = false)
    private Long workId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private RankingScope scope;

    @Column(name = "scope_value", nullable = false, length = 50)
    private String scopeValue;

    @Column(name = "rank_position", nullable = false)
    private Integer rankPosition;

    @Column(nullable = false, precision = 10, scale = 4)
    private BigDecimal score;

    @Column(name = "computed_at")
    private LocalDateTime computedAt;
}
