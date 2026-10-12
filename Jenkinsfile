pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Pulls the code from your GitHub repository
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                // Fetches the Flutter packages
                bat 'flutter pub get'
            }
        }

        stage('Run Tests') {
            steps {
                // Runs unit tests (if you have them in the 'test' folder)
                bat 'flutter test'
            }
        }

        stage('Build APK') {
            steps {
                // Builds the release APK for Android
                bat 'flutter build apk --release'
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution complete.'
        }
        success {
            echo 'Build successful!'
        }
        failure {
            echo 'Build failed. Check the logs for details.'
        }
    }
}