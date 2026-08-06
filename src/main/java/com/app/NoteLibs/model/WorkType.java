package com.app.NoteLibs.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.Generated;

import java.util.List;

@Entity
@Table(name = "work_type")
@Data
public class WorkType {
    /* khóa chính */
    @Id
    /* Auto-increment (do DB tự sinh giá trị)
     */
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(unique = true, nullable = false, length = 20)
    private String code;

    @Column(nullable = false, length = 50)
    private String name;

    /*
    Quan hệ 1-N với bảng Work
     */
    @OneToMany(mappedBy = "workType")
    private List<Work> works;

}
