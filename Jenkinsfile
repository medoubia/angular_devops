pipeline {
    agent any

    environment {
        // SonarQube server URL and token
        SONAR_HOST_URL = 'http://localhost:9000'
        SONAR_TOKEN = 'sqp_b1c84db3309bede3505a8c2409989ba8df7faf4d'
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
                        sonar-scanner \
  -Dsonar.projectKey=Angular \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=sqp_37f681dfe76d12bb67692462b895e9bb91a13387
                    '''
                }
            }
        }

        stage("Deploy Docker Container") {
            steps {
                script {
                    sh 'docker stop your-angular-app1-container || true'
                    sh 'docker rm your-angular-app1-container || true'
                    sh 'docker run -d -p 8080:80 --name your-angular-app1-container your-angular-app1'
                }
            }
        }
    }
}
