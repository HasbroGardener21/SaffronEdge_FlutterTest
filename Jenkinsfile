pipeline {
    agent any

    environment {
        ANDROID_HOME = 'C:\\Users\\harsh\\AppData\\Local\\Android\\Sdk'
        JAVA_HOME = 'C:\\Program Files\\Eclipse Adoptium\\jdk-21.0.12.101-hotspot'
    }

    stages {
        stage('Checkout') {
            steps {
                // Pulls the code from your GitHub repository
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                // Fetches the Flutter packages using the absolute path
                bat 'C:\\tools\\flutter_windows_3.47.5-stable\\flutter\\bin\\flutter.bat pub get'
            }
        }

        stage('Build APK') {
            steps {
                // Builds the release APK for Android using the absolute path
                bat 'C:\\tools\\flutter_windows_3.47.5-stable\\flutter\\bin\\flutter.bat build apk --release'
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution complete.'
        }
        success {
            echo 'Build successful!'
            // Archives the built APK so it appears as a downloadable artifact on the Jenkins build page
            archiveArtifacts artifacts: 'build/app/outputs/flutter-apk/app-release.apk', fingerprint: true
        }
        failure {
            echo 'Build failed. Check the logs for details.'
        }
    }
}
