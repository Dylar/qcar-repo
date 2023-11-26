pipeline {
    agent any

    environment {
        SERVICE_DIR = 'services/main_service'
        SERVICE_NAME = ''
        SERVICE_VERSION = ''
        JAR_PATH = ''

        DOCKER_NAME = ''
        DOCKER_IMAGE = ''
        DOCKER_REGISTRY = 'https://hub.docker.com/'
    }

    stages {
        stage('Initialize') {
            steps {
                script {
                    dir("${SERVICE_DIR}") {
                        // Run gradle commands to get the service name and version
                        SERVICE_NAME = sh(script: './gradlew -q getName', returnStdout: true).trim()
                        SERVICE_VERSION = sh(script: './gradlew -q getVersion', returnStdout: true).trim()
                    }
                    JAR_PATH = "build/libs/${SERVICE_NAME}-${SERVICE_VERSION}.jar"
                    DOCKER_NAME = "dylar/qcar-${SERVICE_NAME}"
                    DOCKER_IMAGE = "${DOCKER_NAME}:${SERVICE_VERSION}"

                    echo "SERVICE_NAME: $SERVICE_NAME"
                    echo "SERVICE_VERSION: $SERVICE_VERSION"
                }
            }
        }
        stage('Build') {
            steps {
                sh './gradlew build'
            }
        }
        stage('Push Docker') {
            steps {
                script {
                    dir("${SERVICE_DIR}") {
                        docker.build("${DOCKER_IMAGE}","--build-arg JAR_FILE=${env.JAR_PATH} .")
                        docker.withRegistry("${DOCKER_REGISTRY}", 'docker-credentials') {
                            docker.image("${DOCKER_IMAGE}").push()
                        }
                    }
                }
            }
        }
        stage('Update Kubernetes Deployment') {
            steps {
                // Set the new image in the Kubernetes deployment
                sh "kubectl set image deployment/${SERVICE_NAME} ${SERVICE_NAME}=${DOCKER_IMAGE}"
            }
        }
    }
    post {
        always {
           steps {
               echo "This will always run regardless of the result of the pipeline."
           }
        }
    }
}
