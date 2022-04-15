import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.springframework.boot") version "2.5.6"
    id("io.spring.dependency-management") version "1.0.11.RELEASE"
    kotlin("jvm") version "1.5.31"
    kotlin("plugin.spring") version "1.5.31"
}

group = "de.bitb"
version = "0.0.1"
java.sourceCompatibility = JavaVersion.VERSION_11

repositories {
	mavenCentral()
}

dependencies {
    implementation("org.springframework.boot:spring-boot-starter-web:2.5.5")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.13.+")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

    testImplementation("org.springframework.boot:spring-boot-starter-test:2.5.5")
    testImplementation("io.mockk:mockk:1.12.0")
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
//bootBuildImage {
//    imageName = "mycompany/mygroup/myproject:1.0.1"
//    publish = true
//    docker {
//        publishRegistry {
//            url = "http://172.2.3.5:9000/"
//            username = "user"
//            password = "pass"
//        }
//    }
//}

//val imageName: String = "qcar/backend:$version"
//
//docker {
//    name = imageName
//    files("build/libs/${tasks.bootJar.get().archiveFileName.get()}")
//    buildArgs(mapOf("JAR_FILE" to tasks.bootJar.get().archiveFileName.get()))
//}

//tasks.dockerRun
//dockerRun {
//    name project.name
//            image imageName
//            ports '8080:8080'
//    clean true
//}