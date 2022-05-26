import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.springframework.boot") version "2.5.6"
    id("io.spring.dependency-management") version "1.0.11.RELEASE"
    kotlin("jvm") version "1.5.31"
    kotlin("plugin.spring") version "1.5.31"
}

group = "de.bitb"
version = "0.0.5"
java.sourceCompatibility = JavaVersion.VERSION_11

repositories {
	mavenCentral()
}

extra["springCloudGcpVersion"] = "3.2.1"
extra["springCloudVersion"] = "2021.0.1"

dependencies {
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.13.+")
    implementation("com.fasterxml.jackson.module:jackson-module-jsonSchema:2.9.0")

    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

    implementation("com.google.cloud:spring-cloud-gcp-starter")
    implementation("org.springframework.boot:spring-boot-starter-web:2.5.5")
//    implementation("org.springframework.cloud:spring-cloud-gcp-data-firestore")
//    implementation("org.springframework.cloud:spring-cloud-gcp-starter-data-firestore")
    implementation("com.google.firebase:firebase-admin:8.1.0")

    testImplementation("org.springframework.boot:spring-boot-starter-test:2.5.5")
    testImplementation("io.mockk:mockk:1.12.0")
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
        jvmTarget = "11"
    }
}

tasks.withType<Test> {
    useJUnitPlatform()
}