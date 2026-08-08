package com.app.NoteLibs.repository;

import com.app.NoteLibs.model.Genre;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GenreRepository extends JpaRepository<Genre, Integer> {

    Genre findBySlug(String slug);
}
