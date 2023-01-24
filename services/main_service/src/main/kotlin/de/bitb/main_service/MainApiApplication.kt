package de.bitb.main_service

import com.google.auth.oauth2.GoogleCredentials
import com.google.cloud.firestore.Firestore
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import com.google.firebase.cloud.FirestoreClient
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.CommandLineRunner
import org.springframework.boot.actuate.autoconfigure.security.servlet.ManagementWebSecurityAutoConfiguration
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration
import org.springframework.boot.info.BuildProperties
import org.springframework.boot.runApplication
import org.springframework.boot.web.client.RestTemplateBuilder
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.core.env.Environment
import org.springframework.stereotype.Component
import org.springframework.web.client.RestTemplate
import java.io.IOException
import java.time.LocalDateTime

fun main(args: Array<String>) {
    runApplication<MainApiApplication>(*args)
}

@Component
class StartupTime(val startupTime: LocalDateTime = LocalDateTime.now())

@SpringBootApplication(
    exclude = [
        SecurityAutoConfiguration::class,
        ManagementWebSecurityAutoConfiguration::class,
    ]
)
class MainApiApplication @Autowired constructor(
    private val buildProperties: BuildProperties,
) {

    private val log: Logger = LoggerFactory.getLogger(MainApiApplication::class.java)

    @Bean
    fun restTemplate(builder: RestTemplateBuilder): RestTemplate = builder.build()

    @Bean
    @Throws(Exception::class)
    fun run(restTemplate: RestTemplate): CommandLineRunner =
        CommandLineRunner {
            log.info("Run Service: v${buildProperties.version}")
        }
}

@Configuration
class FirestoreConfig {
    @Bean
    @Throws(IOException::class)
    fun initFirebase(env: Environment): Firestore {
        if (FirebaseApp.getApps().isEmpty()) {
            val options = FirebaseOptions.builder()
                .setCredentials(GoogleCredentials.getApplicationDefault())
                .setProjectId(env.getProperty("spring.cloud.gcp.project-id"))//TODO make this anders?
//                .setCredentials(GoogleCredentials.fromStream(FileInputStream("../../../../../../../../fire.json")))
//                .setDatabaseUrl("https://<DATABASE_NAME>.firebaseio.com/")
                .build()
            FirebaseApp.initializeApp(options)
        }
        return FirestoreClient.getFirestore()
    }
}