pipeline {
    agent any

    environment {
        SERVICE_DIR = 'services/main_service'
        SERVICE_NAME = ''
        SERVICE_VERSION = ''
        JAR_PATH = ''

        CONTAINER_NAME = ''
        CONTAINER_IMAGE = ''
        CONTAINER_REGISTRY = 'https://hub.docker.com/'
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
                    CONTAINER_NAME = "dylar/qcar-${SERVICE_NAME}"
                    CONTAINER_IMAGE = "${CONTAINER_NAME}:${SERVICE_VERSION}"

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

    stage('Build & Push Image') {
        steps {
            script {
                podTemplate(containers: [
                    containerTemplate(
                        name: 'kaniko',
                        image: 'gcr.io/kaniko-project/executor:latest',
                        command: 'cat',
                        ttyEnabled: true,
                        volumeMounts: [
                            volumeMount(
                                mountPath: '/root/.docker',
                                name: 'docker-config'
                            )
                        ]
                    )
                ],
                volumes: [secretVolume(secretName: 'docker-hub-credentials', mountPath: '/root/.docker')]) {
                    // Run the Kaniko container
                    container('kaniko') {
                        sh "executor --context ${WORKSPACE}/${SERVICE_DIR} --dockerfile ${WORKSPACE}/${SERVICE_DIR}/Dockerfile --destination ${CONTAINER_IMAGE}"
                    }
                }
            }
        }
    }
        stage('Update Kubernetes Deployment') {
            steps {
                // Set the new image in the Kubernetes deployment
                sh "kubectl set image deployment/${SERVICE_NAME} ${SERVICE_NAME}=${CONTAINER_IMAGE}"
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
