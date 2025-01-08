pipeline {
    agent none // Prevent the entire pipeline from locking a single executor
    stages {
        stage('Run Tests in Parallel') {
            parallel {
                stage('Run UI Tests') {
                    agent { dockerfile true }
                    steps {
                        sh 'robot --outputdir results_ui tests/suites/smoke/order_from_webshop.robot'
                        stash name: 'results_ui', includes: 'results_ui/**/*' // Stash the UI results
                    }
                }
                stage('Run API Tests') {
                    agent { dockerfile true }
                    steps {
                        sh 'robot --outputdir results_api tests/suites/api/api_tests.robot'
                        stash name: 'results_api', includes: 'results_api/**/*' // Stash the API results
                    }
                }
            }
        }
        // Stage to archive the results after the tests have finished
        stage('Archive Results') {
            agent { label 'vagrant-node' } 
            steps {
                // Unstash the UI results and archive them
                unstash 'results_ui'
                archiveArtifacts artifacts: 'results_ui/**/*', allowEmptyArchive: true

                // Unstash the API results and archive them
                unstash 'results_api'
                archiveArtifacts artifacts: 'results_api/**/*', allowEmptyArchive: true
            }
        }
    }
}