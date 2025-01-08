pipeline {
    agent none  // Prevent the entire pipeline from locking a single executor
    stages {
        stage('Run Tests in Parallel') {
            parallel {
                stage('Run UI Tests') {
                    agent { dockerfile true }
                    steps {
                        sh 'robot --outputdir results tests/suites/smoke/order_from_webshop.robot'
                    }
                }
                stage('Run API Tests') {
                    agent { dockerfile true }
                    steps {
                        sh 'robot --outputdir results2 tests/suites/api/api_tests.robot'
                    }
                }
            }
        }
        
        // Stage to archive the results after the tests have finished
        stage('Archive Results') {
            agent any  // This will allocate a node for the Archive Results stage
            steps {
                archiveArtifacts artifacts: 'results/**/*', allowEmptyArchive: true
                archiveArtifacts artifacts: 'results2/**/*', allowEmptyArchive: true
                
                // Robot Framework plugin configuration
                robot(
                    outputPath: "results",
                    passThreshold: 90.0,
                    unstableThreshold: 70.0,
                    disableArchiveOutput: true,
                    outputFileName: "output.xml",
                    logFileName: 'log.html',
                    reportFileName: 'report.html',
                    countSkippedTests: true,
                    otherFiles: 'screenshot-*.png'
                )
                robot(
                    outputPath: "results2",
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
