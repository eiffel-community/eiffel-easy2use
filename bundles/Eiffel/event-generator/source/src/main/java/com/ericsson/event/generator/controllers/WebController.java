package com.ericsson.event.generator.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class WebController {

//    @Value("${ei.host}")
//    private String serviceHost;
//
//    @Value("${ei.port}")
//    private int servicePort;
    
    @RequestMapping("/")
    public String greeting(Model model) {
        
        System.out.println("HEEEEEEEEEEEEEEEEEEEEEEE");
        model.addAttribute("frontendServiceUrl", "KALLE");
        String eiffelDocumentationUrlLinks = String.format("%s", "OSKAR");
        model.addAttribute("eiffelDocumentationUrlLinks", eiffelDocumentationUrlLinks);
        return "index.html";
    }
    
    
}
