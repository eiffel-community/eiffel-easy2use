package com.examples.backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication
@EnableConfigurationProperties
public class BackendSpringbootApplication {

	public static void main(String[] args) {
		SpringApplication.run(BackendSpringbootApplication.class, args);
	}
}
