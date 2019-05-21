package com.ericsson.event.generator;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;


@SpringBootApplication
public class App extends SpringBootServletInitializer {

    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(App.class);
    }

    public static final Logger log = LoggerFactory.getLogger(App.class);

    public static void main(String[] args) {

        List<String> logLevels = new ArrayList<String>();
        Collections.addAll(logLevels, "ALL", "DEBUG", "ERROR", "FATAL", "INFO", "TRACE", "WARN");

        if (args != null && args.length > 0 && logLevels.contains(args[0])) {
            System.setProperty("logging.level.root", args[0]);
            System.setProperty("logging.level.org.springframework.web", args[0]);
            System.setProperty("logging.level.com.ericsson.ei", args[0]);
        } else {
            System.setProperty("logging.level.root", "INFO");
            System.setProperty("logging.level.org.springframework.web", "INFO");
            System.setProperty("logging.level.com.ericsson.ei", "INFO");
        }

        SpringApplication.run(App.class, args);
    }
    
}
