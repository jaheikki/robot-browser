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

                        // Robot Framework plugin configuration to process results
                        robot(
                            outputPath: 'results_ui',
                            passThreshold: 90.0,
                            unstableThreshold: 70.0,
                            disableArchiveOutput: true,  // Don't archive output via robot plugin itself
                            outputFileName: "output.xml",
                            logFileName: 'log.html',
                            reportFileName: 'report.html',
                            countSkippedTests: true,
                            otherFiles: 'screenshot-*.png'
                        )

                        // Archive the results after processing
                        archiveArtifacts artifacts: 'results_ui/**/*', allowEmptyArchive: true
                    }
                }
                stage('Run API Tests') {
                    agent { dockerfile true }
                    steps {
                        // Run the API tests
                        sh 'robot --outputdir results_api tests/suites/api/api_tests.robot'

                        // Robot Framework plugin configuration to process results
                        robot(
                            outputPath: 'results_api',
                            passThreshold: 90.0,
                            unstableThreshold: 70.0,
                            disableArchiveOutput: true,  // Don't archive output via robot plugin itself
                            outputFileName: "output.xml",
                            logFileName: 'log.html',
                            reportFileName: 'report.html',
                            countSkippedTests: true,
                            otherFiles: 'screenshot-*.png'
                        )

                        // Archive the results after processing
                        archiveArtifacts artifacts: 'results_api/**/*', allowEmptyArchive: true
                    }
                }
            }
        }
    }
}
