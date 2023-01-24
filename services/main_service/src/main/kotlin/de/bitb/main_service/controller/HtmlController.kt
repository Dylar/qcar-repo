package de.bitb.main_service.controller

import de.bitb.main_service.StartupTime
import de.bitb.main_service.formatDateString
import jakarta.servlet.http.HttpServletRequest
import org.springframework.boot.info.BuildProperties
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping

@Controller
class HtmlController(
    private val buildProperties: BuildProperties,
    private val startupTime: StartupTime,
) {

    @GetMapping("/")
    fun index(model: Model): String {
        model.addAttribute("startTime", formatDateString(startupTime.startupTime))
        model.addAttribute("version", buildProperties.version)
        return "index"
    }

    @GetMapping("/error")
    fun error(model: Model): String {
//        val error: Map<String, Any>? = request.getAttribute("javax.servlet.error.exception") as? Map<String, Any>
//        model.addAttribute("errorText", error?.get("message") ?: "DAFUQ")
        model.addAttribute("errorText",  "DAFUQ es klappt")
        return "error"
    }
}