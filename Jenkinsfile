pipeline {
    agent any

    environment {
        // SonarQube server URL and token
        SONAR_HOST_URL = 'http://localhost:9000'
        SONAR_TOKEN = 'sqp_b1c84db3309bede3505a8c2409989ba8df7faf4d'
        // Adding the SonarScanner path
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
                    // Running SonarQube analysis
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
                          -Dsonar.token=$SONAR_TOKEN
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {  // Set a timeout of 5 minutes
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
}
