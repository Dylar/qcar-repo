import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("com.github.ben-manes.versions") version "0.44.0"
    id("org.springframework.boot") version "3.0.2"
    id("io.spring.dependency-management") version "1.1.0"
    kotlin("jvm") version "1.8.0"
    kotlin("plugin.spring") version "1.8.0"
}

repositories {
    mavenCentral()
}

group = "de.bitb"
version = project.property("serviceVersion") ?: "VERSION-ERROR"
java.sourceCompatibility = JavaVersion.VERSION_17

extra["springCloudGcpVersion"] = "3.4.2"
extra["springCloudVersion"] = "2021.0.1"
val springBootVersion = "3.0.2"

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-reflect:1.8.0")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.8.0")

    implementation("org.springframework.security:spring-security-config:6.0.1")
    implementation("org.springframework.boot:spring-boot-starter-actuator:$springBootVersion")
    implementation("org.springframework.boot:spring-boot-starter-security:$springBootVersion")
    implementation("org.springframework.boot:spring-boot-starter-web:$springBootVersion")
    implementation("org.springframework.boot:spring-boot-starter-thymeleaf:$springBootVersion")

    implementation("com.google.cloud:spring-cloud-gcp-starter:3.4.2")
    implementation("com.google.firebase:firebase-admin:9.1.1")

    implementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.14.1")
    implementation("com.fasterxml.jackson.module:jackson-module-jsonSchema:2.14.1")

    testImplementation("org.springframework.boot:spring-boot-starter-test:$springBootVersion") {
        exclude(module = "junit")
        exclude(module = "junit-vintage-engine")
        exclude(module = "mockito-core")
    }
    testImplementation("com.ninja-squad:springmockk:4.0.0")
    testImplementation("io.mockk:mockk:1.13.3")
}

dependencyManagement {
    imports {
        mavenBom("com.google.cloud:spring-cloud-gcp-dependencies:${property("springCloudGcpVersion")}")
        mavenBom("org.springframework.cloud:spring-cloud-dependencies:${property("springCloudVersion")}")
    }
}

springBoot {
    buildInfo()
}

tasks.withType<KotlinCompile> {
    kotlinOptions {
        freeCompilerArgs = listOf("-Xjsr305=strict")
        jvmTarget = "17"
    }
}

tasks.withType<Test> {
    useJUnitPlatform()
}

tasks.register("getVersion") { doLast { logger.quiet("$version") } }
tasks.register("getName") { doLast { logger.quiet(rootProject.name) } }
