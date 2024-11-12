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

       stage("Test Security with SonarQube") {
    steps {
        script {
            // Running SonarQube analysis within the SonarQube environment
            withSonarQubeEnv('SonarQube') {  // 'SonarQube' is the name of the SonarQube instance in Jenkins
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
