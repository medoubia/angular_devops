 pipeline {
    agent any

    environment {
        // SonarQube server URL and token
        SONAR_HOST_URL = 'http://localhost:9000'
        SONAR_TOKEN = 'sqa_1ad621b299a30105a78f2dc542563732afce874c'
        // Adding the SonarScanner path
        PATH = "/opt/sonar-scanner/bin:$PATH"
    }

    stages {
        stage("Build Docker Imag") {
            steps {
                script {
                    sh 'docker build -t your-angular-app1 .'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    def scannerHome = tool 'SonnarScanner'
                    withSonarQubeEnv('SonarQube') {
                        sh """
                            ${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=GitlabMx \
                            -Dsonar.host.url=http://localhost:9000 \
                            -Dsonar.login=sqa_1ad621b299a30105a78f2dc542563732afce874c \
                            -Dsonar.sources=./app \
                            -Dsonar.exclusions="vendor/*,storage/**,bootstrap/cache/*"
                        """
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
