package de.bitb.main_service

import org.junit.jupiter.api.extension.ExtendWith
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.web.client.TestRestTemplate
import org.springframework.boot.web.server.LocalServerPort
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.context.junit.jupiter.SpringExtension

@ExtendWith(SpringExtension::class)
@SpringBootTest(
	webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
//	classes = [TestApplication.ControllerTestConfig::class],
//	properties = ["spring.example.property=foobar"]
)
@ActiveProfiles(value = ["test"])
internal class TestApplication {

	var testRestTemplate = TestRestTemplate()

	@LocalServerPort
	var serverPort: Int = 8080

	private fun applicationUrl() = "http://localhost:$serverPort"
//	private fun applicationUrl() = "http://localhost:$applicationPort"
}
