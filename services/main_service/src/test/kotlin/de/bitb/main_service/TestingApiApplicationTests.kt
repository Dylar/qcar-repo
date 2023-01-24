package de.bitb.main_service

import com.fasterxml.jackson.databind.ObjectMapper
import org.junit.jupiter.api.extension.ExtendWith
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.web.client.TestRestTemplate
import org.springframework.boot.test.web.server.LocalServerPort
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.core.userdetails.User
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.provisioning.InMemoryUserDetailsManager
import org.springframework.security.web.SecurityFilterChain
import org.springframework.test.context.junit.jupiter.SpringExtension


@ExtendWith(SpringExtension::class)
@SpringBootTest(
    webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
//	classes = [TestApplication.ControllerTestConfig::class],
//	properties = ["spring.example.property=foobar"]
)
internal class TestApplication {

    var testRestTemplate = TestRestTemplate()

    @LocalServerPort
    var serverPort: Int = 2203

    private fun applicationUrl() = "http://localhost:$serverPort"

    //	private fun applicationUrl() = "http://localhost:$applicationPort"
    @Bean
    fun mapper(): ObjectMapper? {
        return ObjectMapper()
    }
}
