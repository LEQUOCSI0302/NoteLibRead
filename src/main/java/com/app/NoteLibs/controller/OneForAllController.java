package com.app.NoteLibs.controller;

import com.app.NoteLibs.model.Genre;
import com.app.NoteLibs.model.User;
import com.app.NoteLibs.security.CustomUserDetails;
import com.app.NoteLibs.service.GenreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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

    @ModelAttribute("currentUser")
    public User currentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated() && !"anonymousUser".equals(authentication.getPrincipal())) {
            Object principal = authentication.getPrincipal();
            if (principal instanceof CustomUserDetails customUserDetails) {
                return customUserDetails.getUser();
            }
        }
        return null;
    }
}
