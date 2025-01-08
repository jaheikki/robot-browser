pipeline {
    agent none  // Prevent the entire pipeline from locking a single executor
    stages {
        stage('Run Tests in Parallel') {
            parallel {
                stage('Run UI Tests') {
                    agent { dockerfile true }
                    steps {
                        sh 'robot --outputdir results_ui tests/suites/smoke/order_from_webshop.robot'
                        stash name: 'results_ui', includes: 'results_ui/**/*'  // Stash the UI results
                    }
                }
                stage('Run API Tests') {
                    agent { dockerfile true }
                    steps {
                        sh 'robot --outputdir results_api tests/suites/api/api_tests.robot'
                        stash name: 'results_api', includes: 'results_api/**/*'  // Stash the API results
                    }
                }
            }
        }
        
        // Stage to archive the results after the tests have finished
        stage('Archive Results') {
            agent { label 'vagrant-node' }  // Use the agent with the label 'vagrant-node'
            steps {
                unstash 'results_ui'  // Unstash the UI results
                unstash 'results_api'  // Unstash the API results

                // Archive the results
                archiveArtifacts artifacts: 'results_ui/**/*', allowEmptyArchive: true
                archiveArtifacts artifacts: 'results_api/**/*', allowEmptyArchive: true
                
                // Robot Framework plugin configuration for UI results
                script {
                    def uiResults = 'results_ui/output.xml'
                    def uiLog = 'results_ui/log.html'
                    def uiReport = 'results_ui/report.html'
                    if (fileExists(uiResults)) {
                        robot(
                            outputPath: "results_ui",  // Match the output directory for UI tests
                            passThreshold: 90.0,
                            unstableThreshold: 70.0,
                            disableArchiveOutput: true,
                            outputFileName: "output.xml",
                            logFileName: 'log.html',
                            reportFileName: 'report.html',
                            countSkippedTests: true,
                            otherFiles: 'screenshot-*.png'
                        )
                    }
                }

                // Robot Framework plugin configuration for API results
                script {
                    def apiResults = 'results_api/output.xml'
                    def apiLog = 'results_api/log.html'
                    def apiReport = 'results_api/report.html'
                    if (fileExists(apiResults)) {
                        robot(
                            outputPath: "results_api",  // Match the output directory for API tests
                            passThreshold: 90.0,
                            unstableThreshold: 70.0,
                            disableArchiveOutput: true,
                            outputFileName: "output.xml",
                            logFileName: 'log.html',
                            reportFileName: 'report.html',
                            countSkippedTests: true,
                            otherFiles: 'screenshot-*.png'
                        )
                    }
                }
            }
        }
    }
}
