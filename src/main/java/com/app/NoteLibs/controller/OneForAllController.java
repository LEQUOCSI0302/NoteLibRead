package com.app.NoteLibs.controller;

import com.app.NoteLibs.model.Genre;
import com.app.NoteLibs.service.GenreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import java.util.List;

@ControllerAdvice
public class OneForAllController {
    @Autowired
    private GenreService genreService;

    @ModelAttribute("genres")
    public List<Genre> genres(){
        return genreService.getAllGenres();
    }
}
