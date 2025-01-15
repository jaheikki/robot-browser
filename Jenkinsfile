pipeline {
    agent none
    environment {
        DOCKER_IMAGE = "robotframework-browser:${env.BUILD_NUMBER}"
    }
    stages {
        stage('Build Docker Image') {
            agent { label 'vagrant-node' }
            steps {
                sh """
                docker build -t ${DOCKER_IMAGE} -f Dockerfile .
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
                        sh 'robot --outputdir results_ui tests/suites/smoke/order_from_webshop.robot'
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
                        sh 'robot --outputdir results_api tests/suites/api/api_tests.robot'
                        archiveArtifacts artifacts: 'results_api/**/*', allowEmptyArchive: true
                    }
                }
            }
        }
    }
}
