
package com.example;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@RestController
@RequestMapping("/api")
@ConfigurationProperties(prefix="greeting")
public class GreetingBackendRestController {

    private RestTemplate template = new RestTemplate();

    private String saying;

    @Value("${greeting.backendServiceHost}")
    private String backendServiceHost;
    @Value("${greeting.backendServicePort}")
    private int backendServicePort;

    @RequestMapping(value = "/greeting", method = RequestMethod.GET, produces = "text/plain")
    public String greeting(){

        // Talk to Backend REST API
        String backendServiceUrl = String.format("http://%s:%d/api/hellobackend?greeting={greeting}", backendServiceHost, backendServicePort);

        System.out.println("Sending to: " + backendServiceUrl);

        BackendDTO response = template.getForObject(backendServiceUrl, BackendDTO.class, saying);

        return response.getGreeting() + " at host: " + response.getIp() + " Time: " + response.getTime();

    }

    
    public String getSaying() {
        return saying;
    }

    public void setSaying(String saying) {
        this.saying = saying;
    }

    public String getBackendServiceHost() {
        return backendServiceHost;
    }

    public void setBackendServiceHost(String backendServiceHost) {
        this.backendServiceHost = backendServiceHost;
    }

    public int getBackendServicePort() {
        return backendServicePort;
    }

    public void setBackendServicePort(int backendServicePort) {
        this.backendServicePort = backendServicePort;
    }




}


