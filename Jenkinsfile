pipeline {
    agent none  // Prevent the entire pipeline from locking a single executor
    stages {
        stage('Run Tests in Parallel') {
            parallel {
                stage('Run UI Tests') {
                    agent { dockerfile { true }
                    steps {
                        sh 'robot --outputdir results tests/suites/smoke/order_from_webshop.robot'
                    }
                }
                stage('Run API Tests') {
                    agent { dockerfile { true }
                    steps {
                        sh 'robot --outputdir results2 tests/suites/api/api_tests.robot'
                    }
                }
            }
        }    
        // stage('Archive Results') {
        //     steps {
        //         archiveArtifacts artifacts: 'results/**/*'
        //         archiveArtifacts artifacts: 'results2/**/*'
        //         // Uncomment and customize the Robot Framework plugin configuration if required
        //         // robot(outputPath: "results",
        //         //   passThreshold: 90.0,
        //         //   unstableThreshold: 70.0,
        //         //   disableArchiveOutput: true,
        //         //   outputFileName: "output.xml",
        //         //   logFileName: 'log.html',
        //         //   reportFileName: 'report.html',
        //         //   countSkippedTests: true,
        //         //   otherFiles: 'screenshot-*.png'
        //         // )
        //     }
        // }
    }
}

       
