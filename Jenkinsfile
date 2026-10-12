pipeline {
    agent any

    environment {
        ANDROID_HOME = 'C:\\Users\\harsh\\AppData\\Local\\Android\\Sdk'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                bat 'C:\\tools\\flutter_windows_3.47.5-stable\\flutter\\bin\\flutter.bat pub get'
            }
        }
        
        stage('Build APK') {
            steps {
                bat 'C:\\tools\\flutter_windows_3.47.5-stable\\flutter\\bin\\flutter.bat build apk --release'
            }
        }
    }
    
    post {
        success {
            echo 'Build successful!'
        }
        failure {
            echo 'Build failed. Check the logs for details.'
        }
    }
}
