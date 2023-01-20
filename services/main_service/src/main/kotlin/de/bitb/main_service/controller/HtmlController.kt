package de.bitb.main_service.controller

import org.springframework.boot.info.BuildProperties
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping

@Controller
class HtmlController(
    private val buildProperties: BuildProperties
) {

    @GetMapping("/")
    fun index(model: Model): String {
        model.addAttribute("version", buildProperties.version)
        return "index"
    }

    @GetMapping("/health")
    fun version(model: Model): String {
        model.addAttribute("version", buildProperties.version)
        return "health"
    }
}