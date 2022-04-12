package de.bitb.main_service

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.registerKotlinModule
import org.springframework.http.MediaType
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.get

fun <T : Any> MockMvc.getAndParse(url: String, type: Class<T>): T {
    return get(url)
        .andDo { print() }
        .andExpect {
            status { isOk() }
            content { contentType(MediaType.APPLICATION_JSON) }
        }
        .andReturn().response.contentAsByteArray
        .let { ObjectMapper().registerKotlinModule().readValue(it, type) as T }
}