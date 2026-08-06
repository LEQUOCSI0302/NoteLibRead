package com.app.NoteLibs;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class NoteLibsApplication {

	public static void main(String[] args) {
		SpringApplication.run(NoteLibsApplication.class, args);
	}

}
