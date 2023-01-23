package de.bitb.main_service.controller

import de.bitb.main_service.StartupTime
import de.bitb.main_service.formatDateString
import org.springframework.boot.ApplicationArguments
import org.springframework.boot.info.BuildProperties
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping

@Controller
class HtmlController(
    private val buildProperties: BuildProperties
) {

    @GetMapping("/")
    fun index(model: Model, startupTime: StartupTime): String {
        model.addAttribute("startTime", formatDateString(startupTime.startupTime))
        model.addAttribute("version", buildProperties.version)
        return "index"
    }

    @GetMapping("/health")
    fun version(model: Model): String {
        model.addAttribute("version", buildProperties.version)
        return "health"
    }
}