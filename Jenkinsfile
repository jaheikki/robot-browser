pipeline {
  agent { dockerfile true }

  stages {
    stage('Run Robot Tests') {
      steps {
        sh '''
          pwd
          ls -ltr results
          ls -ltr /opt/robotframework/
          ls -ltr /opt/robotframework/results
        '''
      }
    }
    stage('Archive Results') {
      steps {
        archiveArtifacts artifacts: 'results/**/*'
        robot(outputPath: "results",
          passThreshold: 90.0,
          unstableThreshold: 70.0,
          disableArchiveOutput: true,
          outputFileName: "output.xml",
          logFileName: 'log.html',
          reportFileName: 'report.html',
          countSkippedTests: true,    // Optional, defaults to false
          otherFiles: 'screenshot-*.png'
        )
      }
    }
  }
}
