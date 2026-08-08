package com.app.NoteLibs.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home() {
        return "home";
    }

    @GetMapping("/top-works")
    public String topWorks() {
        return "top-works";
    }

    @GetMapping("/top-authors")
    public String topAuthors() {
        return "top-authors";
    }

    @GetMapping("/discussions")
    public String discussions() {
        return "discussions";
    }

    @GetMapping("/genres")
    public String genres() {
        return "genres";
    }

    @GetMapping("/contribute")
    public String contribute() {
        return "contribute";
    }
}
