pipeline {
    agent none // Prevent the entire pipeline from locking a single executor
    stages {
        stage('Run Tests in Parallel') {
            parallel {
                stage('Run UI Tests') {
                    agent { dockerfile true }
                    steps {
                        sh 'robot --outputdir results --output output_ui.xml --log log_ui.html --report report_ui.html tests/suites/smoke/order_from_webshop.robot'
                        stash name: 'results', includes: 'results/**/*' // Stash the UI results
                    }
                }
                stage('Run API Tests') {
                    agent { dockerfile true }
                    steps {
                        sh 'robot --outputdir results2 --output output_api.xml --log log_api.html --report report_api.html tests/suites/api/api_tests.robot'
                        stash name: 'results2', includes: 'results2/**/*' // Stash the API results
                    }
                }
            }
        }
        // Stage to archive the results after the tests have finished
        stage('Archive Results') {
            agent any // Use the agent with the label 'vagrant-node'
            steps {
                // Unstash the UI results and archive them
                unstash 'results'
                archiveArtifacts artifacts: 'results/**/*', allowEmptyArchive: true

                // Unstash the API results and archive them
                unstash 'results2'
                archiveArtifacts artifacts: 'results2/**/*', allowEmptyArchive: true

                // Robot Framework plugin configuration for UI tests
                robot(
                    outputPath: "results",
                    passThreshold: 90.0,
                    unstableThreshold: 70.0,
                    disableArchiveOutput: true,
                    outputFileName: "output_ui.xml",
                    logFileName: 'log_ui.html',
                    reportFileName: 'report_ui.html',
                    countSkippedTests: true,
                    otherFiles: 'screenshot-*.png'
                )

                // Robot Framework plugin configuration for API tests
                robot(
                    outputPath: "results2",
                    passThreshold: 90.0,
                    unstableThreshold: 70.0,
                    disableArchiveOutput: true,
                    outputFileName: "output_api.xml",
                    logFileName: 'log_api.html',
                    reportFileName: 'report_api.html',
                    countSkippedTests: true,
                    otherFiles: 'screenshot-*.png'
                )
            }
        }
    }
}