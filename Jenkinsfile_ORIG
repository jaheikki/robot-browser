pipeline {
    agent none  // Prevent the entire pipeline from locking a single executor
    stages {
        stage('Run Tests in Parallel') {
            parallel {
                stage('Run UI Tests') {
                    agent { dockerfile true }
                    steps {
                        // Run the UI tests
                        sh 'robot --outputdir results_ui tests/suites/smoke/order_from_webshop.robot'
                        archiveArtifacts artifacts: 'results_ui/**/*', allowEmptyArchive: true
                    }
                }
                stage('Run API Tests') {
                    agent { dockerfile true }
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
