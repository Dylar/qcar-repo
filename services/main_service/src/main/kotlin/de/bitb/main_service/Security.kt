package de.bitb.main_service

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.core.userdetails.User
import org.springframework.security.core.userdetails.UserDetailsService
import org.springframework.security.provisioning.InMemoryUserDetailsManager
import org.springframework.security.web.SecurityFilterChain

//TODO make this later

//@Configuration
//@EnableWebSecurity
//class WebSecurityConfig {
//    @Bean
//    @Throws(Exception::class)
//    fun securityFilterChain(http: HttpSecurity): SecurityFilterChain {
//        http
//            .authorizeHttpRequests {
//                it.requestMatchers("/").permitAll().anyRequest().authenticated()
//            }
//            .formLogin {
//                it.loginPage("/login").permitAll()
//            }
//            .logout {
//                it.permitAll()
//            }
//        return http.build()
//    }
//
//    @Bean
//    fun userDetailsService(): UserDetailsService {
//        val user = User.builder()
//            .username("user")
//            .password("password")
//            .roles("USER")
//            .build()
//        return InMemoryUserDetailsManager(user)
//    }
//}
