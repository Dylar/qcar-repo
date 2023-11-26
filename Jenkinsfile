pipeline {
    agent any

    environment {
        SERVICE_DIR = 'services/main_service'
        SERVICE_NAME = ''
        SERVICE_VERSION = ''
        JAR_PATH = ''
        DOCKER_IMAGE = ''
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
                    DOCKER_IMAGE = "dylar/qcar-${SERVICE_NAME}:${SERVICE_VERSION}"

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
                dir("${SERVICE_DIR}") {
                    sh '''
                        docker build --build-arg JAR_FILE=${JAR_PATH} -t ${DOCKER_IMAGE} . &&
                        docker push ${DOCKER_IMAGE}
                    '''
//                 docker.build(DOCKER_IMAGE, "--build-arg JAR_FILE=${JAR_PATH} .")
//                 docker.push(DOCKER_IMAGE)
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
