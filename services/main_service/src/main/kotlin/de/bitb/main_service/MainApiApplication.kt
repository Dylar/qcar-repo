package de.bitb.main_service

import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.CommandLineRunner
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.info.BuildProperties
import org.springframework.boot.runApplication
import org.springframework.boot.web.client.RestTemplateBuilder
import org.springframework.context.annotation.Bean
import org.springframework.web.client.RestTemplate


fun main(args: Array<String>) {
    runApplication<MainApiApplication>(*args)
}

@SpringBootApplication
open class MainApiApplication @Autowired constructor(
    val buildProperties: BuildProperties,
) {

    private val log: Logger = LoggerFactory.getLogger(MainApiApplication::class.java)

    @Bean
    open fun restTemplate(builder: RestTemplateBuilder): RestTemplate = builder.build()

    @Bean
    @Throws(Exception::class)
    open fun run(restTemplate: RestTemplate): CommandLineRunner =
        CommandLineRunner {
            if (FirebaseApp.getApps().isEmpty()) {
                val options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.getApplicationDefault())
                    .setProjectId("qcar-d8b88")//TODO make this anders
//                .setDatabaseUrl("https://<DATABASE_NAME>.firebaseio.com/")
                    .build()
                FirebaseApp.initializeApp(options)
            } 
            log.info("Run MainApiApplication: v${buildProperties.version}")
        }
}
