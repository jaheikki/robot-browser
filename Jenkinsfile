pipeline {
    agent none
    environment {
        DOCKER_IMAGE = "robotframework-sbrowser:${env.BUILD_NUMBER}"
    }
    stages {
        stage('Build Docker Image') {
            agent { label 'vagrant-node' }
            steps {
                sh """
                docker build --platform=linux/amd64 -t ${DOCKER_IMAGE} .
                """
            }
        }
        stage('Run Tests in Parallel') {
            parallel {
                stage('Run UI Tests') {
                    agent {
                        docker {
                            image "${DOCKER_IMAGE}"
                        }
                    }
                    steps {
                        // Run the UI tests
                        sh 'robot --outputdir results_ui tests/ui/saucedemo_order_test.robot'
                        archiveArtifacts artifacts: 'results_ui/**/*', allowEmptyArchive: true
                    }
                }
                stage('Run API Tests') {
                    agent {
                        docker {
                            image "${DOCKER_IMAGE}"
                        }
                    }
                    steps {
                        // Run the API tests
                        sh 'robot --outputdir results_api tests/api/api_tests.robot'
                        archiveArtifacts artifacts: 'results_api/**/*', allowEmptyArchive: true
                    }
                }
            }
        }
    }
}
