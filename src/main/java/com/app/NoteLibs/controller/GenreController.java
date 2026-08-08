package com.app.NoteLibs.controller;

import com.app.NoteLibs.model.Genre;
import com.app.NoteLibs.service.GenreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/genres")
public class GenreController {
    
    @Autowired
    private GenreService genreService;


    @GetMapping
    public List<Genre> getAllGenres() {
        return genreService.getAllGenres();
    }

    @GetMapping("/{slug}")
    public Genre getGenreBySlug(@PathVariable String slug) {
        return genreService.getGenreBySlug(slug);
    }
}
