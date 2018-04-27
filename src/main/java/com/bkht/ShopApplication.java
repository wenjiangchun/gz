package com.bkht;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableJpaRepositories(repositoryBaseClass = com.bkht.core.jpa.SimpleBaseRepository.class)
public class ShopApplication {
    public static void main(String[] args) {
        ApplicationContext ctx = SpringApplication.run(ShopApplication.class, args);
       // ArcGISUtils.convert();
    }
}
