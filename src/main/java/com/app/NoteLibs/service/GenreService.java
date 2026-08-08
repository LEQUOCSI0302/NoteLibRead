package com.app.NoteLibs.service;

import com.app.NoteLibs.model.Genre;
import com.app.NoteLibs.repository.GenreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class GenreService {
    
    @Autowired
    private GenreRepository genreRepository;
    
    public List<Genre> getAllGenres() {
        return genreRepository.findAll();
    }
    public Genre getGenreBySlug(String slug) {
        return genreRepository.findBySlug(slug);
    }
}
