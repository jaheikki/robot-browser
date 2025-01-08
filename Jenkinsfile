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
    }
}

       
