pipeline {
  agent { dockerfile true }

  stages {
    parallel {
      stage('Run UI Tests') {
        steps {
          sh '''
            robot --outputdir results tests/suites/smoke/order_from_webshop.robot
          '''
        }
        stage('Run API Tests') {
        steps {
          sh '''
            robot --outputdir results2 tests/suites/smoke/order_from_webshop.robot
          '''
        }
      }
    }
    stage('Archive Results') {
      steps {
        archiveArtifacts artifacts: 'results/**/*'
        archiveArtifacts artifacts: 'results2/**/*'
        // robot(outputPath: "results",
        //   passThreshold: 90.0,
        //   unstableThreshold: 70.0,
        //   disableArchiveOutput: true,
        //   outputFileName: "output.xml",
        //   logFileName: 'log.html',
        //   reportFileName: 'report.html',
        //   countSkippedTests: true,    // Optional, defaults to false
        //   otherFiles: 'screenshot-*.png'
        // )
      }
    }
  }
}
