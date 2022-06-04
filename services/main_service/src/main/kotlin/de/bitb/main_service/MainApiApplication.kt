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
import org.springframework.core.env.Environment
import org.springframework.web.client.RestTemplate

fun main(args: Array<String>) {
    runApplication<MainApiApplication>(*args)
}

@SpringBootApplication
class MainApiApplication @Autowired constructor(
    private val buildProperties: BuildProperties,
    private val env: Environment
) {

    private val log: Logger = LoggerFactory.getLogger(MainApiApplication::class.java)

    @Bean
    fun restTemplate(builder: RestTemplateBuilder): RestTemplate = builder.build()

    @Bean
    @Throws(Exception::class)
    fun run(restTemplate: RestTemplate): CommandLineRunner =
        CommandLineRunner {
            log.info("Run MainApiApplication: v${buildProperties.version}")
            if (FirebaseApp.getApps().isEmpty()) {
                val options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.getApplicationDefault())
//                    .setProjectId(env.getProperty("spring.cloud.gcp.project-id"))//TODO make this anders
//                    .setCredentials(GoogleCredentials.fromStream(FileInputStream("../../../../../../../../qcar-firebase-adminsdk.json")))
//                .setDatabaseUrl("https://<DATABASE_NAME>.firebaseio.com/")
                    .build()
                FirebaseApp.initializeApp(options)
            }
        }
}
