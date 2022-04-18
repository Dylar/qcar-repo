package de.bitb.main_service

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.runApplication
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.web.client.RestTemplate;


fun main(args: Array<String>) {
    runApplication<MainApiApplication>(*args)
}

@SpringBootApplication
open class MainApiApplication {
    private val log: Logger = LoggerFactory.getLogger(MainApiApplication::class.java)
//    private val url = "https://quoters.apps.pcfone.io/api/random"

    @Bean
    open fun restTemplate(builder: RestTemplateBuilder): RestTemplate = builder.build()

    @Bean
    @Throws(Exception::class)
    open fun run(restTemplate: RestTemplate): CommandLineRunner =
        CommandLineRunner {
            log.info("Run MainApiApplication")

//                args: Array<String?>? ->
//            val quote = restTemplate.getForObject(url, Quote::class.java)
//            log.info(quote.toString())
        }
}
