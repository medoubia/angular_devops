pipeline {
    agent any

    environment {
        // Ensure SonarQube details are securely managed through Jenkins credentials
        SONAR_HOST_URL = 'http://localhost:9000'
        SONAR_TOKEN = credentials('sonar-token')  // Use Jenkins credentials plugin for security
        PATH = "/opt/sonar-scanner/bin:$PATH"
    }

    stages {
        stage("Build Docker Image") {
            steps {
                script {
                    sh 'docker build -t your-angular-app1 .'
                }
            }
        }

        stage("Test Security with SonarQube") {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {  // 'SonarQube' is the name of the SonarQube instance configured in Jenkins
                        sh '''
                            # Ensure PATH includes SonarScanner
                            export PATH=/opt/sonar-scanner/bin:$PATH
                            echo "Current PATH: $PATH"
                            which sonar-scanner

                            # Run SonarScanner
                            sonar-scanner \
                              -Dsonar.projectKey=Angular \
                              -Dsonar.sources=. \
                              -Dsonar.host.url=$SONAR_HOST_URL \
                              -Dsonar.login=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {  // Increased timeout for Quality Gate
                    script {
                        def qualityGate = waitForQualityGate(abortPipeline: true)  // Wait for the quality gate result and abort if it fails
                        if (qualityGate.status != 'OK') {
                            error "Quality Gate failed. Aborting pipeline."
                        }
                    }
                }
            }
        }

        stage("Deploy Docker Container") {
            steps {
                script {
                    sh 'docker stop your-angular-app1-container || true'
                    sh 'docker rm your-angular-app1-container || true'
                    sh 'docker run -d -p 8087:80 --name your-angular-app1-container your-angular-app1'
                }
            }
        }
    }

    post {
        always {
            // Clean up any leftover Docker containers or images if needed
            sh 'docker system prune -f'  // Optional cleanup step
        }
    }
}
