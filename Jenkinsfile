pipeline {
    agent any
    environment {
        ROBOT_HOME = '/path/to/robot'  // Define path to Robot Framework (if needed)
    }
    stages {
        stage('Prepare') {
            steps {
                // Setup the environment or install dependencies if needed
                script {
                    // Any initial setup steps can go here
                }
            }
        }

        stage('Run UI Tests') {
            steps {
                // Run UI tests inside the first container
                sh 'robot --outputdir results_ui tests/suites/smoke/order_from_webshop.robot'
                stash name: 'results_ui', includes: 'results_ui/**/*'  // Stash the UI results
            }
        }

        stage('Run API Tests') {
            steps {
                // Run API tests inside the second container
                sh 'robot --outputdir results_api tests/suites/api/api_tests.robot'
                stash name: 'results_api', includes: 'results_api/**/*'  // Stash the API results
            }
        }

        stage('Archive Results') {
            steps {
                // Unstash UI results and archive them
                unstash 'results_ui'
                archiveArtifacts artifacts: 'results_ui/**/*', allowEmptyArchive: true

                // Unstash API results and archive them
                unstash 'results_api'
                archiveArtifacts artifacts: 'results_api/**/*', allowEmptyArchive: true
            }
        }

        stage('Robot Framework Results') {
            steps {
                // Run Robot Framework analysis for UI results
                robot(
                    outputPath: 'results_ui',  // Specify UI results directory
                    passThreshold: 90.0,
                    unstableThreshold: 70.0,
                    disableArchiveOutput: true,  // Disable default output archive
                    outputFileName: 'output.xml',
                    logFileName: 'log.html',
                    reportFileName: 'report.html',
                    countSkippedTests: true,
                    otherFiles: 'screenshot-*.png'
                )

                // Run Robot Framework analysis for API results
                robot(
                    outputPath: 'results_api',  // Specify API results directory
                    passThreshold: 90.0,
                    unstableThreshold: 70.0,
                    disableArchiveOutput: true,  // Disable default output archive
                    outputFileName: 'output.xml',
                    logFileName: 'log.html',
                    reportFileName: 'report.html',
                    countSkippedTests: true,
                    otherFiles: 'screenshot-*.png'
                )
            }
        }

        stage('Publish Results') {
            steps {
                // Publish the Robot Framework results, e.g., HTML reports
                publishHTML(
                    target: [
                        reportName: 'UI Test Report',
                        reportDir: 'results_ui',
                        reportFiles: 'report.html'
                    ]
                )

                publishHTML(
                    target: [
                        reportName: 'API Test Report',
                        reportDir: 'results_api',
                        reportFiles: 'report.html'
                    ]
                )
            }
        }

        stage('Clean Up') {
            steps {
                // Clean up after the build if necessary
                cleanWs()  // Clean workspace if necessary
            }
        }
    }
    post {
        always {
            // Always run actions, e.g., notifications, after the build completes
        }
    }
}
